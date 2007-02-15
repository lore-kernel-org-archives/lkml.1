Return-Path: <linux-kernel-owner+w=401wt.eu-S966030AbXBOQQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966030AbXBOQQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966031AbXBOQQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:16:08 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:37782 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966030AbXBOQQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:16:07 -0500
Date: Fri, 16 Feb 2007 01:13:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates
Message-ID: <20070215161352.GA23873@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Andrew Morton (1):
      sh: add SH_CLK_MD Kconfig default.

Jamie Lenehan (1):
      sh: allow earlyprintk baud rate to be set via command line

Manuel Lauss (2):
      sh: add SH7760 IPR IRQ data
      sh: SH-DMAC compile fixes

Nobuhiro Iwamatsu (4):
      sh: Solution Engine 7750's defconfig update.
      sh: Solution Engine 770x IPR irq setup.
      sh: Fix handle_BUG() compile error.
      sh: Fixup SHMIN INTC register definitions.

Paul Mundt (23):
      sh: Use a jump call table for debug trap handlers.
      sh: Use proper SH-2A CFLAGS on newer compilers.
      sh: Fixup R7780RP iVDR clock enable.
      sh: More tidying for large base pages.
      sh: Lazy dcache writeback optimizations.
      sh: Don't set reserved _PAGE_WT bit on SH-3.
      sh: Use a per-cpu ASID cache.
      sh: Fixup cpu_data references for the non-boot CPUs.
      sh: Local TLB flushing variants for SMP prep.
      sh: Switch to local TLB flush variants in additional callsites.
      sh: dcache write-back for R7780RP PIO.
      sh: Fix syscall numbering breakage.
      sh: Move __KERNEL__ up in asm/page.h.
      sh: Add cpu-features header to asm/Kbuild.
      sh: Kill dead/unused ISA code from __ioremap().
      sh: Missing flush_dcache_all() proto in cacheflush.h.
      sh: define dma noncoherent API functions.
      sh: heartbeat consolidation for banked LEDs.
      sh: Compile fix for heartbeat consolidation.
      sh: Revert TLB miss fast-path changes that broke PTEA parts.
      sh: Fixup r7780rp pata_platform for devres conversion.
      sh: Kill off dead bigsur and ec3104 boards.
      sh: rts7751r2d board updates.

SUGIOKA Toshinobu (1):
      sh: syscall 300 should be __NR_fstatat64.

Takashi YOSHII (1):
      sh: shmin updates.

