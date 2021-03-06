#!/usr/bin/env bash

export ALREADY_SOURCED_ASSERTS

if [ -z "${ALREADY_SOURCED_ASSERTS}" ]
then
    # Asserts the dependencies whose names are passed as parameters are
    # installed in the system.
    assert_installed()
    {

        # Check if the user wants to exit or return from this function.
        EXIT_IF_NOT_INSTALLED=1 # false

        if [ "$#" -ge  "1" ]
        then
            # In the case the first parameter is "contaminated", we just use the
            # default value.
            if [ "$1" = "0" ]
            then
                EXIT_IF_NOT_INSTALLED=0 # true
            fi
        fi

        # Iterate through the arguments starting from the second,
        # since the first represents the intent of the caller
        # to decide if to exit or return from this function.
        for (( arg = 2; arg <= $#; arg++ ))
        do
            command -v ${!arg}
            if [ $? != 0 ]
            then
                printf "%s'${!arg}' not installed. Install it first before
                proceeding. Exiting...%s\n" "${RED}" "${NORMAL}"
                if [ "$EXIT_IF_NOT_INSTALLED" = "0" ]
                then
                    exit 1
                else
                    return 1
                fi
            fi
        done

        if [ "$EXIT_IF_NOT_INSTALLED" = "1" ]
        then
            return 0
        fi
    }

    assert_python_module_installed()
    {
        if [ "$#" -ne  "1" ]
        then
            printf "%sCall this function with only one parameter, which
            represents the python module.%s\n" "${RED}" "${NORMAL}"
            return 1
        fi

        command -v "$1"

        if [ $? != 0 ]
        then
            printf "%sCommand '$1' not found.\n" "${RED}"
            printf "Do you want me to install '$1' using 'pip3.5' (y/n)?%s " "${NORMAL}"
            read -r ANSWER

            if echo "$ANSWER" | grep -iq "^y"
            then
                pip3.5 install "$1"
                printf "%sDone.%s\n" "${GREEN}" "${NORMAL}"
            else
                printf "%sCannot proceed. Exiting...%s\n" "${RED}" "${NORMAL}"
                exit 1
            fi

        fi
    }

    . ./_source_script.sh
    _source_script scripts colors

    ALREADY_SOURCED_ASSERTS="true"
fi