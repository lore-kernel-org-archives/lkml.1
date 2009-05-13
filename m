Return-Path: <linux-kernel-owner+w=401wt.eu-S1761411AbZEMW5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761411AbZEMW5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758764AbZEMW4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:56:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:59249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbZEMW4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:56:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Michal Simek <monstr@monstr.eu>, Chen Liqin <liqin.chen@sunplusct.com>
Subject: [PATCH 00/16] asm-generic headers, v4
Date: Wed, 13 May 2009 22:56:23 +0000
Message-Id: <1242255398-23779-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.0.4
X-Provags-ID: V01U2FsdGVkX18dP1wT4V4WULVBJxilTTZ4pVij2nagUaREA8I
 UwJSnHmr3V4RdP8JnlvX6OGwMqN9yOkyL6Nm9zy6f1OJehU6OH
 lljy5SElzE6v2hbX0TPkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the complete set of new asm-generic header files,
with all the comments that I have received addressed.
I'd like to merge this early in the 2.6.31 cycle, so
that the and score architecture port can use it
right away and microblaze can convert early.

I have kept the changes to existing architectures
to the bare minimum here, but have separate changesets
for microblaze and x86 to remove all arch specific
header files that become obsolete after adding generic
versions.

Stephen, can you add
git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic next
to linux-next?

Should this go to Linus directly, or does anyone already
maintain a tree to collect changes this this area?

Thanks everone for the comments so far, I hope I'm getting
close to a mergeable state now. I'm starting to use
git-send-email now as well, hopefully this will be the
end of screwed-up email headers for me.

	Arnd <><

