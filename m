Return-Path: <linux-kernel-owner+w=401wt.eu-S1751594AbZIUR4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbZIUR4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 13:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZIUR4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 13:56:36 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38364 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZIUR4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 13:56:35 -0400
Date: Mon, 21 Sep 2009 19:56:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [GIT] kbuild
Message-ID: <20090921175637.GA28796@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

First (delayed) batch of kbuild stuff.

o kconfig refactoring
o allyesconfig is now buildable with gold
o support -fconserve-stack for newer gcc's
  We do not gain much for now but it is nice to be prepared
o more linker script/sections consolidation
  Archs are starting to pick up the individual patches,
  this is the stuff that is generic or touches a lot of architectures
o save ARCH and CROSS_COMPILE settings in two files named:

    include/generated/kernel.arch
    include/generated/kernel.cross

 So we no longer need to set correct each time we do a build.
o no longer respect $(CROSS_COMPILE) for installkernel script.
  It was used by very few persons and did not play well when
  we saved CROSS_COMPILE.

Stuff planned for next batch:
- move a lot of stuff to include/generated
  I just need to test it a bit more

- support listing builtin modules with modutils
  I have been sitting on a patch for months and only gave feedback now.
  There is some minor updates needed before it is ready

And I guess a bit more if I find time to crawl through my mailbox.

Most patches has been in -next but not all.
Some patches has come in via akpm so thay have more airtime than their
commit time says.


	Sam



The following changes since commit 78f28b7c555359c67c2a0d23f7436e915329421e:
  Linus Torvalds (1):
        Merge branch 'x86-platform-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git master

Andi Kleen (4):
      kbuild: Check if linker supports the -X option
      kbuild: echo the record_mcount command
      kbuild: set -fconserve-stack option for gcc 4.5
      kbuild: fail build if recordmcount.pl fails

Cheng Renquan (6):
      kconfig: add symbol value to help find the real depend
      kconfig: add menu_get_ext_help function to display more information
      kconfig: make use of menu_get_ext_help in menuconfig
      kconfig: make use of menu_get_ext_help in qconfig
      kconfig: make use of menu_get_ext_help in "make config"
      kconfig: make use of menu_get_ext_help in gconfig

Diego Elio 'Flameeyes' Pettenò (1):
      gconfig: disable "typeahead find" search in treeviews

Jaswinder Singh Rajput (1):
      gitignore usr/initramfs_data.cpio.bz2 and usr/initramfs_data.cpio.lzma

Joe Perches (1):
      Use new __init_task_data macro in arch init_task.c files.

Jory A. Pratt (1):
      kbuild: fix cc1 options check to ensure we do not use -fPIC when compiling

Luis R. Rodriguez (3):
      checkincludes.pl: close file as soon as we're done with it
      checkincludes.pl: provide usage helper
      checkincludes.pl: add option to remove duplicates in place

Ozan Çaglayan (1):
      markup_oops: use modinfo to avoid confusion with underscored module names

Randy Dunlap (1):
      kernel hacking: move STRIP_ASM_SYMS from General

Robert P. J. Day (1):
      kbuild: correct initramfs compression comment

Sam Ravnborg (5):
      kbuild: use INSTALLKERNEL to select customized installkernel script
      kbuild: save ARCH & CROSS_COMPILE when building a kernel
      kbuild: rename ld-option to cc-ldoption
      kbuild: introduce ld-option
      arm, cris, mips, sparc, powerpc, um, xtensa: fix build with bash 4.0

Stefani Seibold (1):
      ctags: usability fix

Tim Abbott (3):
      kbuild: Don't define ALIGN and ENTRY when preprocessing linker scripts.
      Use macros for .bss.page_aligned section.
      Use macros for .data.page_aligned section.

