Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYACVdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYACVdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYACVcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:32:55 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:42591 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbYACVcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:32:53 -0500
Date: Thu, 3 Jan 2008 22:32:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Kbuild update
Message-ID: <20080103213255.GA21811@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild.git contains at the moment 36 patches which is all for the upcoming merge window.
It has been rebased to latest -linus git tree.
See shortlog below.

Pending patches
===============
kbuild:
- Section garbage collection (Denys Vlasenko)
  I had too little time to play with it so it will not hit this merge window :-(
- Improved stripping (Jan Beulich)
  needs review
- Enhance make rpm (Florin Andrei)
  needs review
- merge uboot mkimage (Josh Boyer)
  await an update with a renamed script, maybe I already got it

kconfig:
- Access enviromnet variables (Roman Zippel)
  seems I have lost the original patch - needs to serach lkml.org
- arch/Kconfig (Mathieu)
  (Maybe Andrew have them, needs follow up)
- xconfig search dialog (Shlomi Fish)
  needs review + test

Known issues
============
kbuild:
- make rpm are reported buggy
  I have plenty of mails with bug reports but no patches and I do not know rpm myself
- zillion of mails from Robert P. J. Day


kconfig:
- Segmentation violation when seeing recursive symbols
  I added the bug but have not had time to fix it yet 

TODO items (from my mailbox - I have plenty more)
=================================================
- asm-offset useable from modules (Oleg had a half backed solution)
- modpost should use err(), warn() etc (suggestyed by Rusty)
- less kernel hardcoding in kconfig (Rob Landley)
- emit dependencies from "depends" (Bernhard Fischer)
- fix select (whatever that means)
- allow kconfig to accept overrides (Jan Engelhart)
  maybe there is a patch, needs followup
- document kernel build better (Andreas Hermann)
  just a start, more is needed
- save ARCH and CROSSCOMPILE
  requires major surgery to do correct - we use CC too early
- i18n patch for mconf and friends (from Kernel Translator project)
  is old but several bits of it needs to be applied to better support i18n
- i18n support in kernel
  some like it, others don't. But now we have japanese versions of some docs...
- use GCC --combine (David Woodhouse)
- more color themes (Jan Engelhart)
  and I would like them selectable from inside menuconfig
- walk throug the ~15 qconf related patched - are they relevant?
- document use of __init and related sections
- Use seperate sections for all init sections to improve checking
- improve headers_check (10x speed up is possible by doing a dir-by-dir check)

bugzilla.kernel.org
===================
7103 	sam@ravnborg.org 	NEW 		2.6.17.* 	initramfs problem
3174 	sam@ravnborg.org 	ASSI 		2.6.7 	        make rpm creates erroneous version number
3486 	sam@ravnborg.org 	ASSI 		2.6.4-52 	"make clean" on external driver will clean the kernel sou...
6860 	sam@ravnborg.org 	ASSI 		2.6.18-rc1 	'make deb-pkg' create incorrect package name
7042 	sam@ravnborg.org 	ASSI 		2.6.17.7 	Recursing into /lib/modules/`uname -r`/build infects my b...
8275 	sam@ravnborg.org 	ASSI 		2.6.21-rc5-g28d... 	make rpm-pkg broken for git cloned sources

On top of this I have my personal todo items such as:
- document kconfig a bit
- make it possible to include all kconfig files
- clean up kconfig files
- documet use of HAVE_ in kconfig files
- modern ncurses interface for menuconfig (ala tig, htop and others)
- etc...

So all in all no reasons to be bored.
Did you send me a patch that is neither listed above nor below then please resend.
Any help with the above are much appreciated!

Note: The kbuild stuff is done only in my spare time and
      with 3 kids, a wife and a full-time job I am often lacking behind.

	Sam
 

Adrian Bunk (1):
      Remove references to "make dep"

Andi Kleen (3):
      kbuild: declare the modpost error functions as printf like
      kbuild: fix format string warnings in modpost
      kbuild: fix a buffer overflow in modpost

Andreas Mohr (1):
      kbuild: eradicate bashisms in scripts/patch-kernel

Andres Salomon (1):
      kconfig: use getopt() in conf.c for handling command line arguments

Aron Griffis (1):
      kbuild: support mercurial in setlocalversion

Geert Uytterhoeven (1):
      kbuild: Add missing srctree prefix for includecheck and versioncheck

Johannes Berg (7):
      kernel-doc: fix xml output mode
      kernel-doc: init kernel version
      kernel-doc: single DOC: selection
      kernel-doc: process functions, not DOC:
      kernel-doc: use no-doc option
      kernel-doc: new P directive for DOC: sections
      convert drivers/base/power/Makefile to ccflags

Ladislav Michl (1):
      kconfig: make kconfig MinGW friendly

Mike Frysinger (1):
      kbuild: fixup genksyms usage/getopt

Randy Dunlap (2):
      kbuild: add 'includecheck' help text
      kconfig: add hints/tips/tricks to Documentation/kbuild/kconfig-language.txt

Robert P. J. Day (2):
      Kbuild: Clarify the rpm-related make packaging targets
      A few corrections to include/linux/Kbuild

Sam Ravnborg (5):
      kbuild: document versioncheck in make help
      kconfig: if ncurses-devel is missing then say so
      kbuild: fix buglet in gcc-version.sh
      kbuild: ignore *.order files
      kbuild: fix installing external modules

Tejun Heo (1):
      kbuild: implement modules.order

Theodore Ts'o (3):
      kbuild: change CONFIG_LOCALVERSION_AUTO to use a git-describe-ish format
      kbuild: fix scripts/setlocalversion to avoid erroneous -dirty tag
      kbuild: fix false positive -dirty tag caused by make-kpkg

Vegard Nossum (1):
      aic7(3*x): fix firmware build

WANG Cong (5):
      MIPS: Remove 'TOPDIR' from Makefiles
      CRIS: Remove 'TOPDIR' from Makefiles
      INFINIBAND: Remove 'TOPDIR' from Makefiles
      FRV: Drop 'TOPDIR' from Makefiles
      FS: Remove dead code

The full diffstat is:
 .gitignore                                  |    1 +
 Documentation/kbuild/kconfig-language.txt   |   54 +++++++++++++++--
 Makefile                                    |   15 ++++-
 arch/arm/mach-imx/Makefile                  |    3 -
 arch/arm/mach-netx/Makefile                 |    3 -
 arch/cris/arch-v32/boot/compressed/Makefile |    2 +-
 arch/frv/boot/Makefile                      |    8 +-
 arch/frv/kernel/gdb-stub.c                  |    2 +-
 arch/mips/lasat/image/Makefile              |    4 +-
 arch/mips/tx4927/common/Makefile            |    4 -
 arch/mips/tx4938/common/Makefile            |    4 -
 arch/mips/tx4938/toshiba_rbtx4938/Makefile  |    4 -
 arch/sh64/kernel/Makefile                   |    4 -
 arch/sh64/lib/Makefile                      |    4 -
 arch/sh64/mach-cayman/Makefile              |    4 -
 arch/sh64/mm/Makefile                       |    4 -
 arch/xtensa/mm/Makefile                     |    4 -
 arch/xtensa/platform-iss/Makefile           |    5 --
 drivers/base/power/Makefile                 |    8 +--
 drivers/infiniband/hw/cxgb3/Makefile        |    3 +-
 drivers/scsi/aic7xxx/Makefile               |   45 ++++++---------
 fs/smbfs/Makefile                           |   20 ------
 include/linux/Kbuild                        |    8 +-
 scripts/Makefile.build                      |   17 +++++-
 scripts/Makefile.lib                        |    6 ++
 scripts/Makefile.modinst                    |    2 +-
 scripts/basic/docproc.c                     |   44 +++++++++++++-
 scripts/gcc-version.sh                      |    5 +-
 scripts/genksyms/genksyms.c                 |   10 ++-
 scripts/kconfig/Makefile                    |   14 +++--
 scripts/kconfig/conf.c                      |   24 ++++----
 scripts/kconfig/lxdialog/check-lxdialog.sh  |   16 +++--
 scripts/kconfig/lxdialog/dialog.h           |    5 +-
 scripts/kconfig/lxdialog/util.c             |   32 +++++++----
 scripts/kconfig/mconf.c                     |   61 +++----------------
 scripts/kernel-doc                          |   85 ++++++++++++++++++--------
 scripts/mod/modpost.c                       |   18 ++++--
 scripts/package/Makefile                    |    5 +-
 scripts/patch-kernel                        |   22 +++----
 scripts/setlocalversion                     |   29 +++++++++-
 40 files changed, 338 insertions(+), 270 deletions(-)


