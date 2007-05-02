Return-Path: <linux-kernel-owner+w=401wt.eu-S1766955AbXEBUQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766955AbXEBUQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766956AbXEBUQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:16:50 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45961 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766955AbXEBUQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:16:49 -0400
Date: Wed, 2 May 2007 22:17:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [GIT PATCHES] kbuild, kconfig + Kconfig updates
Message-ID: <20070502201741.GD9044@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull latest kbuild/kconfig and Kconfig updates.
Most of these have been present in -mm although a bunch
of trivial updates has been applied the last week too.


Main changes
o Added cleanfile and cleanpatch scripts
  Useful to tidy up stuff before submission.
  The discussed checkpatch script may be a good third candidate
o section mismatch does now include vmlinux so expect a few new warnings
o Ignore section mismatch warnings in several cases to bring down false positives significantly
o complain about missing system calls
  The way to find missing system calls was discussed but in general the current version
  was apprecated and triggered davem to add a few to sparc64 for example
o It is now possible to override build version and build timestamp using
  KBUILD_BUILD_VERSION and KBUILD_BUILD_TIMESTAMP
o One patch does some trivial fixes in several Kconfig files which
  caused some 'nosie' in the diffstat.
o Another patch deals with module alias which explain the changes in input.h

Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git

shortlog + diffstat below.

	Sam


Alex Landau (1):
      kbuild: handle compressed cpio initramfs-es

Alexander E. Patrakov (2):
      usr/Kconfig: fix typo
      kconfig: fix path to modules.txt in Kconfig help

Andreas Dilger (1):
      kconfig.debug: clarify CONFIG_DEBUG_INFO help text

Andy Green (1):
      kbuild: scripts/basic/fixdep segfault on pathological string-o-death

Anton Blanchard (1):
      kbuild: small documentation fix in Documentation/kbuild/modules.txt

Don Mullis (1):
      kbuild: move tags from ARCH and include/ ahead of drivers

H. Peter Anvin (2):
      cleanfile: a script to clean up stealth whitespace
      cleanpatch: a script to clean up stealth whitespace added by a patch

Marco Costalba (1):
      kconfig/xconfig: sync main view with search dialog current menu

Matthew Wilcox (1):
      kbuild: distinguish between errors and warnings in modpost

Michael Ellerman (1):
      kbuild: propagate errors from find in scripts/gen_initramfs_list.sh

Mike Frysinger (1):
      menuconfig: dont use obsolete index() function in lxdialog

Randy Dunlap (2):
      kbuild: be more explicit on missing .config file
      kernel-doc: alphabetically-sorted entries in index.html of 'htmldocs'

Robert P. J. Day (2):
      kbuild: clarify the creation of the LOCALVERSION_AUTO string.
      kconfig: correct minor typo in Kconfig warning message.

Sam Ravnborg (16):
      kbuild: fix section mismatch check for vmlinux
      kbuild: whitelist section mismatch in init/main.c
      kbuild: fix warnings from .pci_fixup section
      kbuild: fix segmentation fault in modpost
      kbuild: whitelist logo references from .text to .init.data
      kbuild: remove dependency on input.h from file2alias
      menuconfig: remember alternate config filename
      kbuild: do not emit src version warning for non-modules
      kbuild: complain about missing system calls
      kbuild: override build timestamp & version
      kconfig/menuconfig: do not hardcode '.config'
      kbuild: remove kconfig binaries during make mrproper
      kbuild: fix make mrproper for Documentation/DocBook/man
      kbuild: remove stale comment in modpost.c
      kbuild: ignore section mismatch warning for references from .paravirtprobe to .init.text
      kconfig: refer to qt3 if we cannot find qt libraries

Uwe Zeisberger (1):
      kbuild: add a missing slash in the comments

Uwe kleine-König (1):
      kbuild/mkuboot.sh: allow spaces in CROSS_COMPILE

 Documentation/DocBook/Makefile     |    9 +-
 Documentation/DocBook/man/Makefile |    3 -
 Documentation/kbuild/modules.txt   |    2 +-
 Kbuild                             |   11 ++
 Makefile                           |   15 ++-
 drivers/mtd/devices/Kconfig        |    4 +-
 drivers/net/Kconfig                |    6 +-
 drivers/net/wireless/Kconfig       |   12 +-
 drivers/scsi/Kconfig               |    4 +-
 drivers/video/Kconfig              |    8 +-
 include/linux/input.h              |    4 +
 include/linux/mod_devicetable.h    |    1 +
 init/Kconfig                       |   16 ++-
 init/main.c                        |    6 +-
 lib/Kconfig.debug                  |    3 +
 net/ipv6/netfilter/Kconfig         |    2 +-
 net/netfilter/Kconfig              |   24 ++--
 net/tipc/Kconfig                   |    2 +-
 scripts/Makefile.modpost           |    8 +-
 scripts/basic/fixdep.c             |    2 +
 scripts/checksyscalls.sh           |  118 ++++++++++++++++++++
 scripts/cleanfile                  |  126 ++++++++++++++++++++++
 scripts/cleanpatch                 |  206 ++++++++++++++++++++++++++++++++++++
 scripts/gen_initramfs_list.sh      |   12 ++-
 scripts/kconfig/Makefile           |    5 +-
 scripts/kconfig/conf.c             |    1 +
 scripts/kconfig/lkc.h              |    1 +
 scripts/kconfig/lxdialog/dialog.h  |    1 +
 scripts/kconfig/lxdialog/util.c    |    9 ++-
 scripts/kconfig/mconf.c            |   43 ++++++--
 scripts/kconfig/menu.c             |    2 +-
 scripts/kconfig/qconf.cc           |    5 +-
 scripts/kconfig/qconf.h            |    2 +-
 scripts/mkcompile_h                |   27 ++++--
 scripts/mkuboot.sh                 |    2 +-
 scripts/mod/file2alias.c           |   21 ++--
 scripts/mod/modpost.c              |  141 +++++++++++++++++++------
 scripts/mod/modpost.h              |    1 +
 scripts/mod/sumversion.c           |    5 +-
 usr/Kconfig                        |    2 +-
 40 files changed, 735 insertions(+), 137 deletions(-)
