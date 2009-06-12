Return-Path: <linux-kernel-owner+w=401wt.eu-S1763851AbZFLLhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763851AbZFLLhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbZFLLhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:37:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41515 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867AbZFLLha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:37:30 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Pull request blackfin.git
Date: Fri, 12 Jun 2009 07:37:16 -0400
Message-Id: <1244806636-16845-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8ebf975608aaebd7feb33d77f07ba21a6380e086:
  Randy Dunlap (1):
        block: fix kernel-doc in recent block/ changes

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Graf Yang (13):
      Blackfin: fix link failure due to CONFIG_EXCEPTION_L1_SCRATCH
      Blackfin: fix bug found by traps test case 21
      Blackfin: add MDMA defines to make cross-variant coding easier
      Blackfin: work around anomaly 05000287
      Blackfin: BF518F-EZBRD: handle required portmuxing of async pins
      Blackfin: annotate anomaly 05000120
      Blackfin: add support for gptimer0 as a tick source
      Blackfin: add workaround for anomaly 05000287
      Blackfin: work around anomaly 05000220
      Blackfin: drop unused reserve_pda() function
      Blackfin: merge sram init functions
      Blackfin: fix handling of initial L1 reservation
      Blackfin: convert SMP to only use generic time framework

Mariusz Kozlowski (1):
      Blackfin: fix parentheses balance and convert some tab/space mixing

Michael Hennerich (5):
      Blackfin: add comment for anomaly 05000171 to init code
      Blackfin: fix up PATA resource handling in bf537-stamp
      Blackfin: do not error if GPIO IRQ is requested already as GPIO
      Blackfin: update gptimers API
      Blackfin: bf548-ezkit/bf537-stamp: add resources for ADXL345/346

Mike Frysinger (25):
      Blackfin: add some help text to the EBIU_AMBCTL settings
      Blackfin: fix data cache flushing when doing icache flushing
      Blackfin: fix warnings with I/O port macros
      Blackfin: pull updated anomaly lists from toolchain
      Blackfin: set bf51x/bf52x to 0.0 rev by default and bf54x to 0.2
      Blackfin: simplify the do_flush macro
      Blackfin: simplify BF561 coreb driver greatly
      Blackfin: fix detection of cached L2 SRAM
      Blackfin: punt useless GPIO init call
      Blackfin: delete unused sys_getpagesize() function
      Blackfin: workaround anomaly 05000227
      Blackfin: do not append newlines to panic() messages
      Blackfin: rename some Blackfin drivers
      Blackfin: add note about anomaly 05000242 being worked around
      Blackfin: fix command line corruption with DEBUG_DOUBLEFAULT
      Blackfin: override default uClinux MTD addr/size
      Blackfin: check SIC defines rather than variant names
      Blackfin: rename Blackfin relocs according to the toolchain
      Blackfin: document the lsl variants of the L1 allocator
      Blackfin: convert early_printk EVT init to a loop
      Blackfin: punt duplicated search_exception_table() prototype
      Blackfin: push access_ok() L1 attribute down
      Blackfin: kgdb: fix up error return values
      Blackfin: fix unused warnings after nommu update
      Blackfin: fix sparseirq/kstat_irqs fallout

Philippe Gerum (1):
      Blackfin: merge Philippe's recent ipipe patch

Robin Getz (11):
      Blackfin: allow scheduler functions to be placed into L1
      Blackfin: fix early L1 relocation crash
      Blackfin: document anomaly 05000234 workaround
      Blackfin: annotate anomaly 05000119 in core DMA code
      Blackfin: make sure MPU CPLB for first 1k is marked as valid
      Blackfin: make deferred hardware errors more exact
      Blackfin: make sure stack is accessible before dumping it
      Blackfin: add workaround for anomaly 05000461
      Blackfin: include system/processor info in dump messages
      Blackfin: add missing access_ok() checks to user functions
      Blackfin: export the last exception cause via debugfs

Roel Kluin (1):
      Blackfin: fix length checking in kgdb_ebin2mem

