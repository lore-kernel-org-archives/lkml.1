Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbZIYTHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbZIYTHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 15:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZIYTHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 15:07:06 -0400
Received: from [195.41.46.235] ([195.41.46.235]:57985 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbZIYTHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 15:07:05 -0400
Date: Fri, 25 Sep 2009 21:07:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [GIT] kbuild - 2nd batch
Message-ID: <20090925190702.GA3275@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Here comes the 2nd batch of kbuild updates.
This pull request includes 10 commits that allows
us to finally remove the include/asm symlink.

This is achieved by saving generated files in include/generated.

For the simple cases the reference was fixed up so we do:

   #include <generated/foo.h>

Gut asm-offsets.h is too widely used so here we have a small
wrapper for all archs that include a single line:

   #include <generated/asm-offsets.h>

Build tested on the archs where I have working cross compilers.
[alpha, arm, sparc]

The patches has been on lkml for review but they have not
been in -next.

	Sam

The following changes since commit 53cddfcc0e760d2b364878b6dadbd0c6d087cfae:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../lethal/sh-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git master

Sam Ravnborg (10):
      kbuild: move bounds.h to include/generated
      kbuild: move asm-offsets.h to include/generated
      ia64: move nr-irqs.h to include/generated
      sh: move machtypes.h to include/generated
      arm: move mach-types to include/generated
      kbuild: drop asm symlink
      kbuild: move compile.h to include/generated
      drop unneeded include of autoconf.h
      kbuild: move autoconf.h to include/generated
      kbuild: move utsrelease.h to include/generated

 .gitignore                                      |    6 --
 Documentation/kbuild/kconfig.txt                |    3 +-
 Kbuild                                          |    4 +-
 Makefile                                        |   68 ++++------------------
 arch/alpha/boot/bootp.c                         |    2 +-
 arch/alpha/boot/bootpz.c                        |    2 +-
 arch/alpha/boot/main.c                          |    2 +-
 arch/alpha/include/asm/asm-offsets.h            |    1 +
 arch/arm/Makefile                               |   14 +----
 arch/arm/include/asm/asm-offsets.h              |    1 +
 arch/arm/include/asm/mach-types.h               |    1 +
 arch/arm/tools/Makefile                         |    2 +-
 arch/arm/tools/gen-mach-types                   |    2 +-
 arch/avr32/include/asm/asm-offsets.h            |    1 +
 arch/blackfin/include/asm/asm-offsets.h         |    1 +
 arch/cris/arch-v32/kernel/head.S                |    1 -
 arch/cris/include/asm/asm-offsets.h             |    1 +
 arch/cris/kernel/asm-offsets.c                  |    1 -
 arch/cris/kernel/vmlinux.lds.S                  |    1 -
 arch/frv/include/asm/asm-offsets.h              |    1 +
 arch/frv/kernel/setup.c                         |    2 +-
 arch/h8300/include/asm/asm-offsets.h            |    1 +
 arch/ia64/Makefile                              |    2 +-
 arch/ia64/include/asm/asm-offsets.h             |    1 +
 arch/ia64/include/asm/irq.h                     |    2 +-
 arch/ia64/kernel/Makefile                       |    7 +--
 arch/ia64/kvm/asm-offsets.c                     |    1 -
 arch/m68k/include/asm/asm-offsets.h             |    1 +
 arch/m68k/kernel/head.S                         |    2 +-
 arch/microblaze/include/asm/asm-offsets.h       |    1 +
 arch/mips/include/asm/asm-offsets.h             |    1 +
 arch/mn10300/include/asm/asm-offsets.h          |    1 +
 arch/parisc/include/asm/asm-offsets.h           |    1 +
 arch/powerpc/include/asm/asm-offsets.h          |    1 +
 arch/powerpc/platforms/52xx/efika.c             |    2 +-
 arch/powerpc/platforms/amigaone/setup.c         |    2 +-
 arch/powerpc/platforms/chrp/setup.c             |    2 +-
 arch/powerpc/platforms/powermac/bootx_init.c    |    2 +-
 arch/s390/include/asm/asm-offsets.h             |    1 +
 arch/sh/Makefile                                |   10 +--
 arch/sh/include/asm/.gitignore                  |    1 -
 arch/sh/include/asm/asm-offsets.h               |    1 +
 arch/sh/include/asm/machvec.h                   |    2 +-
 arch/sh/tools/Makefile                          |    4 +-
 arch/sh/tools/gen-mach-types                    |    2 +-
 arch/sparc/include/asm/asm-offsets.h            |    1 +
 arch/um/Makefile                                |    2 +-
 arch/um/include/asm/asm-offsets.h               |    1 +
 arch/x86/boot/header.S                          |    2 +-
 arch/x86/boot/version.c                         |    4 +-
 arch/x86/include/asm/asm-offsets.h              |    1 +
 arch/xtensa/include/asm/asm-offsets.h           |    1 +
 drivers/accessibility/braille/braille_console.c |    1 -
 drivers/hid/hid-lg.h                            |    2 -
 drivers/platform/x86/compal-laptop.c            |    1 -
 drivers/staging/panel/panel.c                   |    2 +-
 include/linux/mmdebug.h                         |    2 -
 include/linux/mmzone.h                          |    2 +-
 include/linux/page-flags.h                      |    2 +-
 include/linux/vermagic.h                        |    2 +-
 init/Makefile                                   |    6 +-
 init/version.c                                  |    4 +-
 kernel/bounds.c                                 |    2 +-
 kernel/kexec.c                                  |    2 +-
 kernel/trace/trace.c                            |    2 +-
 scripts/basic/fixdep.c                          |   10 ++--
 scripts/kconfig/confdata.c                      |    2 +-
 scripts/mkcompile_h                             |    2 +-
 68 files changed, 85 insertions(+), 139 deletions(-)
 create mode 100644 arch/alpha/include/asm/asm-offsets.h
 create mode 100644 arch/arm/include/asm/asm-offsets.h
 create mode 100644 arch/arm/include/asm/mach-types.h
 create mode 100644 arch/avr32/include/asm/asm-offsets.h
 create mode 100644 arch/blackfin/include/asm/asm-offsets.h
 create mode 100644 arch/cris/include/asm/asm-offsets.h
 create mode 100644 arch/frv/include/asm/asm-offsets.h
 create mode 100644 arch/h8300/include/asm/asm-offsets.h
 create mode 100644 arch/ia64/include/asm/asm-offsets.h
 create mode 100644 arch/m68k/include/asm/asm-offsets.h
 create mode 100644 arch/microblaze/include/asm/asm-offsets.h
 create mode 100644 arch/mips/include/asm/asm-offsets.h
 create mode 100644 arch/mn10300/include/asm/asm-offsets.h
 create mode 100644 arch/parisc/include/asm/asm-offsets.h
 create mode 100644 arch/powerpc/include/asm/asm-offsets.h
 create mode 100644 arch/s390/include/asm/asm-offsets.h
 delete mode 100644 arch/sh/include/asm/.gitignore
 create mode 100644 arch/sh/include/asm/asm-offsets.h
 create mode 100644 arch/sparc/include/asm/asm-offsets.h
 create mode 100644 arch/um/include/asm/asm-offsets.h
 create mode 100644 arch/x86/include/asm/asm-offsets.h
 create mode 100644 arch/xtensa/include/asm/asm-offsets.h
