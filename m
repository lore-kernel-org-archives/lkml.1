Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbZJHGFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbZJHGFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZJHGFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:05:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34511 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbZJHGFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:05:06 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 00/13] Blackfin updates for 2.6.32 (part 2)
Date: Thu,  8 Oct 2009 02:04:16 -0400
Message-Id: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many Blackfin files were missing proper copyright/license notifications,
so we audited the arch/blackfin/ tree and hopefully resolved all of that.
Get it in now to avoid thrashing later on.

Otherwise, we've got a few small bugfixes, board resource cleanups, and a
few arch improvements (fb, irq, time) that have been cooking for a while.

Barry Song (1):
  Blackfin: BF51x: add PTP MMR defines

Graf Yang (1):
  Blackfin: fix missed cache config renames

Jaswinder Singh Rajput (1):
  Blackfin: includecheck fix: mach-bf548, ezkit.c

John Stultz (1):
  Blackfin: convert to use arch_gettimeoffset()

Michael Hennerich (2):
  Blackfin: convert adv7393 resources to new i2c framework
  Blackfin: convert to GENERIC_HARDIRQS_NO__DO_IRQ

Mike Frysinger (5):
  Blackfin: asm/irq.h: pull in mach/anomaly.h for anomaly defines
  Blackfin: cplbinfo: drop d_path() hacks
  Blackfin: bf533-ezkit: convert to physmap/jedec_probe
  Blackfin: drop cs_change_per_word setting
  Blackfin: drop all simple-gpio board resources

Robin Getz (1):
  Blackfin: mass clean up of copyright/licensing info