Sonic Zhang (4):
      Blackfin: Allow bf548 ATAPI to be routed to GPIO
      Blackfin: update defconfigs
      Blackfin: detect anomaly 05000274
      Blackfin: add SSYNC to set_dma_sg() for descriptor fetching

Yi Li (1):
      Blackfin: bf527-ezkit: add support for mmc-spi

 arch/blackfin/Kconfig                             |   84 +++-
 arch/blackfin/Kconfig.debug                       |   13 +
 arch/blackfin/configs/BF518F-EZBRD_defconfig      |  101 +++--
 arch/blackfin/configs/BF526-EZBRD_defconfig       |  219 ++++++----
 arch/blackfin/configs/BF527-EZKIT_defconfig       |  211 ++++++----
 arch/blackfin/configs/BF533-EZKIT_defconfig       |  103 +++--
 arch/blackfin/configs/BF533-STAMP_defconfig       |  105 +++--
 arch/blackfin/configs/BF537-STAMP_defconfig       |  109 +++--
 arch/blackfin/configs/BF538-EZKIT_defconfig       |  106 +++--
 arch/blackfin/configs/BF548-EZKIT_defconfig       |  253 +++++------
 arch/blackfin/configs/BF561-EZKIT_defconfig       |  116 +++--
 arch/blackfin/configs/BlackStamp_defconfig        |    4 +-
 arch/blackfin/configs/CM-BF527_defconfig          |   29 ++-
 arch/blackfin/configs/CM-BF533_defconfig          |   12 +-
 arch/blackfin/configs/CM-BF537E_defconfig         |  499 ++++++++++++---------
 arch/blackfin/configs/CM-BF537U_defconfig         |   12 +-
 arch/blackfin/configs/CM-BF548_defconfig          |   12 +-
 arch/blackfin/configs/CM-BF561_defconfig          |   12 +-
 arch/blackfin/configs/H8606_defconfig             |    8 +-
 arch/blackfin/configs/IP0X_defconfig              |    8 +-
 arch/blackfin/configs/PNAV-10_defconfig           |   39 +-
 arch/blackfin/configs/SRV1_defconfig              |    4 +-
 arch/blackfin/configs/TCM-BF537_defconfig         |   27 +-
 arch/blackfin/include/asm/cacheflush.h            |   40 +-
 arch/blackfin/include/asm/cplb.h                  |   35 +-
 arch/blackfin/include/asm/dma.h                   |   10 +-
 arch/blackfin/include/asm/elf.h                   |   84 ++--
 arch/blackfin/include/asm/entry.h                 |   92 ++++-
 arch/blackfin/include/asm/gptimers.h              |   43 +-
 arch/blackfin/include/asm/io.h                    |   29 +-
 arch/blackfin/include/asm/ipipe.h                 |    4 +-
 arch/blackfin/include/asm/pda.h                   |    2 -
 arch/blackfin/include/asm/processor.h             |    4 +-
 arch/blackfin/include/asm/time.h                  |    1 +
 arch/blackfin/include/asm/uaccess.h               |   32 +-
 arch/blackfin/kernel/bfin_dma_5xx.c               |   86 ++++
 arch/blackfin/kernel/bfin_gpio.c                  |   18 -
 arch/blackfin/kernel/bfin_ksyms.c                 |    1 -
 arch/blackfin/kernel/cplb-mpu/cacheinit.c         |    9 +-
 arch/blackfin/kernel/cplb-mpu/cplbinit.c          |    2 +-
 arch/blackfin/kernel/cplb-nompu/cacheinit.c       |    9 +-
 arch/blackfin/kernel/early_printk.c               |   16 +-
 arch/blackfin/kernel/gptimers.c                   |   30 +-
 arch/blackfin/kernel/ipipe.c                      |    9 +-
 arch/blackfin/kernel/irqchip.c                    |    2 +
 arch/blackfin/kernel/kgdb.c                       |   60 ++--
 arch/blackfin/kernel/module.c                     |   22 +-
 arch/blackfin/kernel/process.c                    |    3 +
 arch/blackfin/kernel/setup.c                      |   79 ++--
 arch/blackfin/kernel/sys_bfin.c                   |    5 -
 arch/blackfin/kernel/time-ts.c                    |  222 ++++++++--
 arch/blackfin/kernel/time.c                       |   53 +--
 arch/blackfin/kernel/traps.c                      |   52 ++-
 arch/blackfin/kernel/vmlinux.lds.S                |    5 +
 arch/blackfin/mach-bf518/Kconfig                  |    1 +
 arch/blackfin/mach-bf518/boards/ezbrd.c           |   19 +-
 arch/blackfin/mach-bf518/include/mach/anomaly.h   |   35 ++-
 arch/blackfin/mach-bf518/include/mach/portmux.h   |    6 +-
 arch/blackfin/mach-bf527/Kconfig                  |    1 +
 arch/blackfin/mach-bf527/boards/cm_bf527.c        |   10 +-
 arch/blackfin/mach-bf527/boards/ezbrd.c           |   10 +-
 arch/blackfin/mach-bf527/boards/ezkit.c           |   28 +-
 arch/blackfin/mach-bf527/include/mach/anomaly.h   |  168 +++++---
 arch/blackfin/mach-bf533/Kconfig                  |    1 +
 arch/blackfin/mach-bf533/boards/H8606.c           |    4 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c        |    4 +-
 arch/blackfin/mach-bf533/boards/ezkit.c           |    4 +-
 arch/blackfin/mach-bf533/boards/stamp.c           |    6 +-
 arch/blackfin/mach-bf533/include/mach/anomaly.h   |   88 +++-
 arch/blackfin/mach-bf537/Kconfig                  |    1 +
 arch/blackfin/mach-bf537/boards/cm_bf537.c        |    4 +-
 arch/blackfin/mach-bf537/boards/pnav10.c          |    8 +-
 arch/blackfin/mach-bf537/boards/stamp.c           |   69 +++-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c       |    4 +-
 arch/blackfin/mach-bf537/include/mach/anomaly.h   |   84 +++--
 arch/blackfin/mach-bf538/Kconfig                  |    1 +
 arch/blackfin/mach-bf538/include/mach/anomaly.h   |   60 ++-
 arch/blackfin/mach-bf538/include/mach/blackfin.h  |   19 -
 arch/blackfin/mach-bf538/include/mach/cdefBF538.h |   65 +++-
 arch/blackfin/mach-bf538/include/mach/defBF539.h  |   56 +++
 arch/blackfin/mach-bf548/Kconfig                  |    8 +
 arch/blackfin/mach-bf548/boards/ezkit.c           |   85 +++-
 arch/blackfin/mach-bf548/include/mach/anomaly.h   |   44 ++-
 arch/blackfin/mach-bf548/include/mach/portmux.h   |   64 ++-
 arch/blackfin/mach-bf561/Kconfig                  |   16 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c        |    4 +-
 arch/blackfin/mach-bf561/coreb.c                  |  396 ++---------------
 arch/blackfin/mach-bf561/include/mach/anomaly.h   |   25 +-
 arch/blackfin/mach-bf561/include/mach/cdefBF561.h |   29 ++
 arch/blackfin/mach-bf561/include/mach/defBF561.h  |   56 +++
 arch/blackfin/mach-bf561/smp.c                    |    4 +-
 arch/blackfin/mach-common/arch_checks.c           |    7 +
 arch/blackfin/mach-common/cache.S                 |   46 +--
 arch/blackfin/mach-common/clocks-init.c           |    1 +
 arch/blackfin/mach-common/cpufreq.c               |    3 +-
 arch/blackfin/mach-common/entry.S                 |   76 ++--
 arch/blackfin/mach-common/head.S                  |   34 +-
 arch/blackfin/mach-common/interrupt.S             |   27 ++
 arch/blackfin/mach-common/ints-priority.c         |   50 +--
 arch/blackfin/mach-common/smp.c                   |   12 +-
 arch/blackfin/mm/blackfin_sram.h                  |    1 -
 arch/blackfin/mm/init.c                           |   33 +-
 arch/blackfin/mm/isram-driver.c                   |    2 +-
 arch/blackfin/mm/sram-alloc.c                     |   21 +-
 104 files changed, 2998 insertions(+), 1947 deletions(-)
