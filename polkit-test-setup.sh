#!/bin/bash

# This script needs sudo privileges.
# ---------------------------------------------------------------------------
if [[ $(id -u) -ne 0 ]]; then
    echo "This script needs to be run with root privileges. Exiting."
    exit 1
fi

BASE=$(realpath $(dirname $0))
installs=install-files
BIN=/usr/bin
POLKIT=/usr/share/polkit-1/actions
bin=wasta-snap-manager-root
action=org.wasta.apps.wasta-snap-manager-root.policy

if [[ ! $1 ]]; then
    # Create symlink for binary.
    cd "$BIN"
    cp -s "$BASE"/"$installs"/bin/"$bin" .
    echo "symlink for $BASE/$installs/bin/$bin created at $BIN"
    # Create symlink for polkit file.
    cd "$POLKIT"
    cp -s "$BASE"/"$installs"/"$action" .
    echo "symlink for $BASE/$installs/$action created at $POLKIT"

elif [[ $1 == '-d' ]]; then
    # Remove symlinks.
    if [[ -L $BIN/$bin ]]; then
        rm "$BIN"/"$bin"
        echo "symlink at $BIN/$bin removed"
    fi
    if [[ -L "$POLKIT"/"$action" ]]; then
        rm "$POLKIT"/"$action"
        echo "symlink at $POLKIT/$action removed"
    fi
elif [[ $1 == '-h' ]]; then
    echo "Usage: $0 [-h | -d]"
    echo "Simulate installation by creating symlinks for $bin"
    echo "and $action."
    echo "(These links will be removed if the -d option is passed.)"
    echo "The corresponding wasta-offline script still needs to be run explicitly;"
    echo "i.e. \$ $BASE/install-files/bin/wasta-offline."
fi

exit 0
