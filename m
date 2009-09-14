Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbZINUIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbZINUIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756855AbZINUIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:15 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:53972 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbZINUIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:14 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 00/72] Blackfin updates for 2.6.32
Date: Mon, 14 Sep 2009 16:07:04 -0400
Message-Id: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor highlights:
 - shadow console to help with really early kernel output
 - proper decoding of double fault handling

Otherwise, we've got the normal bug fixes, IPIPE updates, and clean ups.

Barry Song (9):
  Blackfin: bf537-stamp: add resources for AD1938 audio card
  Blackfin: bf538: add bfin_clear_PPI_STATUS() helper
  Blackfin: bf537-stamp: update AD714x resources
  Blackfin: bf537-stamp: drop ATA interrupt probe workaround
  Blackfin: cm-bf527/bf537-stamp: fix dm9000 resources
  Blackfin: bf538-ezkit: add resources for parallel flash
  Blackfin: bf537-stamp: update ad1836 resources
  Blackfin: delete '-spi' suffix in ad1836/ad1938 driver name
  Blackfin: bf538-ezkit: add SPI IRQ resources

Bernd Schmidt (1):
  Blackfin: add ICPLB coverage for async banks

Cliff Cai (1):
  Blackfin: bf533-stamp: fix typo in SPI frequency for ad1836 codec

Graf Yang (5):
  Blackfin: fix MPU handling of invalid memory accesses
  Blackfin: improve double fault debug handling
  Blackfin: SMP port does not yet support cpu frequency scaling
  Blackfin: handle the core timer interrupt with handle_percpu_irq on
    SMP
  Blackfin: swap clocksource ratings for gptimer/cycles

Harald Krapfenbauer (2):
  Blackfin: cm-bf537u: split board from cm-bf537e
  Blackfin: update cm board resources

Ingo Molnar (1):
  Blackfin: Fix link errors with binutils 2.19 and GCC 4.3

Jean Delvare (1):
  Blackfin: clean up duplicate I2C device type definitions

Michael Hennerich (6):
  Blackfin: bf537-stamp: update ADP5588 header name
  Blackfin: rename PCF8574 driver config
  Blackfin: convert boards to use platform data with smc91x
  Blackfin: remove useless duplicated assignment in gpio code
  Blackfin: fix spelling in a few comments
  Blackfin: bf537-stamp: add adp5588 gpio resources

Mike Frysinger (15):
  Blackfin: cleanup traps decode_address() a bit
  Blackfin: convert ptrace to new memory functions
  Blackfin: cleanup printk() usage in module code
  Blackfin: convert malloc()/memset() to zalloc() in module code
  Blackfin: cleanup module section checking
  Blackfin: fix module reloc handling for all memory regions
  Blackfin: push SRAM locks down into related ifdefs
  Blackfin: add support for common FDPIC ptrace requests
  Blackfin: drop unused MMR defines that only cause bad code to be
    written
  Blackfin: fix BF522/BF523 max VCO mixup
  Blackfin: drop board resources for dead devices (pbx/ad9960)
  Blackfin: punt dead cache locking code
  Blackfin: optimize fixed code handling for the most common case
  Blackfin: add some isram-driver self tests
  Blackfin: update ftrace_push_return_trace() breakage

Mingquan Pan (1):
  Blackfin: use KERN_ALERT in all kgdb_test output

Philippe Gerum (10):
  Blackfin: checkpatch --file arch/blackfin/kernel/ipipe.c
  Blackfin: fix misnomer of some I-pipe helpers
  Blackfin: export show_stack() to modules
  Blackfin: allow high priority domains to preempt schedule_tail()
  Blackfin: use generic name for EVT14 handler
  Blackfin: reuse evt_evt14 handler to perform irqtail epilogue
  Blackfin: allow EVT5 to preempt irqtail prologue (CONFIG_DEBUG_HWERR)
  Blackfin: document __ipipe_call_irqtail
  Blackfin: sanitize manual control of IPEND[4]
  Blackfin: inline I-pipe bypass code in ret_from_exception

