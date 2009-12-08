Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZLHNaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZLHNaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 08:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZLHNay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 08:30:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:33359 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbZLHNat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 08:30:49 -0500
Date: Tue, 8 Dec 2009 14:30:04 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kbuild updates for 2.6.33
Message-ID: <20091208133004.GA22750@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

these are the kbuild patches I collected for 2.6.33. There might be a few
more later, but this is the main part.

Thanks,
Michal

The following changes since commit 6ec22f9b037fc0c2e00ddb7023fad279c365324d:
  Linus Torvalds (1):
        Merge branch 'x86-debug-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://repo.or.cz/linux-kbuild.git for-next

Daniel Vetter (1):
      kbuild: specify absolute paths for cscope

Jan Beulich (1):
      genksyms: properly consider  EXPORT_UNUSED_SYMBOL{,_GPL}()

Jie Zhang (1):
      net: add net_tstamp.h to headers_install

Jonathan Nieder (2):
      scripts/package: add KBUILD_PKG_ROOTCMD variable
      scripts/package: deb-pkg: use fakeroot if available

Michael Tokarev (1):
      kbuild: fix bzImage build for x86

Michal Marek (4):
      scripts/package: tar-pkg: use tar --owner=root
      kbuild: create include/generated in silentoldconfig
      score: add asm/asm-offsets.h wrapper
      kbuild: generate modules.builtin

Sam Ravnborg (14):
      kbuild: search arch/$ARCH/include before include/
      dontdiff: add generated
      kbuild: move bounds.h to include/generated
      kbuild: move asm-offsets.h to include/generated
      ia64: move nr-irqs.h to include/generated
      arm: move mach-types to include/generated
      sh: move machtypes.h to include/generated
      kbuild: drop include2/ used for O=... builds
      kbuild: do not check for include/asm-$ARCH
      kbuild: drop include/asm
      kbuild: move compile.h to include/generated
      drop explicit include of autoconf.h
      kbuild: move autoconf.h to include/generated
      kbuild: move utsrelease.h to include/generated

Tony Finch (1):
      unifdef: update to upstream revision 1.190

Wenji Huang (1):
      Kbuild: clean up marker

 .gitignore                                      |    7 +-
 Documentation/dontdiff                          |    1 +
 Documentation/kbuild/kbuild.txt                 |   14 +
 Documentation/kbuild/kconfig.txt                |    8 +-
 Kbuild                                          |    4 +-
 MAINTAINERS                                     |    6 +
 Makefile                                        |   96 ++-----
 arch/alpha/boot/bootp.c                         |    2 +-
 arch/alpha/boot/bootpz.c                        |    2 +-
 arch/alpha/boot/main.c                          |    2 +-
 arch/alpha/include/asm/asm-offsets.h            |    1 +
 arch/arm/Makefile                               |   14 +-
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
 arch/ia64/kernel/Makefile                       |    7 +-
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
 arch/powerpc/platforms/cell/spufs/Makefile      |    6 +-
 arch/powerpc/platforms/chrp/setup.c             |    2 +-
 arch/powerpc/platforms/powermac/bootx_init.c    |    2 +-
 arch/s390/include/asm/asm-offsets.h             |    1 +
 arch/score/include/asm/asm-offsets.h            |    1 +
 arch/sh/Makefile                                |   10 +-
 arch/sh/drivers/pci/fixups-rts7751r2d.c         |    2 +-
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
 drivers/staging/iio/ring_sw.h                   |    1 -
 drivers/staging/panel/panel.c                   |    2 +-
 include/linux/Kbuild                            |    1 +
 include/linux/mmdebug.h                         |    2 -
 include/linux/mmzone.h                          |    2 +-
 include/linux/page-flags.h                      |    2 +-
 include/linux/vermagic.h                        |    2 +-
 init/Makefile                                   |    8 +-
 init/version.c                                  |    4 +-
 kernel/bounds.c                                 |    2 +-
 kernel/kexec.c                                  |    2 +-
 kernel/trace/trace.c                            |    2 +-
 scripts/Kbuild.include                          |    6 +
 scripts/Makefile.lib                            |    2 +-
 scripts/Makefile.modbuiltin                     |   55 ++++
 scripts/basic/fixdep.c                          |   10 +-
 scripts/genksyms/keywords.c_shipped             |  191 +++++++------
 scripts/genksyms/keywords.gperf                 |    2 +
 scripts/headers.sh                              |    2 -
 scripts/kconfig/Makefile                        |    1 +
 scripts/kconfig/confdata.c                      |   24 ++-
 scripts/mkcompile_h                             |    2 +-
 scripts/package/Makefile                        |   20 ++-
 scripts/package/buildtar                        |    6 +-
 scripts/tags.sh                                 |    8 +-
 scripts/unifdef.c                               |  343 ++++++++++++++---------
 87 files changed, 551 insertions(+), 399 deletions(-)
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
 create mode 100644 arch/score/include/asm/asm-offsets.h
 delete mode 100644 arch/sh/include/asm/.gitignore
 create mode 100644 arch/sh/include/asm/asm-offsets.h
 create mode 100644 arch/sparc/include/asm/asm-offsets.h
 create mode 100644 arch/um/include/asm/asm-offsets.h
 create mode 100644 arch/x86/include/asm/asm-offsets.h
 create mode 100644 arch/xtensa/include/asm/asm-offsets.h
 create mode 100644 scripts/Makefile.modbuiltin
