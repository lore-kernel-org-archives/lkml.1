Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbZJRIGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbZJRIGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZJRIGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:06:35 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:60745 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbZJRIGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:06:32 -0400
Date: Sun, 18 Oct 2009 10:06:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 0/14 v2] kbuild: Move files to include/generated
Message-ID: <20091018080635.GA13767@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second version of a patchset to move generated files
to include/generated/

include/generated/ was established as _the_ location for generated
files used as part of the build process a few releases back.
This patchset is a follow-up on that.

Changes since v1:
- We will now pick up .h files in arch/$ARCH/include
  befoe include/
  This will fix the issue reported by Stephen Rothwell
  were we picked up an old asm-offsets.h that was left
  in include/asm/*

- generated is now included in dontdiff for the user
  of plain old diff

- fix to sh so we pick up the correct machtypes.h

- Removal of include2 directory includes removal in
  a powerpc specific file

- rebased on top of -linus


This patchset does not address request from Stephen to
make transition of utsrelease.h smoother.
We use utsrelease.h is so few places and any new users
should rather use utsname.

We still have a few generated files that are not moved.
But this patchset touched enough files already so
I stopped here for now.

The patchset is pushed out at:

    git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.next.git master

Patches will follow.

	Sam


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




 .gitignore                                      |    6 --
 Documentation/dontdiff                          |    1 +
 Documentation/kbuild/kconfig.txt                |    3 +-
 Kbuild                                          |    4 +-
 Makefile                                        |   80 +++++------------------
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
 arch/powerpc/platforms/cell/spufs/Makefile      |    6 +-
 arch/powerpc/platforms/chrp/setup.c             |    2 +-
 arch/powerpc/platforms/powermac/bootx_init.c    |    2 +-
 arch/s390/include/asm/asm-offsets.h             |    1 +
 arch/sh/Makefile                                |   10 +--
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
 include/linux/mmdebug.h                         |    2 -
 include/linux/mmzone.h                          |    2 +-
 include/linux/page-flags.h                      |    2 +-
 include/linux/vermagic.h                        |    2 +-
 init/Makefile                                   |    8 +--
 init/version.c                                  |    4 +-
 kernel/bounds.c                                 |    2 +-
 kernel/kexec.c                                  |    2 +-
 kernel/trace/trace.c                            |    2 +-
 scripts/basic/fixdep.c                          |   10 ++--
 scripts/headers.sh                              |    2 -
 scripts/kconfig/confdata.c                      |    2 +-
 scripts/mkcompile_h                             |    2 +-
 73 files changed, 91 insertions(+), 159 deletions(-)