Robin Getz (7):
  Blackfin: make EVT3->EVT5 lowering more robust wrt IPEND[4]
  Blackfin: reject outdated/unused/wrong relocation types
  Blackfin: clean up early memory setup code
  Blackfin: add an early shadow console
  Blackfin: catch hardware errors earlier during booting
  Blackfin: workaround anomaly 05000283
  Blackfin: fix typo in isram_write()

Roel Kluin (1):
  Blackfin: fix read buffer overflow

Sonic Zhang (3):
  Blackfin: unify duplicated SMP checks in L2 cache kconfig
  Blackfin: do not try displaying the end of the stack
  Blackfin: increase default async timings for parallel flashes

Stefan Pledl (2):
  Blackfin: fix BF548 UART0 DMA IRQ translation
  Blackfin: bf548-ezkit: fix incorrect LCD size parameters

Yi Li (7):
  Blackfin: bf537-stamp: declare SPI IRQ resources
  Blackfin: bf533-stamp: add resources for mmc_spi card
  Blackfin: update anomaly lists
  Blackfin: cleanup sync handling when enabling/disabling cplbs
  Blackfin: do not trace the exception handler
  Blackfin: use raw_smp_processor_id() in exception code
  Blackfin: fix BF54x SPI CS resources

 arch/blackfin/Kconfig                             |   25 +-
 arch/blackfin/Kconfig.debug                       |    6 +
 arch/blackfin/configs/BF518F-EZBRD_defconfig      |    4 +-
 arch/blackfin/configs/BF526-EZBRD_defconfig       |    4 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig       |    4 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig       |    2 +-
 arch/blackfin/include/asm/bfin-global.h           |    6 -
 arch/blackfin/include/asm/bfin5xx_spi.h           |    1 +
 arch/blackfin/include/asm/cplb.h                  |   46 ++-
 arch/blackfin/include/asm/early_printk.h          |   24 +
 arch/blackfin/include/asm/entry.h                 |   30 +-
 arch/blackfin/include/asm/ipipe.h                 |    7 -
 arch/blackfin/include/asm/irq_handler.h           |    1 +
 arch/blackfin/include/asm/mmu_context.h           |    6 +-
 arch/blackfin/include/asm/pda.h                   |    7 +
 arch/blackfin/kernel/Makefile                     |    1 +
 arch/blackfin/kernel/asm-offsets.c                |    7 +
 arch/blackfin/kernel/bfin_dma_5xx.c               |   14 +-
 arch/blackfin/kernel/bfin_gpio.c                  |    1 -
 arch/blackfin/kernel/cplb-mpu/cacheinit.c         |    6 +-
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c           |   63 +--
 arch/blackfin/kernel/cplb-nompu/cacheinit.c       |    6 +-
 arch/blackfin/kernel/cplb-nompu/cplbinit.c        |   11 +-
 arch/blackfin/kernel/cplb-nompu/cplbmgr.c         |   35 +-
 arch/blackfin/kernel/early_printk.c               |   74 ++-
 arch/blackfin/kernel/entry.S                      |   24 +-
 arch/blackfin/kernel/ftrace.c                     |    2 +-
 arch/blackfin/kernel/ipipe.c                      |   83 ++--
 arch/blackfin/kernel/kgdb_test.c                  |    2 +-
 arch/blackfin/kernel/module.c                     |  266 ++++----
 arch/blackfin/kernel/process.c                    |   10 +-
 arch/blackfin/kernel/ptrace.c                     |  155 +++--
 arch/blackfin/kernel/setup.c                      |  120 ++---
 arch/blackfin/kernel/shadow_console.c             |  113 ++++
 arch/blackfin/kernel/time-ts.c                    |    4 +-
 arch/blackfin/kernel/traps.c                      |   88 ++-
 arch/blackfin/kernel/vmlinux.lds.S                |    4 +-
 arch/blackfin/lib/ins.S                           |    4 +-
 arch/blackfin/mach-bf518/boards/ezbrd.c           |   29 +-
 arch/blackfin/mach-bf518/include/mach/anomaly.h   |    1 +
 arch/blackfin/mach-bf518/include/mach/blackfin.h  |   10 -
 arch/blackfin/mach-bf527/boards/cm_bf527.c        |  164 ++---
 arch/blackfin/mach-bf527/boards/ezbrd.c           |   29 +-
 arch/blackfin/mach-bf527/boards/ezkit.c           |   58 +--
 arch/blackfin/mach-bf527/include/mach/anomaly.h   |   13 +-
 arch/blackfin/mach-bf527/include/mach/blackfin.h  |   10 -
 arch/blackfin/mach-bf533/boards/H8606.c           |   39 +-
 arch/blackfin/mach-bf533/boards/blackstamp.c      |   11 +
 arch/blackfin/mach-bf533/boards/cm_bf533.c        |  127 ++++-
 arch/blackfin/mach-bf533/boards/ezkit.c           |   13 +-
 arch/blackfin/mach-bf533/boards/stamp.c           |   83 ++-
 arch/blackfin/mach-bf533/dma.c                    |    8 +-
 arch/blackfin/mach-bf533/include/mach/blackfin.h  |    7 -
 arch/blackfin/mach-bf537/boards/Kconfig           |   12 +-
 arch/blackfin/mach-bf537/boards/Makefile          |    3 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c        |  638 ------------------
 arch/blackfin/mach-bf537/boards/cm_bf537e.c       |  727 +++++++++++++++++++++
 arch/blackfin/mach-bf537/boards/cm_bf537u.c       |  633 ++++++++++++++++++
 arch/blackfin/mach-bf537/boards/pnav10.c          |   29 +-
 arch/blackfin/mach-bf537/boards/stamp.c           |  249 ++++++--
 arch/blackfin/mach-bf537/boards/tcm_bf537.c       |   43 +-
 arch/blackfin/mach-bf537/dma.c                    |    8 +-
 arch/blackfin/mach-bf537/include/mach/anomaly.h   |    2 +-
 arch/blackfin/mach-bf537/include/mach/blackfin.h  |   90 ---
 arch/blackfin/mach-bf538/boards/ezkit.c           |   65 ++
 arch/blackfin/mach-bf538/include/mach/anomaly.h   |    2 +-
 arch/blackfin/mach-bf538/include/mach/blackfin.h  |   10 -
 arch/blackfin/mach-bf538/include/mach/cdefBF538.h |    1 +
 arch/blackfin/mach-bf548/boards/cm_bf548.c        |   19 +-
 arch/blackfin/mach-bf548/boards/ezkit.c           |   12 +-
 arch/blackfin/mach-bf548/dma.c                    |    8 +-
 arch/blackfin/mach-bf548/include/mach/anomaly.h   |   21 +-
 arch/blackfin/mach-bf548/include/mach/blackfin.h  |   89 ---
 arch/blackfin/mach-bf561/boards/cm_bf561.c        |  141 ++++-
 arch/blackfin/mach-bf561/boards/ezkit.c           |   13 +-
 arch/blackfin/mach-bf561/include/mach/anomaly.h   |    2 +
 arch/blackfin/mach-bf561/secondary.S              |   28 +-
 arch/blackfin/mach-common/Makefile                |    1 -
 arch/blackfin/mach-common/entry.S                 |  191 +++---
 arch/blackfin/mach-common/head.S                  |   19 +-
 arch/blackfin/mach-common/interrupt.S             |   78 ++--
 arch/blackfin/mach-common/ints-priority.c         |   19 +-
 arch/blackfin/mach-common/lock.S                  |  223 -------
 arch/blackfin/mach-common/pm.c                    |   64 +--
 arch/blackfin/mm/init.c                           |    3 +
 arch/blackfin/mm/isram-driver.c                   |  222 ++++++-
 arch/blackfin/mm/sram-alloc.c                     |   30 +-
 87 files changed, 3329 insertions(+), 2234 deletions(-)
 create mode 100644 arch/blackfin/kernel/shadow_console.c
 delete mode 100644 arch/blackfin/mach-bf537/boards/cm_bf537.c
 create mode 100644 arch/blackfin/mach-bf537/boards/cm_bf537e.c
 create mode 100644 arch/blackfin/mach-bf537/boards/cm_bf537u.c
 delete mode 100644 arch/blackfin/mach-common/lock.S

