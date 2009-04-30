Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbZD3PnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbZD3PnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932153AbZD3PmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57527 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbZD3PmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:00 -0400
Message-Id: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 30 Apr 2009 17:34:08 +0200
Subject: [PATCH 00/27] more non-ABI asm-generic headers
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX1+fSDn/CAzCuCU/nD4ay6xuihW8VKfzY6Y5bm/
 2ySqkEFD/JyX7A1hagdvV/C6N4glhocVBX88t8Jk+qWN0MnLF0
 Wx3EnPdBqWoPdwvTn6fAg==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the remaining asm-generic headers I prepared, along
with patches converting microblaze to use them, as an example.

The patches apply on top of my ABI related patches I posted
earlier this week. If people agree with the concept and I
have addressed all major concerns, I would like to get them
into linux-next and hopefully merged in 2.6.31.

To avoid trouble with quilt mail, I'm now trying
git-format-patch to generate them, hopefully this
works a little better. Can anyone tell me why I can't
add a 'To' header rather than just 'Cc' in
git-format-patch?

	Arnd <><

---

Arnd Bergmann (21):
  asm-generic: rename atomic.h to atomic-long.h
  asm-generic: add generic atomic.h
  asm-generic: make pci.h usable directly
  asm-generic: add legacy I/O header files
  asm-generic: add generic io.h
  asm-generic: add minimal cache description
  asm-generic: add generic versions of common headers
  asm-generic: add generic NOMMU versions of some headers
  asm-generic: rename page.h to getorder.h
  asm-generic: add generic page.h
  asm-generic: add a NOMMU uaccess.h
  asm-generic: make uaccess.h usable by mmu archs
  asm-generic: make bitops.h usable
  asm-generic: Add missing generic tlb_flush definition
  asm-generic: introduce generic syscalls.h
  add generic lib/checksum.c
  microblaze: use generic syscalls.h
  microblaze: make syscall_table implementation generic
  microblaze: use generic swab.h
  microblaze: don't include asm/mmu.h in hw_exception_handler
  microblaze: use generic dma-mapping.h

