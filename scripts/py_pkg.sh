#!/bin/bash
set -e
set -u

source_code_path=$(realpath "$source_code_path")

cd "$path_cwd"
[ -d "$dir_name" ] || mkdir "$dir_name"

#virtual env setup
cd "$path_module"
virtualenv -p $runtime env-$function_name
set +u
source env-$function_name/bin/activate
set -u

#installing python dependencies
FILE="$source_code_path/requirements.txt"
if [ -f $FILE ]; then
  echo "requirement.txt file exists in source_code_path. Installing dependencies.."
  pip install -q -r $FILE --upgrade
else
  echo "requirement.txt file does not exist. Skipping installation of dependencies."
fi

#deactivate virtualenv
deactivate

#creating deployment package
cd env-$function_name/lib/$runtime/site-packages/
cp -a . "$path_cwd/$dir_name"
cp -a "$source_code_path/." "$path_cwd/$dir_name"

#removing virtual env folder
rm -rf $path_module/env-$function_name/
