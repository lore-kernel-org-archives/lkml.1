Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbXJOUt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbXJOUt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbXJOUsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:48:50 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35291 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbXJOUss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:48:48 -0400
Date: Mon, 15 Oct 2007 22:50:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: [GIT PULL (updated)] kbuild updates
Message-ID: <20071015205018.GA24467@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

The kbuild patches has been rebased on top of -linus after
the x86 merge.
The patch that caused ARCH to be unset has been withdrawn for
now. It had additional issues and I need to do additional changes
to get it included - in other words it will await next merge window.

The following patches does almost clear my patch queue. I have some
fixes pending but need some more time to check them out.
On top of this I have a few reports from -mm that needs attention too.
So in other words I expect a smaller set of patches for -rc1 or -rc2
as my time permits.

In addition to latest pull request this one includes:
- rename of
	CFLAGS => KBUILD_CFLAGS
	AFLAGS => KBUILD_AFLAGS
	CPPFLAGS => KBUILD_CPPFLAGS
    rationale behind this was two-fold:
    1) Do not let the CFLAGS environment variable impact all builds
    2) Allow one to specify addition gcc options on the commandline
       as make CLFAGS=-Os ...
- introducing ccflags-y, asflags-y and ldflags-y as the future
  replacement of the EXTRA_* variants.


The majority (line wise) is update of generated files.
The rest is almost all one-liners so nothing controversial.
The file with most lines changed is makefiles.txt!

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/sam/kbuild.git
	[Just pushed - It may need an additional hour to sync out...]
	
	Sam


 CREDITS                                |    6 +
 Documentation/kbuild/makefiles.txt     |   62 +-
 MAINTAINERS                            |    4 -
 Makefile                               |   57 +-
 arch/alpha/Makefile                    |    2 +-
 arch/alpha/kernel/Makefile             |    2 +-
 arch/alpha/lib/Makefile                |    2 +-
 arch/arm/Makefile                      |   14 +-
 arch/arm/boot/compressed/Makefile      |    2 +-
 arch/arm/vfp/Makefile                  |    2 +-
 arch/avr32/Makefile                    |    8 +-
 arch/blackfin/Kconfig                  |    2 +-
 arch/blackfin/Makefile                 |    4 +-
 arch/cris/Makefile                     |   10 +-
 arch/frv/Makefile                      |   32 +-
 arch/h8300/Makefile                    |   14 +-
 arch/h8300/lib/Makefile                |    3 -
 arch/i386/Makefile                     |   16 +-
 arch/ia64/Makefile                     |    4 +-
 arch/ia64/sn/kernel/Makefile           |    2 +-
 arch/ia64/sn/kernel/sn2/Makefile       |    2 +-
 arch/ia64/sn/pci/Makefile              |    2 +-
 arch/ia64/sn/pci/pcibr/Makefile        |    2 +-
 arch/m32r/Makefile                     |    8 +-
 arch/m68k/Makefile                     |    8 +-
 arch/m68knommu/Makefile                |    8 +-
 arch/m68knommu/platform/5206/Makefile  |    2 +-
 arch/m68knommu/platform/5206e/Makefile |    2 +-
 arch/m68knommu/platform/520x/Makefile  |    2 +-
 arch/m68knommu/platform/523x/Makefile  |    2 +-
 arch/m68knommu/platform/5249/Makefile  |    2 +-
 arch/m68knommu/platform/5272/Makefile  |    2 +-
 arch/m68knommu/platform/527x/Makefile  |    2 +-
 arch/m68knommu/platform/528x/Makefile  |    2 +-
 arch/m68knommu/platform/5307/Makefile  |    2 +-
 arch/m68knommu/platform/532x/Makefile  |    2 +-
 arch/m68knommu/platform/5407/Makefile  |    2 +-
 arch/mips/Makefile                     |    8 +-
 arch/mips/kernel/Makefile              |    2 +-
 arch/parisc/Makefile                   |    2 +-
 arch/parisc/math-emu/Makefile          |    2 +-
 arch/powerpc/Kconfig.debug             |    6 +-
 arch/powerpc/Makefile                  |   30 +-
 arch/powerpc/platforms/Kconfig         |    2 +-
 arch/ppc/Makefile                      |   16 +-
 arch/ppc/boot/Makefile                 |    1 -
 arch/s390/Makefile                     |   14 +-
 arch/sh/Makefile                       |    6 +-
 arch/sh/boot/compressed/Makefile       |    2 +-
 arch/sh64/Makefile                     |    4 +-
 arch/sparc/Makefile                    |    8 +-
 arch/sparc64/Makefile                  |    8 +-
 arch/um/Makefile                       |   12 +-
 arch/um/Makefile-i386                  |    6 +-
 arch/um/Makefile-os-Linux              |    2 +-
 arch/um/Makefile-x86_64                |    6 +-
 arch/um/drivers/Makefile               |    2 +-
 arch/um/sys-i386/Makefile              |    2 +-
 arch/um/sys-ppc/Makefile               |    6 +-
 arch/um/sys-x86_64/Makefile            |    2 +-
 arch/v850/Makefile                     |    8 +-
 arch/x86/boot/Makefile                 |    4 +-
 arch/x86/boot/compressed/Makefile_32   |    2 +-
 arch/x86/boot/compressed/Makefile_64   |    4 +-
 arch/x86/math-emu/Makefile             |    3 +-
 arch/x86/vdso/Makefile                 |    4 +-
 arch/x86_64/Makefile                   |    8 +-
 arch/xtensa/Makefile                   |    8 +-
 arch/xtensa/boot/Makefile              |    5 +-
 arch/xtensa/boot/boot-redboot/Makefile |    2 +-
 drivers/atm/Makefile                   |    2 +-
 drivers/input/misc/Kconfig             |    2 +-
 drivers/leds/Kconfig                   |    2 +-
 drivers/telephony/Kconfig              |    2 +-
 include/linux/Kbuild                   |    3 -
 init/Makefile                          |    2 +-
 scripts/Kbuild.include                 |    8 +-
 scripts/Makefile.build                 |   45 +-
 scripts/Makefile.clean                 |    2 +-
 scripts/Makefile.lib                   |   30 +-
 scripts/basic/Makefile                 |    8 +-
 scripts/basic/docproc.c                |   34 +-
 scripts/checkkconfigsymbols.sh         |   59 +
 scripts/export_report.pl               |   10 +-
 scripts/gcc-version.sh                 |    8 +-
 scripts/genksyms/Makefile              |    8 +-
 scripts/genksyms/keywords.c_shipped    |  180 ++--
 scripts/genksyms/keywords.gperf        |    1 +
 scripts/genksyms/lex.c_shipped         | 1802 ++++++++++++++++++----------
 scripts/genksyms/parse.c_shipped       | 2088 ++++++++++++++++++--------------
 scripts/genksyms/parse.h_shipped       |  159 ++--
 scripts/genksyms/parse.y               |    5 +-
 scripts/kconfig/Makefile               |   10 +-
 scripts/kconfig/check.sh               |   14 +
 scripts/kconfig/lex.zconf.c_shipped    |   25 +-
 scripts/kconfig/mconf.c                |   36 +-
 scripts/kconfig/menu.c                 |   35 +-
 scripts/kconfig/util.c                 |   13 +-
 scripts/kconfig/zconf.gperf            |    2 -
 scripts/kconfig/zconf.hash.c_shipped   |  220 ++--
 scripts/kconfig/zconf.tab.c_shipped    | 1406 ++++++++++++----------
 scripts/kconfig/zconf.y                |   11 -
 scripts/makelst                        |    4 +-
 scripts/mkmakefile                     |    8 +-
 scripts/mod/file2alias.c               |   40 +-
 scripts/mod/modpost.c                  |    6 +
 scripts/mod/modpost.h                  |    4 +-
 scripts/ver_linux                      |    9 +-
 108 files changed, 3951 insertions(+), 2849 deletions(-)


