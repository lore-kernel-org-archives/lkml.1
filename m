Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbYEILM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbYEILM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbYEILKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:10:13 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:20423 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758219AbYEILKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:10:08 -0400
Date: Fri, 9 May 2008 20:08:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.26-rc2
Message-ID: <20080509110852.GB6069@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Adrian Bunk (1):
      sh: remove the broken SH_MPC1211 support

Magnus Damm (16):
      sh: update smc91x platform data for MigoR
      sh: update smc91x platform data for se7722
      sh: fix sh7705 interrupt vector typo
      sh: add kernel bss resource
      sh: add memory resources to /proc/iomem
      sh: use sci_out() for early printk
      sh: drain and wait for early printk
      sh: reset hardware from early printk
      sh-sci: improve sh7722 support
      sh-sci: sh7722 lacks scsptr registers
      sh-sci: avoid writing to nonexistent registers
      sh: unify external irq pin code for sh3
      sh: add interrupt ack code to sh3
      sh: clean up sh7710 and sh7720 intc tables
      sh: no high level trigger on some sh3 cpus
      sh: intc register modify fix

Mathieu Desnoyers (1):
      sh: remove -traditional.

Paul Mundt (17):
      sh: sh-bios depends on SUPERH32.
      sh64: fixups for xtime_lock seqlock conversion.
      sh64: Fixup the nommu build.
      sh64: Fix up compile warning in event tracer.
      sh: kexec and kdump depend on SUPERH32.
      sh64: Setup I/D-TLB defaults in SH-5 probe path.
      mtd: solutionengine flash map depends on solution engine mach group.
      sh64: Some symbol exports to make the allmodconfig happier.
      sh64: export onchip_remap/unmap() too.
      sh: Enable use of the clk fwk on SH-5.
      input: i8042: sh64 IRQ definitions depend on cayman board.
      sh: intc_sh5 depends on cayman board for IRQ priority table.
      sh: rts7751r2d: Kill off unneeded ifdefs.
      sh: r7780rp: Kill off unneded ifdefs for irq setup.
      rtc: rtc-sh: Fixup for 64-bit resources.
      sh: Stub in cpu_to_node() and friends for NUMA build.
      sh: update smc91x platform data for se7206.

Roel Kluin (1):
      SH: catch negative denormal_subf1() retval in denormal_add()