---

  asm-generic: rename termios.h, signal.h and mman.h
  asm-generic: introduce asm/bitsperlong.h
  asm-generic: add generic sysv ipc headers
  asm-generic: add generic ABI headers
  asm-generic: add a generic unistd.h
  asm-generic: rename atomic.h to atomic-long.h
  asm-generic: rename page.h and uaccess.h
  asm-generic: make pci.h usable directly
  asm-generic: make bitops.h usable
  asm-generic: add generic versions of common headers
  asm-generic: add legacy I/O header files
  asm-generic: add generic atomic.h and io.h
  asm-generic: add generic NOMMU versions of some headers
  asm-generic: add a generic uaccess.h
  asm-generic: Add missing generic tlb_flush definition
  add generic lib/checksum.c

 arch/alpha/include/asm/atomic.h                    |    2 +-
 arch/alpha/include/asm/bitsperlong.h               |    8 +
 arch/alpha/include/asm/page.h                      |    2 +-
 arch/alpha/include/asm/signal.h                    |    2 +-
 arch/alpha/include/asm/types.h                     |    3 -
 arch/arm/include/asm/atomic.h                      |    2 +-
 arch/arm/include/asm/bitsperlong.h                 |    1 +
 arch/arm/include/asm/mman.h                        |    2 +-
 arch/arm/include/asm/page.h                        |    2 +-
 arch/arm/include/asm/signal.h                      |    2 +-
 arch/avr32/include/asm/atomic.h                    |    2 +-
 arch/avr32/include/asm/bitsperlong.h               |    1 +
 arch/avr32/include/asm/mman.h                      |    2 +-
 arch/avr32/include/asm/signal.h                    |    2 +-
 arch/avr32/include/asm/termios.h                   |    2 +-
 arch/blackfin/include/asm/atomic.h                 |    2 +-
 arch/blackfin/include/asm/bitsperlong.h            |    1 +
 arch/blackfin/include/asm/page.h                   |    2 +-
 arch/blackfin/include/asm/signal.h                 |    2 +-
 arch/cris/include/asm/atomic.h                     |    2 +-
 arch/cris/include/asm/bitsperlong.h                |    1 +
 arch/cris/include/asm/mman.h                       |    2 +-
 arch/cris/include/asm/page.h                       |    2 +-
 arch/cris/include/asm/signal.h                     |    2 +-
 arch/frv/include/asm/atomic.h                      |    2 +-
 arch/frv/include/asm/bitsperlong.h                 |    1 +
 arch/frv/include/asm/mman.h                        |    2 +-
 arch/frv/include/asm/page.h                        |    2 +-
 arch/frv/include/asm/pci.h                         |   13 +-
 arch/frv/include/asm/termios.h                     |    2 +-
 arch/h8300/include/asm/atomic.h                    |    2 +-
 arch/h8300/include/asm/bitsperlong.h               |    1 +
 arch/h8300/include/asm/mman.h                      |    2 +-
 arch/h8300/include/asm/page.h                      |    2 +-
 arch/h8300/include/asm/signal.h                    |    2 +-
 arch/ia64/include/asm/atomic.h                     |    2 +-
 arch/ia64/include/asm/bitsperlong.h                |    8 +
 arch/ia64/include/asm/mman.h                       |    2 +-
 arch/ia64/include/asm/signal.h                     |    2 +-
 arch/ia64/include/asm/types.h                      |    7 -
 arch/m32r/include/asm/atomic.h                     |    2 +-
 arch/m32r/include/asm/bitsperlong.h                |    1 +
 arch/m32r/include/asm/mman.h                       |    2 +-
 arch/m32r/include/asm/page.h                       |    2 +-
 arch/m32r/include/asm/pci.h                        |    2 -
 arch/m32r/include/asm/signal.h                     |    2 +-
 arch/m68k/include/asm/atomic_mm.h                  |    2 +-
 arch/m68k/include/asm/atomic_no.h                  |    2 +-
 arch/m68k/include/asm/bitsperlong.h                |    1 +
 arch/m68k/include/asm/mman.h                       |    2 +-
 arch/m68k/include/asm/page_mm.h                    |    2 +-
 arch/m68k/include/asm/page_no.h                    |    2 +-
 arch/m68k/include/asm/signal.h                     |    2 +-
 arch/microblaze/include/asm/atomic.h               |    2 +-
 arch/microblaze/include/asm/bitsperlong.h          |    1 +
 arch/microblaze/include/asm/page.h                 |    2 +-
 arch/microblaze/include/asm/signal.h               |    2 +-
 arch/microblaze/include/asm/termios.h              |    2 +-
 arch/mips/include/asm/atomic.h                     |    2 +-
 arch/mips/include/asm/bitsperlong.h                |    8 +
 arch/mips/include/asm/page.h                       |    2 +-
 arch/mips/include/asm/signal.h                     |    2 +-
 arch/mips/include/asm/types.h                      |    3 -
 arch/mn10300/include/asm/atomic.h                  |    2 +-
 arch/mn10300/include/asm/bitsperlong.h             |    1 +
 arch/mn10300/include/asm/mman.h                    |    2 +-
 arch/mn10300/include/asm/signal.h                  |    2 +-
 arch/parisc/include/asm/atomic.h                   |    2 +-
 arch/parisc/include/asm/bitsperlong.h              |   20 +
 arch/parisc/include/asm/page.h                     |    2 +-
 arch/parisc/include/asm/types.h                    |    8 -
 arch/parisc/include/asm/uaccess.h                  |    2 +-
 arch/powerpc/include/asm/atomic.h                  |    2 +-
 arch/powerpc/include/asm/bitsperlong.h             |   12 +
 arch/powerpc/include/asm/mman.h                    |    2 +-
 arch/powerpc/include/asm/page_32.h                 |    2 +-
 arch/powerpc/include/asm/page_64.h                 |    2 +-
 arch/powerpc/include/asm/signal.h                  |    2 +-
 arch/powerpc/include/asm/termios.h                 |    2 +-
 arch/powerpc/include/asm/types.h                   |    9 -
 arch/s390/include/asm/atomic.h                     |    2 +-
 arch/s390/include/asm/bitsperlong.h                |   13 +
 arch/s390/include/asm/mman.h                       |    2 +-
 arch/s390/include/asm/page.h                       |    2 +-
 arch/s390/include/asm/signal.h                     |    2 +-
 arch/s390/include/asm/termios.h                    |    2 +-
 arch/s390/include/asm/types.h                      |    6 -
 arch/sh/include/asm/atomic.h                       |    2 +-
 arch/sh/include/asm/bitsperlong.h                  |    1 +
 arch/sh/include/asm/mman.h                         |    2 +-
 arch/sh/include/asm/page.h                         |    2 +-
 arch/sh/include/asm/signal.h                       |    2 +-
 arch/sparc/include/asm/atomic_32.h                 |    2 +-
 arch/sparc/include/asm/atomic_64.h                 |    2 +-
 arch/sparc/include/asm/bitsperlong.h               |   13 +
 arch/sparc/include/asm/mman.h                      |    2 +-
 arch/sparc/include/asm/page_32.h                   |    2 +-
 arch/sparc/include/asm/page_64.h                   |    2 +-
 arch/sparc/include/asm/signal.h                    |    2 +-
 arch/sparc/include/asm/types.h                     |    4 -
 arch/sparc/include/asm/uaccess_64.h                |    2 +-
 arch/um/include/asm/page.h                         |    2 +-
 arch/x86/include/asm/atomic_32.h                   |    2 +-
 arch/x86/include/asm/atomic_64.h                   |    2 +-
 arch/x86/include/asm/bitsperlong.h                 |   13 +
 arch/x86/include/asm/mman.h                        |    2 +-
 arch/x86/include/asm/page.h                        |    2 +-
 arch/x86/include/asm/signal.h                      |    2 +-
 arch/x86/include/asm/types.h                       |    6 -
 arch/xtensa/include/asm/atomic.h                   |    2 +-
 arch/xtensa/include/asm/bitsperlong.h              |    1 +
 arch/xtensa/include/asm/page.h                     |    2 +-
 include/asm-generic/Kbuild                         |   22 +
 include/asm-generic/Kbuild.asm                     |    1 +
 include/asm-generic/{atomic.h => atomic-long.h}    |    6 +-
 include/asm-generic/atomic.h                       |  423 ++++------
 include/asm-generic/auxvec.h                       |    8 +
 include/asm-generic/bitops.h                       |   24 +-
 include/asm-generic/bitops/atomic.h                |    1 +
 include/asm-generic/bitsperlong.h                  |   32 +
 include/asm-generic/bugs.h                         |   10 +
 include/asm-generic/cache.h                        |   12 +
 include/asm-generic/cacheflush.h                   |   30 +
 include/asm-generic/checksum.h                     |   79 ++
 include/asm-generic/current.h                      |    9 +
 include/asm-generic/delay.h                        |    9 +
 include/asm-generic/dma.h                          |   15 +
 include/asm-generic/fb.h                           |   12 +
 include/asm-generic/{page.h => getorder.h}         |    8 +-
 include/asm-generic/hardirq.h                      |   34 +
 include/asm-generic/hw_irq.h                       |    9 +
 include/asm-generic/int-l64.h                      |    2 +
 include/asm-generic/int-ll64.h                     |    2 +
 include/asm-generic/io.h                           |  300 +++++++
 include/asm-generic/ioctls.h                       |  110 +++
 include/asm-generic/ipcbuf.h                       |   33 +
 include/asm-generic/irq.h                          |   18 +
 include/asm-generic/irqflags.h                     |   72 ++
 include/asm-generic/kmap_types.h                   |   29 +
 include/asm-generic/linkage.h                      |    8 +
 include/asm-generic/{mman.h => mman-common.h}      |    6 +-
 include/asm-generic/mman.h                         |   59 +-
 include/asm-generic/mmu.h                          |   15 +
 include/asm-generic/mmu_context.h                  |   45 +
 include/asm-generic/module.h                       |   22 +
 include/asm-generic/msgbuf.h                       |   47 ++
 include/asm-generic/mutex.h                        |    9 +
 include/asm-generic/page.h                         |  123 +++-
 include/asm-generic/param.h                        |   24 +
 include/asm-generic/parport.h                      |   23 +
 include/asm-generic/pci.h                          |    8 +
 include/asm-generic/pgalloc.h                      |   12 +
 include/asm-generic/posix_types.h                  |  165 ++++
 include/asm-generic/scatterlist.h                  |   43 +
 include/asm-generic/segment.h                      |    9 +
 include/asm-generic/sembuf.h                       |   38 +
 include/asm-generic/serial.h                       |   13 +
 include/asm-generic/setup.h                        |    6 +
 include/asm-generic/shmbuf.h                       |   59 ++
 include/asm-generic/shmparam.h                     |    6 +
 include/asm-generic/{signal.h => signal-defs.h}    |    6 +-
 include/asm-generic/signal.h                       |  159 +++-
 include/asm-generic/socket.h                       |   60 ++
 include/asm-generic/sockios.h                      |   13 +
 include/asm-generic/spinlock.h                     |   11 +
 include/asm-generic/stat.h                         |   72 ++
 include/asm-generic/string.h                       |   10 +
 include/asm-generic/swab.h                         |   18 +
 include/asm-generic/syscalls.h                     |   60 ++
 include/asm-generic/system.h                       |  161 ++++
 include/asm-generic/termbits.h                     |  198 +++++
 include/asm-generic/termios-base.h                 |   77 ++
 include/asm-generic/termios.h                      |  105 +++-
 include/asm-generic/timex.h                        |   22 +
 include/asm-generic/tlb.h                          |    4 +
 include/asm-generic/tlbflush.h                     |   18 +
 include/asm-generic/types.h                        |   42 +
 .../asm-generic/{uaccess.h => uaccess-unaligned.h} |    6 +-
 include/asm-generic/uaccess.h                      |  351 ++++++++-
 include/asm-generic/ucontext.h                     |   12 +
 include/asm-generic/unaligned.h                    |   30 +
 include/asm-generic/unistd.h                       |  854 ++++++++++++++++++++
 include/asm-generic/user.h                         |    8 +
 include/asm-generic/vga.h                          |   24 +
 lib/Makefile                                       |    2 +
 lib/checksum.c                                     |  193 +++++
 scripts/checksyscalls.sh                           |   92 ++-
 187 files changed, 4434 insertions(+), 556 deletions(-)
 create mode 100644 arch/alpha/include/asm/bitsperlong.h
 create mode 100644 arch/arm/include/asm/bitsperlong.h
 create mode 100644 arch/avr32/include/asm/bitsperlong.h
 create mode 100644 arch/blackfin/include/asm/bitsperlong.h
 create mode 100644 arch/cris/include/asm/bitsperlong.h
 create mode 100644 arch/frv/include/asm/bitsperlong.h
 create mode 100644 arch/h8300/include/asm/bitsperlong.h
 create mode 100644 arch/ia64/include/asm/bitsperlong.h
 create mode 100644 arch/m32r/include/asm/bitsperlong.h
 create mode 100644 arch/m68k/include/asm/bitsperlong.h
 create mode 100644 arch/microblaze/include/asm/bitsperlong.h
 create mode 100644 arch/mips/include/asm/bitsperlong.h
 create mode 100644 arch/mn10300/include/asm/bitsperlong.h
 create mode 100644 arch/parisc/include/asm/bitsperlong.h
 create mode 100644 arch/powerpc/include/asm/bitsperlong.h
 create mode 100644 arch/s390/include/asm/bitsperlong.h
 create mode 100644 arch/sh/include/asm/bitsperlong.h
 create mode 100644 arch/sparc/include/asm/bitsperlong.h
 create mode 100644 arch/x86/include/asm/bitsperlong.h
 create mode 100644 arch/xtensa/include/asm/bitsperlong.h
 rename include/asm-generic/{atomic.h => atomic-long.h} (97%)
 rewrite include/asm-generic/atomic.h (98%)
 create mode 100644 include/asm-generic/auxvec.h
 create mode 100644 include/asm-generic/bitsperlong.h
 create mode 100644 include/asm-generic/bugs.h
 create mode 100644 include/asm-generic/cache.h
 create mode 100644 include/asm-generic/cacheflush.h
 create mode 100644 include/asm-generic/checksum.h
 create mode 100644 include/asm-generic/current.h
 create mode 100644 include/asm-generic/delay.h
 create mode 100644 include/asm-generic/dma.h
 create mode 100644 include/asm-generic/fb.h
 rename include/asm-generic/{page.h => getorder.h} (59%)
 create mode 100644 include/asm-generic/hardirq.h
 create mode 100644 include/asm-generic/hw_irq.h
 create mode 100644 include/asm-generic/io.h
 create mode 100644 include/asm-generic/ioctls.h
 create mode 100644 include/asm-generic/ipcbuf.h
 create mode 100644 include/asm-generic/irq.h
 create mode 100644 include/asm-generic/irqflags.h
 create mode 100644 include/asm-generic/kmap_types.h
 create mode 100644 include/asm-generic/linkage.h
 rename include/asm-generic/{mman.h => mman-common.h} (93%)
 rewrite include/asm-generic/mman.h (99%)
 create mode 100644 include/asm-generic/mmu.h
 create mode 100644 include/asm-generic/mmu_context.h
 create mode 100644 include/asm-generic/module.h
 create mode 100644 include/asm-generic/msgbuf.h
 create mode 100644 include/asm-generic/mutex.h
 rewrite include/asm-generic/page.h (93%)
 create mode 100644 include/asm-generic/param.h
 create mode 100644 include/asm-generic/parport.h
 create mode 100644 include/asm-generic/pgalloc.h
 create mode 100644 include/asm-generic/posix_types.h
 create mode 100644 include/asm-generic/scatterlist.h
 create mode 100644 include/asm-generic/segment.h
 create mode 100644 include/asm-generic/sembuf.h
 create mode 100644 include/asm-generic/serial.h
 create mode 100644 include/asm-generic/setup.h
 create mode 100644 include/asm-generic/shmbuf.h
 create mode 100644 include/asm-generic/shmparam.h
 rename include/asm-generic/{signal.h => signal-defs.h} (85%)
 rewrite include/asm-generic/signal.h (86%)
 create mode 100644 include/asm-generic/socket.h
 create mode 100644 include/asm-generic/sockios.h
 create mode 100644 include/asm-generic/spinlock.h
 create mode 100644 include/asm-generic/stat.h
 create mode 100644 include/asm-generic/string.h
 create mode 100644 include/asm-generic/swab.h
 create mode 100644 include/asm-generic/syscalls.h
 create mode 100644 include/asm-generic/system.h
 create mode 100644 include/asm-generic/termbits.h
 create mode 100644 include/asm-generic/termios-base.h
 create mode 100644 include/asm-generic/timex.h
 create mode 100644 include/asm-generic/tlbflush.h
 create mode 100644 include/asm-generic/types.h
 rename include/asm-generic/{uaccess.h => uaccess-unaligned.h} (82%)
 rewrite include/asm-generic/uaccess.h (96%)
 create mode 100644 include/asm-generic/ucontext.h
 create mode 100644 include/asm-generic/unaligned.h
 create mode 100644 include/asm-generic/unistd.h
 create mode 100644 include/asm-generic/user.h
 create mode 100644 include/asm-generic/vga.h
 create mode 100644 lib/checksum.c