Adrian Bunk (4):
      kbuild: fix export_report.pl
      kconfig: syntax cleanup - drop support for "depends/requires/def_boolean"
      include/linux/Kbuild: remove duplicate entries
      kbuild: call export_report from the Makefile

Jan Beulich (1):
      kconfig: tristate choices with mixed tristate and boolean values

Jesper Juhl (3):
      kbuild: improve scripts/gcc-version.sh output a bit when called without args
      kbuild: ver_linux fix glibc version print
      kbuild: scripts/ver_linux : correct printing of binutils version

Kees Cook (1):
      kbuild: make modpost detect unterminated device id lists

Matej Laitl (1):
      kconfig/menuconfig: distinguish between selected-by-another options and comments

Mike Frysinger (1):
      kbuild: clean Modules.symvers in external module dirs

Milton Miller (1):
      kbuild: call make once for all targets when O=.. is used

Paolo 'Blaisorblade' Giarrusso (1):
      kbuild: script to check for undefined Kconfig symbols

Petr Stetiar (1):
      kbuild: fix segfault in modpost

Ram Pai (1):
      kbuild: fix perl usage in export_report.pl

Randy Dunlap (1):
      docproc: style & typo cleanups

Roland McGrath (1):
      kbuild: pass -g to assembler under CONFIG_DEBUG_INFO

Sam Ravnborg (23):
      kbuild: Use Elfnn_Half as replacement for Elfnn_Section
      kbuild: check if we can link gettext not just compile
      kbuild: fix genksyms Makefile
      kbuild: __extension__ support in genksyms (fix unknown CRC warning)
      kbuild: apply genksyms changes
      ia64: fix sn to add include files using EXTRA_CFLAGS
      kbuild: fix directory traversal bug
      kconfig: make comments stand out in menuconfig
      kconfig: fix segv fault in menuconfig
      kbuild: fix infinite make recursion
      kbuild: update _shipped files for kconfig syntax cleanup
      kbuild: fix documentation in makefiles.txt
      kbuild: kill EXTRA_ARFLAGS
      kbuild: kill backward compatibility checks
      kbuild: move Kai Germaschewski to CREDITS
      kbuild: fix up CFLAGS usage
      kbuild: enable 'make CFLAGS=...' to add additional options to CC
      kbuild: check for wrong use of CFLAGS
      kbuild: fix AFLAGS use in h8300 and m68knommu
      kbuild: enable 'make AFLAGS=...' to add additional options to AS
      kbuild: enable use of AFLAGS and CFLAGS on commandline
      kbuild: enable 'make CPPFLAGS=...' to add additional options to CPP
      kbuild: introduce ccflags-y, asflags-y and ldflags-y