Steve Glendinning (1):
      sh: Fix DMAC base address for SH7709S

 arch/sh/Kconfig                              |   17 +-
 arch/sh/Kconfig.debug                        |    1 +
 arch/sh/Makefile                             |    1 -
 arch/sh/boards/mpc1211/Makefile              |    8 -
 arch/sh/boards/mpc1211/pci.c                 |  295 ----------------------
 arch/sh/boards/mpc1211/rtc.c                 |  136 ----------
 arch/sh/boards/mpc1211/setup.c               |  347 --------------------------
 arch/sh/boards/renesas/migor/setup.c         |   11 +-
 arch/sh/boards/renesas/r7780rp/irq-r7780mp.c |    2 +-
 arch/sh/boards/renesas/r7780rp/irq-r7780rp.c |    2 +-
 arch/sh/boards/renesas/r7780rp/irq-r7785rp.c |    2 +-
 arch/sh/boards/renesas/r7780rp/setup.c       |   24 +--
 arch/sh/boards/renesas/rts7751r2d/setup.c    |    7 +-
 arch/sh/boards/se/7206/setup.c               |   17 +-
 arch/sh/boards/se/7722/setup.c               |    6 +
 arch/sh/boot/compressed/Makefile_32          |    1 -
 arch/sh/boot/compressed/Makefile_64          |    1 -
 arch/sh/kernel/cpu/irq/intc-sh5.c            |   73 +++---
 arch/sh/kernel/cpu/irq/intc.c                |   93 +++++++-
 arch/sh/kernel/cpu/sh2a/fpu.c                |    4 +-
 arch/sh/kernel/cpu/sh3/Makefile              |    2 +-
 arch/sh/kernel/cpu/sh3/setup-sh3.c           |   71 ++++++
 arch/sh/kernel/cpu/sh3/setup-sh7705.c        |   22 +--
 arch/sh/kernel/cpu/sh3/setup-sh770x.c        |   32 +--
 arch/sh/kernel/cpu/sh3/setup-sh7710.c        |   25 +--
 arch/sh/kernel/cpu/sh3/setup-sh7720.c        |   35 +---
 arch/sh/kernel/cpu/sh5/entry.S               |   28 ++
 arch/sh/kernel/cpu/sh5/probe.c               |    4 +
 arch/sh/kernel/early_printk.c                |   30 ++-
 arch/sh/kernel/setup.c                       |   46 ++++-
 arch/sh/kernel/sh_ksyms_32.c                 |    2 -
 arch/sh/kernel/sh_ksyms_64.c                 |   26 ++
 arch/sh/kernel/time_64.c                     |    5 +-
 arch/sh/lib64/dbg.c                          |    2 +-
 arch/sh/mm/Makefile_64                       |    7 +-
 arch/sh/mm/cache-sh5.c                       |    2 +
 arch/sh/mm/ioremap_64.c                      |    2 +
 arch/sh/mm/numa.c                            |    2 +-
 arch/sh/tools/mach-types                     |    1 -
 drivers/input/serio/i8042-io.h               |    2 +-
 drivers/mtd/maps/Kconfig                     |    9 +-
 drivers/mtd/maps/Makefile                    |    1 -
 drivers/mtd/maps/mpc1211.c                   |   80 ------
 drivers/rtc/rtc-sh.c                         |   14 +-
 drivers/serial/sh-sci.c                      |   32 +--
 drivers/serial/sh-sci.h                      |   27 ++-
 include/asm-sh/cpu-sh3/dma.h                 |   10 +-
 include/asm-sh/hw_irq.h                      |   19 ++
 include/asm-sh/io.h                          |   12 +-
 include/asm-sh/keyboard.h                    |   13 -
 include/asm-sh/mmu_context.h                 |    4 +-
 include/asm-sh/mmzone.h                      |    2 +
 include/asm-sh/mpc1211/dma.h                 |  303 ----------------------
 include/asm-sh/mpc1211/io.h                  |   22 --
 include/asm-sh/mpc1211/keyboard.h            |   60 -----
 include/asm-sh/mpc1211/m1543c.h              |  200 ---------------
 include/asm-sh/mpc1211/mc146818rtc.h         |    6 -
 include/asm-sh/mpc1211/mpc1211.h             |   18 --
 include/asm-sh/mpc1211/pci.h                 |   38 ---
 include/asm-sh/r7780rp.h                     |    4 +-
 include/asm-sh/tlb_64.h                      |   10 +-
 include/asm-sh/topology.h                    |   11 +
 include/asm-sh/uaccess_64.h                  |    2 +
 63 files changed, 498 insertions(+), 1793 deletions(-)
 delete mode 100644 arch/sh/boards/mpc1211/Makefile
 delete mode 100644 arch/sh/boards/mpc1211/pci.c
 delete mode 100644 arch/sh/boards/mpc1211/rtc.c
 delete mode 100644 arch/sh/boards/mpc1211/setup.c
 create mode 100644 arch/sh/kernel/cpu/sh3/setup-sh3.c
 delete mode 100644 drivers/mtd/maps/mpc1211.c
 delete mode 100644 include/asm-sh/keyboard.h
 delete mode 100644 include/asm-sh/mpc1211/dma.h
 delete mode 100644 include/asm-sh/mpc1211/io.h
 delete mode 100644 include/asm-sh/mpc1211/keyboard.h
 delete mode 100644 include/asm-sh/mpc1211/m1543c.h
 delete mode 100644 include/asm-sh/mpc1211/mc146818rtc.h
 delete mode 100644 include/asm-sh/mpc1211/mpc1211.h
 delete mode 100644 include/asm-sh/mpc1211/pci.h