Yoshinori Sato (2):
      sh: Update SH-2 to use the debug trap jump table.
      sh: sh7619 / sh7206 IPR initialize update

 arch/sh/Kconfig                            |   17 -
 arch/sh/Makefile                           |    3 
 arch/sh/boards/bigsur/Makefile             |    6 
 arch/sh/boards/bigsur/io.c                 |  120 ----------
 arch/sh/boards/bigsur/irq.c                |  334 -----------------------------
 arch/sh/boards/bigsur/led.c                |   54 ----
 arch/sh/boards/bigsur/setup.c              |   88 -------
 arch/sh/boards/ec3104/Makefile             |    6 
 arch/sh/boards/ec3104/io.c                 |   81 -------
 arch/sh/boards/ec3104/irq.c                |  196 -----------------
 arch/sh/boards/ec3104/setup.c              |   65 -----
 arch/sh/boards/mpc1211/Makefile            |    2 
 arch/sh/boards/mpc1211/led.c               |   63 -----
 arch/sh/boards/mpc1211/setup.c             |   31 ++
 arch/sh/boards/renesas/r7780rp/Makefile    |    1 
 arch/sh/boards/renesas/r7780rp/io.c        |  152 +++----------
 arch/sh/boards/renesas/r7780rp/led.c       |   43 ---
 arch/sh/boards/renesas/r7780rp/setup.c     |   49 +++-
 arch/sh/boards/renesas/rts7751r2d/Makefile |    3 
 arch/sh/boards/renesas/rts7751r2d/io.c     |  302 --------------------------
 arch/sh/boards/renesas/rts7751r2d/irq.c    |   80 +-----
 arch/sh/boards/renesas/rts7751r2d/led.c    |   44 ---
 arch/sh/boards/renesas/rts7751r2d/setup.c  |  142 +++++++-----
 arch/sh/boards/se/7206/Makefile            |    2 
 arch/sh/boards/se/7206/led.c               |   57 ----
 arch/sh/boards/se/7206/setup.c             |   34 ++
 arch/sh/boards/se/7300/Makefile            |    2 
 arch/sh/boards/se/7300/led.c               |   54 ----
 arch/sh/boards/se/7300/setup.c             |   36 ++-
 arch/sh/boards/se/73180/Makefile           |    2 
 arch/sh/boards/se/73180/led.c              |   53 ----
 arch/sh/boards/se/73180/setup.c            |   31 ++
 arch/sh/boards/se/7343/Makefile            |    2 
 arch/sh/boards/se/7343/led.c               |   44 ---
 arch/sh/boards/se/7343/setup.c             |   26 +-
 arch/sh/boards/se/770x/Makefile            |    1 
 arch/sh/boards/se/770x/irq.c               |  108 ++++++---
 arch/sh/boards/se/770x/led.c               |   52 ----
 arch/sh/boards/se/770x/setup.c             |   43 ++-
 arch/sh/boards/se/7751/Makefile            |    1 
 arch/sh/boards/se/7751/led.c               |   51 ----
 arch/sh/boards/se/7751/setup.c             |   36 ++-
 arch/sh/boards/sh03/Makefile               |    1 
 arch/sh/boards/sh03/led.c                  |   48 ----
 arch/sh/boards/sh03/setup.c                |   30 ++
 arch/sh/boards/shmin/setup.c               |   12 -
 arch/sh/cchips/voyagergx/irq.c             |   70 ++----
 arch/sh/cchips/voyagergx/setup.c           |    4 
 arch/sh/configs/rts7751r2d_defconfig       |  308 ++++++++++++++++++++++----
 arch/sh/configs/se7750_defconfig           |  140 ++++++++++--
 arch/sh/drivers/Makefile                   |    1 
 arch/sh/drivers/dma/dma-sh.c               |   45 +--
 arch/sh/drivers/heartbeat.c                |  132 +++++++++++
 arch/sh/drivers/pci/Makefile               |    1 
 arch/sh/drivers/pci/ops-bigsur.c           |   83 -------
 arch/sh/drivers/pci/pci-sh7751.c           |    9 
 arch/sh/kernel/Makefile                    |    3 
 arch/sh/kernel/cpu/init.c                  |   41 ++-
 arch/sh/kernel/cpu/irq/ipr.c               |   19 +
 arch/sh/kernel/cpu/sh2/entry.S             |   12 -
 arch/sh/kernel/cpu/sh2/probe.c             |   32 +-
 arch/sh/kernel/cpu/sh2/setup-sh7619.c      |   62 ++---
 arch/sh/kernel/cpu/sh2a/probe.c            |   16 -
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c     |   89 +++----
 arch/sh/kernel/cpu/sh3/entry.S             |  207 +----------------
 arch/sh/kernel/cpu/sh3/probe.c             |   42 +--
 arch/sh/kernel/cpu/sh3/setup-sh7709.c      |   21 +
 arch/sh/kernel/cpu/sh4/probe.c             |  183 ++++++++-------
 arch/sh/kernel/cpu/sh4/setup-sh7750.c      |    4 
 arch/sh/kernel/cpu/sh4/setup-sh7760.c      |   66 ++++-
 arch/sh/kernel/debugtraps.S                |   41 +++
 arch/sh/kernel/early_printk.c              |   24 +-
 arch/sh/kernel/entry-common.S              |  119 +++-------
 arch/sh/kernel/io_generic.c                |   12 -
 arch/sh/kernel/kgdb_stub.c                 |    7 
 arch/sh/kernel/process.c                   |   95 ++++----
 arch/sh/kernel/setup.c                     |   49 ++--
 arch/sh/kernel/sh_ksyms.c                  |    1 
 arch/sh/kernel/signal.c                    |    6 
 arch/sh/kernel/syscalls.S                  |    8 
 arch/sh/kernel/traps.c                     |    4 
 arch/sh/mm/Kconfig                         |    5 
 arch/sh/mm/cache-debugfs.c                 |    4 
 arch/sh/mm/cache-sh3.c                     |    8 
 arch/sh/mm/cache-sh4.c                     |   77 +++---
 arch/sh/mm/cache-sh7705.c                  |   29 +-
 arch/sh/mm/fault.c                         |   87 +++++++
 arch/sh/mm/init.c                          |    7 
 arch/sh/mm/ioremap.c                       |    6 
 arch/sh/mm/pg-sh4.c                        |   28 --
 arch/sh/mm/pg-sh7705.c                     |   37 ---
 arch/sh/mm/tlb-flush.c                     |  101 ++++++--
 arch/sh/mm/tlb-nommu.c                     |   19 -
 arch/sh/mm/tlb-sh3.c                       |   67 -----
 arch/sh/mm/tlb-sh4.c                       |   70 ------
 arch/sh/oprofile/op_model_sh7750.c         |    2 
 arch/sh/tools/mach-types                   |    1 
 include/asm-sh/Kbuild                      |    2 
 include/asm-sh/bigsur/bigsur.h             |   80 ------
 include/asm-sh/bigsur/io.h                 |   35 ---
 include/asm-sh/bigsur/serial.h             |   24 --
 include/asm-sh/bugs.h                      |    6 
 include/asm-sh/cacheflush.h                |    3 
 include/asm-sh/cpu-sh3/cacheflush.h        |    2 
 include/asm-sh/cpu-sh4/cacheflush.h        |   13 -
 include/asm-sh/cpu-sh4/dma.h               |   11 
 include/asm-sh/dma-mapping.h               |    4 
 include/asm-sh/ec3104/ec3104.h             |   43 ---
 include/asm-sh/ec3104/io.h                 |   16 -
 include/asm-sh/ec3104/keyboard.h           |   15 -
 include/asm-sh/ec3104/serial.h             |   20 -
 include/asm-sh/irq.h                       |    4 
 include/asm-sh/kgdb.h                      |    8 
 include/asm-sh/mmu.h                       |   20 -
 include/asm-sh/mmu_context.h               |   61 +++--
 include/asm-sh/page.h                      |    3 
 include/asm-sh/pgtable.h                   |   11 
 include/asm-sh/processor.h                 |    6 
 include/asm-sh/rts7751r2d.h                |    4 
 include/asm-sh/serial.h                    |   11 
 include/asm-sh/thread_info.h               |   16 +
 include/asm-sh/tlbflush.h                  |   38 ++-
 include/asm-sh/ubc.h                       |    2 
 include/asm-sh/unistd.h                    |   20 -
 include/asm-sh/voyagergx.h                 |    5 
 125 files changed, 2012 insertions(+), 3583 deletions(-)