Thomas Chou (1):
  Blackfin: fix framebuffer mmap bug for nommu

 arch/blackfin/ADI_BSD.txt                          |   41 ++++++
 arch/blackfin/Kconfig                              |   13 ++-
 arch/blackfin/include/asm/atomic.h                 |    6 +
 arch/blackfin/include/asm/bfin-global.h            |   26 +----
 arch/blackfin/include/asm/bfin5xx_spi.h            |    2 -
 arch/blackfin/include/asm/bfin_rotary.h            |    4 +
 arch/blackfin/include/asm/bfin_simple_timer.h      |    6 +
 arch/blackfin/include/asm/bitops.h                 |    6 +
 arch/blackfin/include/asm/blackfin.h               |    5 +-
 arch/blackfin/include/asm/bug.h                    |    6 +
 arch/blackfin/include/asm/byteorder.h              |    5 -
 arch/blackfin/include/asm/cache.h                  |    9 +-
 arch/blackfin/include/asm/cacheflush.h             |   27 +----
 arch/blackfin/include/asm/cdef_LPBlackfin.h        |   32 +----
 arch/blackfin/include/asm/checksum.h               |    9 +-
 arch/blackfin/include/asm/clocks.h                 |   27 +----
 arch/blackfin/include/asm/context.S                |   27 +----
 arch/blackfin/include/asm/cplb.h                   |   27 +----
 arch/blackfin/include/asm/cplbinit.h               |   27 +----
 arch/blackfin/include/asm/cpu.h                    |   21 +---
 arch/blackfin/include/asm/def_LPBlackfin.h         |   36 +-----
 arch/blackfin/include/asm/dma-mapping.h            |    6 +
 arch/blackfin/include/asm/dpmc.h                   |    6 +-
 arch/blackfin/include/asm/early_printk.h           |   22 +---
 arch/blackfin/include/asm/elf.h                    |    6 +-
 arch/blackfin/include/asm/entry.h                  |    6 +
 arch/blackfin/include/asm/fcntl.h                  |    6 +
 arch/blackfin/include/asm/fixed_code.h             |   10 ++-
 arch/blackfin/include/asm/flat.h                   |    5 +-
 arch/blackfin/include/asm/gpio.h                   |   27 +----
 arch/blackfin/include/asm/hardirq.h                |    6 +
 arch/blackfin/include/asm/io.h                     |    6 +
 arch/blackfin/include/asm/irq.h                    |   19 +--
 arch/blackfin/include/asm/irq_handler.h            |    6 +
 arch/blackfin/include/asm/l1layout.h               |    5 +-
 arch/blackfin/include/asm/linkage.h                |    6 +
 arch/blackfin/include/asm/mmu.h                    |    9 +-
 arch/blackfin/include/asm/mmu_context.h            |   27 +----
 arch/blackfin/include/asm/module.h                 |    6 +
 arch/blackfin/include/asm/mutex.h                  |    4 +
 arch/blackfin/include/asm/nand.h                   |   12 +--
 arch/blackfin/include/asm/page.h                   |    6 +
 arch/blackfin/include/asm/page_offset.h            |    9 +-
 arch/blackfin/include/asm/pda.h                    |   21 +---
 arch/blackfin/include/asm/pgtable.h                |   12 ++
 arch/blackfin/include/asm/poll.h                   |    7 +
 arch/blackfin/include/asm/portmux.h                |    5 +-
 arch/blackfin/include/asm/posix_types.h            |    6 +
 arch/blackfin/include/asm/processor.h              |    6 +
 arch/blackfin/include/asm/ptrace.h                 |    6 +
 arch/blackfin/include/asm/sections.h               |    6 +
 arch/blackfin/include/asm/segment.h                |    6 +
 arch/blackfin/include/asm/sigcontext.h             |    6 +
 arch/blackfin/include/asm/siginfo.h                |    6 +
 arch/blackfin/include/asm/smp.h                    |   21 +---
 arch/blackfin/include/asm/spinlock.h               |    6 +
 arch/blackfin/include/asm/spinlock_types.h         |    6 +
 arch/blackfin/include/asm/stat.h                   |    6 +
 arch/blackfin/include/asm/string.h                 |    6 +
 arch/blackfin/include/asm/swab.h                   |    6 +
 arch/blackfin/include/asm/system.h                 |   32 +-----
 arch/blackfin/include/asm/thread_info.h            |   24 +----
 arch/blackfin/include/asm/tlb.h                    |    6 +
 arch/blackfin/include/asm/trace.h                  |    5 +-
 arch/blackfin/include/asm/traps.h                  |   13 +--
 arch/blackfin/include/asm/uaccess.h                |    5 +-
 arch/blackfin/include/asm/unistd.h                 |    6 +
 arch/blackfin/kernel/asm-offsets.c                 |   27 +----
 arch/blackfin/kernel/bfin_dma_5xx.c                |    1 +
 arch/blackfin/kernel/bfin_gpio.c                   |   27 +----
 arch/blackfin/kernel/cplb-mpu/cplbinit.c           |   20 +---
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c            |   19 +---
 arch/blackfin/kernel/cplb-nompu/cplbinit.c         |   19 +---
 arch/blackfin/kernel/cplb-nompu/cplbmgr.c          |   16 +--
 arch/blackfin/kernel/cplbinfo.c                    |   26 ++--
 arch/blackfin/kernel/dma-mapping.c                 |   27 +----
 arch/blackfin/kernel/early_printk.c                |   23 +---
 arch/blackfin/kernel/entry.S                       |   27 +----
 arch/blackfin/kernel/fixed_code.S                  |    5 +
 arch/blackfin/kernel/flat.c                        |   18 +---
 arch/blackfin/kernel/init_task.c                   |   27 +----
 arch/blackfin/kernel/irqchip.c                     |   27 +----
 arch/blackfin/kernel/module.c                      |   27 +----
 arch/blackfin/kernel/process.c                     |   27 +----
 arch/blackfin/kernel/ptrace.c                      |   28 +----
 arch/blackfin/kernel/setup.c                       |    6 +-
 arch/blackfin/kernel/shadow_console.c              |    2 -
 arch/blackfin/kernel/signal.c                      |   27 +----
 arch/blackfin/kernel/sys_bfin.c                    |   41 +++----
 arch/blackfin/kernel/time-ts.c                     |   10 +-
 arch/blackfin/kernel/time.c                        |   63 +---------
 arch/blackfin/kernel/traps.c                       |   27 +----
 arch/blackfin/kernel/vmlinux.lds.S                 |   27 +----
 arch/blackfin/lib/ashldi3.c                        |   27 +----
 arch/blackfin/lib/ashrdi3.c                        |   27 +----
 arch/blackfin/lib/checksum.c                       |   30 +----
 arch/blackfin/lib/divsi3.S                         |   28 +----
 arch/blackfin/lib/gcclib.h                         |   27 +----
 arch/blackfin/lib/lshrdi3.c                        |   27 +----
 arch/blackfin/lib/memchr.S                         |   27 +----
 arch/blackfin/lib/memcmp.S                         |   27 +----
 arch/blackfin/lib/memcpy.S                         |   37 +-----
 arch/blackfin/lib/memmove.S                        |   27 +----
 arch/blackfin/lib/memset.S                         |   27 +----
 arch/blackfin/lib/modsi3.S                         |   36 +-----
 arch/blackfin/lib/muldi3.S                         |    6 +
 arch/blackfin/lib/outs.S                           |   29 +----
 arch/blackfin/lib/smulsi3_highpart.S               |    6 +
 arch/blackfin/lib/udivsi3.S                        |   27 +----
 arch/blackfin/lib/umodsi3.S                        |   27 +----
 arch/blackfin/lib/umulsi3_highpart.S               |    6 +
 arch/blackfin/mach-bf518/boards/ezbrd.c            |   45 +------
 arch/blackfin/mach-bf518/dma.c                     |   28 +----
 arch/blackfin/mach-bf518/include/mach/bf518.h      |   27 +----
 .../mach-bf518/include/mach/bfin_serial_5xx.h      |   29 +----
 arch/blackfin/mach-bf518/include/mach/blackfin.h   |   29 +----
 arch/blackfin/mach-bf518/include/mach/cdefBF512.h  |   29 +----
 arch/blackfin/mach-bf518/include/mach/cdefBF514.h  |   29 +----
 arch/blackfin/mach-bf518/include/mach/cdefBF516.h  |   29 +----
 arch/blackfin/mach-bf518/include/mach/cdefBF518.h  |   70 +++++++----
 .../mach-bf518/include/mach/cdefBF51x_base.h       |   28 +----
 arch/blackfin/mach-bf518/include/mach/defBF512.h   |   28 +----
 arch/blackfin/mach-bf518/include/mach/defBF514.h   |   28 +----
 arch/blackfin/mach-bf518/include/mach/defBF516.h   |   28 +----
 arch/blackfin/mach-bf518/include/mach/defBF518.h   |   56 +++++----
 .../mach-bf518/include/mach/defBF51x_base.h        |   28 +----
 arch/blackfin/mach-bf518/include/mach/gpio.h       |    3 -
 arch/blackfin/mach-bf518/include/mach/irq.h        |   29 +----
 arch/blackfin/mach-bf518/include/mach/portmux.h    |    6 +
 arch/blackfin/mach-bf518/ints-priority.c           |   27 +----
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |   61 ++--------
 arch/blackfin/mach-bf527/boards/ezbrd.c            |   45 +------
 arch/blackfin/mach-bf527/boards/ezkit.c            |   60 ++--------
 arch/blackfin/mach-bf527/dma.c                     |   28 +----
 arch/blackfin/mach-bf527/include/mach/bf527.h      |   27 +----
 .../mach-bf527/include/mach/bfin_serial_5xx.h      |   29 +----
 arch/blackfin/mach-bf527/include/mach/blackfin.h   |   29 +----
 arch/blackfin/mach-bf527/include/mach/cdefBF522.h  |   29 +----
 arch/blackfin/mach-bf527/include/mach/cdefBF525.h  |   29 +----
 arch/blackfin/mach-bf527/include/mach/cdefBF527.h  |   29 +----
 .../mach-bf527/include/mach/cdefBF52x_base.h       |   28 +----
 arch/blackfin/mach-bf527/include/mach/defBF522.h   |   28 +----
 arch/blackfin/mach-bf527/include/mach/defBF525.h   |   28 +----
 arch/blackfin/mach-bf527/include/mach/defBF527.h   |   28 +----
 .../mach-bf527/include/mach/defBF52x_base.h        |   28 +----
 arch/blackfin/mach-bf527/include/mach/gpio.h       |    3 -
 arch/blackfin/mach-bf527/include/mach/irq.h        |   29 +----
 arch/blackfin/mach-bf527/include/mach/portmux.h    |    6 +
 arch/blackfin/mach-bf527/ints-priority.c           |   27 +----
 arch/blackfin/mach-bf533/boards/H8606.c            |   33 +----
 arch/blackfin/mach-bf533/boards/blackstamp.c       |   29 +----
 arch/blackfin/mach-bf533/boards/cm_bf533.c         |   45 +------
 arch/blackfin/mach-bf533/boards/ezkit.c            |  132 ++++++++-----------
 arch/blackfin/mach-bf533/boards/ip0x.c             |   37 +-----
 arch/blackfin/mach-bf533/boards/stamp.c            |   60 ++--------
 arch/blackfin/mach-bf533/dma.c                     |   28 +----
 arch/blackfin/mach-bf533/include/mach/bf533.h      |   27 +----
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |   29 +----
 arch/blackfin/mach-bf533/include/mach/blackfin.h   |   28 +----
 arch/blackfin/mach-bf533/include/mach/cdefBF532.h  |   28 +----
 arch/blackfin/mach-bf533/include/mach/defBF532.h   |   44 +------
 arch/blackfin/mach-bf533/include/mach/gpio.h       |    3 -
 arch/blackfin/mach-bf533/include/mach/irq.h        |   28 +----
 arch/blackfin/mach-bf533/include/mach/portmux.h    |    6 +
 arch/blackfin/mach-bf533/ints-priority.c           |   27 +----
 arch/blackfin/mach-bf537/boards/cm_bf537e.c        |   46 +------
 arch/blackfin/mach-bf537/boards/cm_bf537u.c        |   46 +------
 arch/blackfin/mach-bf537/boards/minotaur.c         |    6 +
 arch/blackfin/mach-bf537/boards/pnav10.c           |   31 +----
 arch/blackfin/mach-bf537/boards/stamp.c            |   60 ++--------
 arch/blackfin/mach-bf537/boards/tcm_bf537.c        |   46 +------
 arch/blackfin/mach-bf537/dma.c                     |   28 +----
 arch/blackfin/mach-bf537/include/mach/bf537.h      |   27 +----
 .../mach-bf537/include/mach/bfin_serial_5xx.h      |   29 +----
 arch/blackfin/mach-bf537/include/mach/blackfin.h   |   29 +----
 arch/blackfin/mach-bf537/include/mach/cdefBF534.h  |   29 +----
 arch/blackfin/mach-bf537/include/mach/cdefBF537.h  |   29 +----
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |   28 +----
 arch/blackfin/mach-bf537/include/mach/defBF537.h   |   29 +----
 arch/blackfin/mach-bf537/include/mach/gpio.h       |    3 -
 arch/blackfin/mach-bf537/include/mach/irq.h        |   29 +----
 arch/blackfin/mach-bf537/include/mach/portmux.h    |    6 +
 arch/blackfin/mach-bf537/ints-priority.c           |   27 +----
 arch/blackfin/mach-bf538/boards/ezkit.c            |   46 +------
 arch/blackfin/mach-bf538/dma.c                     |   28 +----
 arch/blackfin/mach-bf538/include/mach/bf538.h      |   27 +----
 .../mach-bf538/include/mach/bfin_serial_5xx.h      |   29 +----
 arch/blackfin/mach-bf538/include/mach/blackfin.h   |   29 +----
 arch/blackfin/mach-bf538/include/mach/cdefBF538.h  |   28 +----
 arch/blackfin/mach-bf538/include/mach/defBF539.h   |   44 +------
 arch/blackfin/mach-bf538/include/mach/gpio.h       |    3 -
 arch/blackfin/mach-bf538/include/mach/irq.h        |   29 +----
 arch/blackfin/mach-bf538/include/mach/portmux.h    |    6 +
 arch/blackfin/mach-bf538/ints-priority.c           |   27 +----
 arch/blackfin/mach-bf548/boards/cm_bf548.c         |   48 +-------
 arch/blackfin/mach-bf548/boards/ezkit.c            |   49 +-------
 arch/blackfin/mach-bf548/dma.c                     |   27 +----
 arch/blackfin/mach-bf548/include/mach/bf548.h      |   27 +----
 .../blackfin/mach-bf548/include/mach/bf54x-lq043.h |    6 +
 arch/blackfin/mach-bf548/include/mach/bf54x_keys.h |    6 +
 .../mach-bf548/include/mach/bfin_serial_5xx.h      |   29 +----
 arch/blackfin/mach-bf548/include/mach/blackfin.h   |   29 +----
 arch/blackfin/mach-bf548/include/mach/cdefBF542.h  |   28 +----
 arch/blackfin/mach-bf548/include/mach/cdefBF544.h  |   28 +----
 arch/blackfin/mach-bf548/include/mach/cdefBF547.h  |   28 +----
 arch/blackfin/mach-bf548/include/mach/cdefBF548.h  |   28 +----
 arch/blackfin/mach-bf548/include/mach/cdefBF549.h  |   28 +----
 .../mach-bf548/include/mach/cdefBF54x_base.h       |   28 +----
 arch/blackfin/mach-bf548/include/mach/defBF542.h   |   28 +----
 arch/blackfin/mach-bf548/include/mach/defBF544.h   |   28 +----
 arch/blackfin/mach-bf548/include/mach/defBF547.h   |   28 +----
 arch/blackfin/mach-bf548/include/mach/defBF548.h   |   28 +----
 arch/blackfin/mach-bf548/include/mach/defBF549.h   |   28 +----
 .../mach-bf548/include/mach/defBF54x_base.h        |   28 +----
 arch/blackfin/mach-bf548/include/mach/gpio.h       |   30 +----
 arch/blackfin/mach-bf548/include/mach/irq.h        |   29 +----
 arch/blackfin/mach-bf548/include/mach/portmux.h    |    6 +
 arch/blackfin/mach-bf548/ints-priority.c           |   27 +----
 arch/blackfin/mach-bf561/atomic.S                  |   21 +---
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |   45 +------
 arch/blackfin/mach-bf561/boards/ezkit.c            |   44 +------
 arch/blackfin/mach-bf561/boards/tepla.c            |   14 +--
 arch/blackfin/mach-bf561/dma.c                     |   28 +----
 arch/blackfin/mach-bf561/include/mach/bf561.h      |   27 +----
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |   29 +----
 arch/blackfin/mach-bf561/include/mach/blackfin.h   |   28 +----
 arch/blackfin/mach-bf561/include/mach/cdefBF561.h  |   28 +----
 arch/blackfin/mach-bf561/include/mach/defBF561.h   |   29 +----
 arch/blackfin/mach-bf561/include/mach/gpio.h       |    3 -
 arch/blackfin/mach-bf561/include/mach/irq.h        |   29 +----
 arch/blackfin/mach-bf561/include/mach/portmux.h    |    6 +
 arch/blackfin/mach-bf561/include/mach/smp.h        |    6 +
 arch/blackfin/mach-bf561/ints-priority.c           |   27 +----
 arch/blackfin/mach-bf561/secondary.S               |   24 +---
 arch/blackfin/mach-bf561/smp.c                     |   21 +---
 arch/blackfin/mach-common/arch_checks.c            |   27 +----
 arch/blackfin/mach-common/cache-c.c                |    2 -
 arch/blackfin/mach-common/cache.S                  |    2 -
 arch/blackfin/mach-common/cpufreq.c                |   27 +----
 arch/blackfin/mach-common/entry.S                  |   31 +----
 arch/blackfin/mach-common/head.S                   |    2 -
 arch/blackfin/mach-common/interrupt.S              |   30 +----
 arch/blackfin/mach-common/ints-priority.c          |   35 ++----
 arch/blackfin/mach-common/irqpanic.c               |   27 +----
 arch/blackfin/mach-common/pm.c                     |   34 +-----
 arch/blackfin/mach-common/smp.c                    |   22 +---
 arch/blackfin/mm/blackfin_sram.h                   |   27 +----
 arch/blackfin/mm/init.c                            |   27 +----
 arch/blackfin/mm/isram-driver.c                    |   14 +--
 arch/blackfin/mm/sram-alloc.c                      |   27 +----
 250 files changed, 1078 insertions(+), 4717 deletions(-)
 create mode 100644 arch/blackfin/ADI_BSD.txt