Trevor Keith (1):
      kbuild: add static to prototypes

 Documentation/kbuild/kbuild.txt             |   16 +++++
 Documentation/kbuild/makefiles.txt          |   20 ++++++-
 Makefile                                    |   62 ++++++++++++++++---
 arch/arm/Makefile                           |    6 +-
 arch/arm/boot/install.sh                    |    4 +-
 arch/arm/kernel/Makefile                    |    3 +-
 arch/arm/kernel/init_task.c                 |    5 +-
 arch/avr32/kernel/init_task.c               |    5 +-
 arch/avr32/mm/init.c                        |    4 +-
 arch/blackfin/Makefile                      |    4 +-
 arch/blackfin/boot/install.sh               |    6 +-
 arch/cris/Makefile                          |    2 -
 arch/cris/kernel/Makefile                   |    1 +
 arch/cris/kernel/process.c                  |    5 +-
 arch/frv/kernel/init_task.c                 |    5 +-
 arch/h8300/kernel/init_task.c               |    5 +-
 arch/ia64/install.sh                        |    4 +-
 arch/ia64/kernel/Makefile.gate              |    2 +-
 arch/ia64/kernel/init_task.c                |    3 +-
 arch/m32r/boot/compressed/install.sh        |    4 +-
 arch/m32r/kernel/init_task.c                |    5 +-
 arch/m68k/install.sh                        |    4 +-
 arch/m68k/kernel/process.c                  |    6 +-
 arch/m68knommu/kernel/init_task.c           |    5 +-
 arch/microblaze/kernel/init_task.c          |    5 +-
 arch/mips/Makefile                          |   27 +--------
 arch/mips/kernel/init_task.c                |    5 +-
 arch/mips/kernel/vmlinux.lds.S              |   13 ++++-
 arch/mn10300/kernel/init_task.c             |    5 +-
 arch/parisc/Makefile                        |    4 +-
 arch/parisc/install.sh                      |    4 +-
 arch/parisc/kernel/init_task.c              |    4 +-
 arch/powerpc/Makefile                       |    6 +-
 arch/powerpc/boot/install.sh                |    4 +-
 arch/powerpc/kernel/init_task.c             |    5 +-
 arch/powerpc/kernel/machine_kexec_64.c      |    5 +-
 arch/powerpc/kernel/vdso.c                  |    3 +-
 arch/powerpc/kernel/vdso32/Makefile         |    2 +-
 arch/powerpc/kernel/vdso32/vdso32_wrapper.S |    3 +-
 arch/powerpc/kernel/vdso64/Makefile         |    2 +-
 arch/powerpc/kernel/vdso64/vdso64_wrapper.S |    3 +-
 arch/s390/boot/install.sh                   |    4 +-
 arch/s390/kernel/init_task.c                |    5 +-
 arch/s390/kernel/vdso.c                     |    2 +-
 arch/s390/kernel/vdso32/Makefile            |    2 +-
 arch/s390/kernel/vdso32/vdso32_wrapper.S    |    3 +-
 arch/s390/kernel/vdso64/Makefile            |    2 +-
 arch/s390/kernel/vdso64/vdso64_wrapper.S    |    3 +-
 arch/score/kernel/init_task.c               |    5 +-
 arch/sh/boot/compressed/install.sh          |    4 +-
 arch/sh/kernel/init_task.c                  |    5 +-
 arch/sh/kernel/irq.c                        |    6 +-
 arch/sh/kernel/vsyscall/Makefile            |    2 +-
 arch/sparc/Makefile                         |    4 -
 arch/sparc/kernel/Makefile                  |    6 ++-
 arch/sparc/kernel/init_task.c               |    5 +-
 arch/um/Makefile                            |    9 +--
 arch/um/kernel/Makefile                     |    3 +
 arch/um/kernel/init_task.c                  |    5 +-
 arch/um/kernel/vmlinux.lds.S                |    3 +
 arch/x86/Makefile                           |    4 +-
 arch/x86/boot/install.sh                    |    4 +-
 arch/x86/include/asm/cache.h                |    4 +-
 arch/x86/kernel/head_32.S                   |    4 +-
 arch/x86/kernel/head_64.S                   |    2 +-
 arch/x86/kernel/init_task.c                 |    5 +-
 arch/x86/vdso/Makefile                      |    2 +-
 arch/xtensa/kernel/Makefile                 |    3 +-
 arch/xtensa/kernel/head.S                   |    2 +-
 arch/xtensa/kernel/init_task.c              |    5 +-
 include/linux/linkage.h                     |    2 +
 init/Kconfig                                |    8 ---
 lib/Kconfig.debug                           |    8 +++
 scripts/Kbuild.include                      |   16 ++++--
 scripts/Makefile.build                      |    6 +-
 scripts/basic/docproc.c                     |   34 ++++++------
 scripts/basic/fixdep.c                      |   26 ++++----
 scripts/basic/hash.c                        |    4 +-
 scripts/checkincludes.pl                    |   71 +++++++++++++++++++++--
 scripts/kconfig/conf.c                      |   24 ++++----
 scripts/kconfig/confdata.c                  |    2 +-
 scripts/kconfig/expr.c                      |    6 +-
 scripts/kconfig/gconf.c                     |   21 +------
 scripts/kconfig/gconf.glade                 |    4 +-
 scripts/kconfig/kxgettext.c                 |    4 +-
 scripts/kconfig/lkc_proto.h                 |    2 +
 scripts/kconfig/mconf.c                     |   78 +------------------------
 scripts/kconfig/menu.c                      |   84 ++++++++++++++++++++++++++-
 scripts/kconfig/qconf.cc                    |   10 +--
 scripts/kconfig/symbol.c                    |    6 +-
 scripts/markup_oops.pl                      |    5 +-
 scripts/tags.sh                             |    3 +-
 usr/.gitignore                              |    2 +
 usr/Makefile                                |    2 +-
 94 files changed, 473 insertions(+), 354 deletions(-)