Remis Lima Baima (6):
  asm-generic: clean up asm-generic/io.h
  microblaze: use the generic lib/checksum.c
  microblaze: convert all simple headers to use asm-generic
  microblaze: use generic uaccess.h
  microblaze: make io.h use asm-generic/io.h
  microblaze: use generic system.h

 arch/alpha/include/asm/atomic.h                    |    2 +-
 arch/alpha/include/asm/page.h                      |    2 +-
 arch/arm/include/asm/atomic.h                      |    2 +-
 arch/arm/include/asm/page.h                        |    2 +-
 arch/avr32/include/asm/atomic.h                    |    2 +-
 arch/blackfin/include/asm/atomic.h                 |    2 +-
 arch/blackfin/include/asm/page.h                   |    2 +-
 arch/cris/include/asm/atomic.h                     |    2 +-
 arch/cris/include/asm/page.h                       |    2 +-
 arch/frv/include/asm/atomic.h                      |    2 +-
 arch/frv/include/asm/page.h                        |    2 +-
 arch/frv/include/asm/pci.h                         |   13 +-
 arch/h8300/include/asm/atomic.h                    |    2 +-
 arch/h8300/include/asm/page.h                      |    2 +-
 arch/ia64/include/asm/atomic.h                     |    2 +-
 arch/m32r/include/asm/atomic.h                     |    2 +-
 arch/m32r/include/asm/page.h                       |    2 +-
 arch/m32r/include/asm/pci.h                        |    2 -
 arch/m68k/include/asm/atomic_mm.h                  |    2 +-
 arch/m68k/include/asm/atomic_no.h                  |    2 +-
 arch/m68k/include/asm/page_mm.h                    |    2 +-
 arch/m68k/include/asm/page_no.h                    |    2 +-
 arch/microblaze/Kconfig                            |    8 +-
 arch/microblaze/include/asm/atomic.h               |  124 +------
 arch/microblaze/include/asm/bitops.h               |   28 +--
 arch/microblaze/include/asm/bug.h                  |   14 -
 arch/microblaze/include/asm/bugs.h                 |   18 +-
 arch/microblaze/include/asm/checksum.h             |  132 ++-----
 arch/microblaze/include/asm/cmpxchg-local.h        |    1 +
 arch/microblaze/include/asm/dma-mapping.h          |  130 +------
 arch/microblaze/include/asm/hardirq.h              |   14 +-
 arch/microblaze/include/asm/io.h                   |  240 ++----------
 arch/microblaze/include/asm/irq.h                  |    6 +-
 arch/microblaze/include/asm/irqflags.h             |    2 +-
 arch/microblaze/include/asm/kmap_types.h           |   30 +--
 arch/microblaze/include/asm/mmu.h                  |   20 +-
 arch/microblaze/include/asm/mmu_context.h          |   22 +-
 arch/microblaze/include/asm/module.h               |   10 +-
 arch/microblaze/include/asm/page.h                 |    2 +-
 arch/microblaze/include/asm/pgalloc.h              |   15 +-
 arch/microblaze/include/asm/scatterlist.h          |   29 +--
 arch/microblaze/include/asm/serial.h               |   15 +-
 arch/microblaze/include/asm/shmparam.h             |    7 +-
 arch/microblaze/include/asm/swab.h                 |    9 +-
 arch/microblaze/include/asm/syscalls.h             |   48 +--
 arch/microblaze/include/asm/system.h               |  121 ++-----
 arch/microblaze/include/asm/timex.h                |   19 +-
 arch/microblaze/include/asm/uaccess.h              |  164 ++------
 arch/microblaze/kernel/Makefile                    |    2 +-
 arch/microblaze/kernel/hw_exception_handler.S      |    1 -
 arch/microblaze/kernel/sys_microblaze.c            |   12 +-
 arch/microblaze/lib/Makefile                       |    2 +-
 arch/microblaze/lib/uaccess.c                      |   42 +--
 arch/mips/include/asm/atomic.h                     |    2 +-
 arch/mips/include/asm/page.h                       |    2 +-
 arch/mn10300/include/asm/atomic.h                  |    2 +-
 arch/parisc/include/asm/atomic.h                   |    2 +-
 arch/parisc/include/asm/page.h                     |    2 +-
 arch/parisc/include/asm/uaccess.h                  |    2 +-
 arch/powerpc/include/asm/atomic.h                  |    2 +-
 arch/powerpc/include/asm/page_32.h                 |    2 +-
 arch/powerpc/include/asm/page_64.h                 |    2 +-
 arch/s390/include/asm/atomic.h                     |    2 +-
 arch/s390/include/asm/page.h                       |    2 +-
 arch/sh/include/asm/atomic.h                       |    2 +-
 arch/sh/include/asm/page.h                         |    2 +-
 arch/sparc/include/asm/atomic_32.h                 |    2 +-
 arch/sparc/include/asm/atomic_64.h                 |    2 +-
 arch/sparc/include/asm/page_32.h                   |    2 +-
 arch/sparc/include/asm/page_64.h                   |    2 +-
 arch/sparc/include/asm/uaccess_64.h                |    2 +-
 arch/um/include/asm/page.h                         |    2 +-
 arch/x86/include/asm/atomic_32.h                   |    2 +-
 arch/x86/include/asm/atomic_64.h                   |    2 +-
 arch/x86/include/asm/page.h                        |    2 +-
 arch/xtensa/include/asm/atomic.h                   |    2 +-
 arch/xtensa/include/asm/page.h                     |    2 +-
 include/asm-generic/{atomic.h => atomic-long.h}    |    6 +-
 include/asm-generic/atomic.h                       |  423 ++++++++------------
 include/asm-generic/bitops.h                       |   24 +-
 include/asm-generic/bitops/atomic.h                |    1 +
 include/asm-generic/bugs.h                         |   10 +
 include/asm-generic/cache.h                        |   12 +
 include/asm-generic/cacheflush.h                   |   30 ++
 .../include/asm => include/asm-generic}/checksum.h |   65 +--
 include/asm-generic/current.h                      |    9 +
 include/asm-generic/delay.h                        |    9 +
 include/asm-generic/dma.h                          |   15 +
 include/asm-generic/fb.h                           |   12 +
 include/asm-generic/{page.h => getorder.h}         |    8 +-
 include/asm-generic/hardirq.h                      |   34 ++
 include/asm-generic/hw_irq.h                       |    9 +
 include/asm-generic/io.h                           |  300 ++++++++++++++
 include/asm-generic/irq.h                          |   18 +
 include/asm-generic/irqflags.h                     |   72 ++++
 include/asm-generic/kmap_types.h                   |   29 ++
 include/asm-generic/linkage.h                      |    8 +
 include/asm-generic/mmu.h                          |   14 +
 include/asm-generic/mmu_context.h                  |   45 ++
 include/asm-generic/module.h                       |   22 +
 include/asm-generic/mutex.h                        |    9 +
 include/asm-generic/page.h                         |  123 +++++--
 include/asm-generic/pci.h                          |    8 +
 include/asm-generic/pgalloc.h                      |   12 +
 include/asm-generic/scatterlist.h                  |   43 ++
 include/asm-generic/segment.h                      |    9 +
 include/asm-generic/serial.h                       |   13 +
 include/asm-generic/spinlock.h                     |   11 +
 include/asm-generic/string.h                       |   10 +
 include/asm-generic/syscalls.h                     |   60 +++
 include/asm-generic/system.h                       |  161 ++++++++
 include/asm-generic/timex.h                        |   29 ++
 include/asm-generic/tlb.h                          |    4 +
 include/asm-generic/tlbflush.h                     |   18 +
 .../asm-generic/{uaccess.h => uaccess-unaligned.h} |    6 +-
 include/asm-generic/uaccess.h                      |  261 +++++++++++--
 include/asm-generic/user.h                         |    8 +
 kernel/Makefile                                    |    1 +
 {arch/microblaze/kernel => kernel}/syscall_table.c |    2 +-
 lib/Makefile                                       |    2 +
 {arch/microblaze/lib => lib}/checksum.c            |   43 ++-
 121 files changed, 1850 insertions(+), 1548 deletions(-)
 rewrite arch/microblaze/include/asm/atomic.h (98%)
 rewrite arch/microblaze/include/asm/bitops.h (95%)
 rewrite arch/microblaze/include/asm/checksum.h (68%)
 create mode 100644 arch/microblaze/include/asm/cmpxchg-local.h
 rewrite arch/microblaze/include/asm/dma-mapping.h (100%)
 rewrite arch/microblaze/include/asm/io.h (94%)
 rewrite arch/microblaze/include/asm/kmap_types.h (100%)
 rewrite arch/microblaze/include/asm/mmu.h (100%)
 rewrite arch/microblaze/include/asm/mmu_context.h (100%)
 rewrite arch/microblaze/include/asm/scatterlist.h (100%)
 rewrite arch/microblaze/include/asm/syscalls.h (94%)
 rewrite arch/microblaze/include/asm/system.h (66%)
 rewrite arch/microblaze/include/asm/timex.h (100%)
 rewrite arch/microblaze/include/asm/uaccess.h (86%)
 rewrite arch/microblaze/lib/uaccess.c (97%)
 rename include/asm-generic/{atomic.h => atomic-long.h} (97%)
 rewrite include/asm-generic/atomic.h (98%)
 create mode 100644 include/asm-generic/bugs.h
 create mode 100644 include/asm-generic/cache.h
 create mode 100644 include/asm-generic/cacheflush.h
 rename {arch/microblaze/include/asm => include/asm-generic}/checksum.h (57%)
 create mode 100644 include/asm-generic/current.h
 create mode 100644 include/asm-generic/delay.h
 create mode 100644 include/asm-generic/dma.h
 create mode 100644 include/asm-generic/fb.h
 rename include/asm-generic/{page.h => getorder.h} (59%)
 create mode 100644 include/asm-generic/hardirq.h
 create mode 100644 include/asm-generic/hw_irq.h
 create mode 100644 include/asm-generic/io.h
 create mode 100644 include/asm-generic/irq.h
 create mode 100644 include/asm-generic/irqflags.h
 create mode 100644 include/asm-generic/kmap_types.h
 create mode 100644 include/asm-generic/linkage.h
 create mode 100644 include/asm-generic/mmu.h
 create mode 100644 include/asm-generic/mmu_context.h
 create mode 100644 include/asm-generic/module.h
 create mode 100644 include/asm-generic/mutex.h
 rewrite include/asm-generic/page.h (93%)
 create mode 100644 include/asm-generic/pgalloc.h
 create mode 100644 include/asm-generic/scatterlist.h
 create mode 100644 include/asm-generic/segment.h
 create mode 100644 include/asm-generic/serial.h
 create mode 100644 include/asm-generic/spinlock.h
 create mode 100644 include/asm-generic/string.h
 create mode 100644 include/asm-generic/syscalls.h
 create mode 100644 include/asm-generic/system.h
 create mode 100644 include/asm-generic/timex.h
 create mode 100644 include/asm-generic/tlbflush.h
 rename include/asm-generic/{uaccess.h => uaccess-unaligned.h} (82%)
 rewrite include/asm-generic/uaccess.h (96%)
 create mode 100644 include/asm-generic/user.h
 rename {arch/microblaze/kernel => kernel}/syscall_table.c (82%)
 rename {arch/microblaze/lib => lib}/checksum.c (79%)

