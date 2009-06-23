Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbZFWEKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbZFWEKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZFWEKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:10:03 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56309 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbZFWEKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:10:00 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Pull request blackfin.git
Date: Tue, 23 Jun 2009 00:09:29 -0400
Message-Id: <1245730169-14593-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ac1b7c378ef26fba6694d5f118fe7fc16fee2fe2:
  Linus Torvalds (1):
        Merge git://git.infradead.org/mtd-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

FUJITA Tomonori (1):
      Blackfin: fix dma-mapping build errors

Graf Yang (3):
      Blackfin: bf526-ezbrd: set SPI flash resources to SST device
      Blackfin: fix typo in TRAS define in mem_init.h header
      Blackfin: bf526-ezbrd: handle different SDRAM chips

Jie Zhang (1):
      Blackfin: decouple unrelated cache settings to get exact behavior

Mike Frysinger (14):
      Blackfin: unify memory region checks between kgdb and traps
      Blackfin: bf518f-ezbrd: update DSA resources
      Blackfin: bf533-ezkit: add resources for FISP devices
      Blackfin: update anomaly lists
      Blackfin: redo handling of bad irqs
      Blackfin: only build show_interrupts() when procfs is enabled
      Blackfin: simplify irq stack overflow checking
      Blackfin: abstract irq14 lowering in do_irq
      Blackfin: allow people to select BF51x-0.1 silicon rev
      Blackfin: update defconfigs
      Blackfin: unify memory map headers
      Blackfin: drop unused ISP1760 port1_disable from board resources
      Blackfin: fix GPTMR0_CLOCKSOURCE dependency on BFIN_GPTIMERS
      Blackfin: hook up new perf_counter_open syscall

Philippe Gerum (4):
      Blackfin: convert interrupt pipeline to irqflags
      Blackfin: allow CONFIG_TICKSOURCE_GPTMR0 with interrupt pipeline
      Blackfin: remove obsolete mcount support from I-pipe code
      Blackfin: update I-pipe patch level

Robin Getz (2):
      Blackfin: stick the CPU name into boot image name
      Blackfin: fix early crash when booting on wrong cpu

Sonic Zhang (1):
      Blackfin: fix accidental reset in some boot modes

Yi Li (1):
      Blackfin: drop BF535-specific text for exception 0x2A (unaligned instruction)

 arch/blackfin/Kconfig                            |   68 ++++--
 arch/blackfin/boot/Makefile                      |    2 +-
 arch/blackfin/configs/BF518F-EZBRD_defconfig     |   24 +-
 arch/blackfin/configs/BF526-EZBRD_defconfig      |   22 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig      |   22 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig      |   25 ++-
 arch/blackfin/configs/BF533-STAMP_defconfig      |   22 +-
 arch/blackfin/configs/BF537-STAMP_defconfig      |   22 +-
 arch/blackfin/configs/BF538-EZKIT_defconfig      |   22 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig      |   27 ++-
 arch/blackfin/configs/BF561-EZKIT_defconfig      |   27 ++-
 arch/blackfin/configs/BlackStamp_defconfig       |   12 +-
 arch/blackfin/configs/CM-BF527_defconfig         |   22 +-
 arch/blackfin/configs/CM-BF533_defconfig         |   23 +-
 arch/blackfin/configs/CM-BF537E_defconfig        |   22 +-
 arch/blackfin/configs/CM-BF537U_defconfig        |   23 +-
 arch/blackfin/configs/CM-BF548_defconfig         |   25 ++-
 arch/blackfin/configs/CM-BF561_defconfig         |   25 ++-
 arch/blackfin/configs/H8606_defconfig            |   14 +-
 arch/blackfin/configs/PNAV-10_defconfig          |   20 +-
 arch/blackfin/configs/SRV1_defconfig             |   14 +-
 arch/blackfin/configs/TCM-BF537_defconfig        |   14 +-
 arch/blackfin/include/asm/blackfin.h             |    1 +
 arch/blackfin/include/asm/cache.h                |    4 +-
 arch/blackfin/include/asm/cacheflush.h           |   10 +-
 arch/blackfin/include/asm/cplb.h                 |   30 ++-
 arch/blackfin/include/asm/dma-mapping.h          |   13 +
 arch/blackfin/include/asm/ipipe.h                |   11 +-
 arch/blackfin/include/asm/ipipe_base.h           |   30 +-
 arch/blackfin/include/asm/irq.h                  |    7 -
 arch/blackfin/include/asm/irqflags.h             |  164 ++++++++++++-
 arch/blackfin/include/asm/mem_init.h             |   88 +++++++-
 arch/blackfin/include/asm/mem_map.h              |   97 ++++----
 arch/blackfin/include/asm/system.h               |    4 +-
 arch/blackfin/include/asm/traps.h                |    4 +-
 arch/blackfin/include/asm/uaccess.h              |   22 ++
 arch/blackfin/include/asm/unistd.h               |    3 +-
 arch/blackfin/kernel/Makefile                    |    1 -
 arch/blackfin/kernel/cplb-mpu/cplbinit.c         |   10 +-
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c          |   36 ++-
 arch/blackfin/kernel/ipipe.c                     |    7 +-
 arch/blackfin/kernel/irqchip.c                   |  114 ++++-----
 arch/blackfin/kernel/kgdb.c                      |  297 +++++++---------------
 arch/blackfin/kernel/mcount.S                    |   70 -----
 arch/blackfin/kernel/process.c                   |  151 +++++++++---
 arch/blackfin/kernel/setup.c                     |  122 +++++++--
 arch/blackfin/kernel/traps.c                     |   60 ++---
 arch/blackfin/mach-bf518/boards/ezbrd.c          |   16 +-
 arch/blackfin/mach-bf518/include/mach/anomaly.h  |   37 ++-
 arch/blackfin/mach-bf518/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf518/include/mach/mem_map.h  |   56 +----
 arch/blackfin/mach-bf527/boards/cm_bf527.c       |    1 -
 arch/blackfin/mach-bf527/boards/ezbrd.c          |    4 +-
 arch/blackfin/mach-bf527/boards/ezkit.c          |    1 -
 arch/blackfin/mach-bf527/include/mach/anomaly.h  |   15 +-
 arch/blackfin/mach-bf527/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf527/include/mach/mem_map.h  |   56 +----
 arch/blackfin/mach-bf533/boards/ezkit.c          |  106 ++++++++
 arch/blackfin/mach-bf533/include/mach/anomaly.h  |   77 +++---
 arch/blackfin/mach-bf533/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf533/include/mach/mem_map.h  |   56 +----
 arch/blackfin/mach-bf537/boards/stamp.c          |    1 -
 arch/blackfin/mach-bf537/include/mach/anomaly.h  |   41 ++--
 arch/blackfin/mach-bf537/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf537/include/mach/mem_map.h  |   56 +----
 arch/blackfin/mach-bf538/include/mach/anomaly.h  |   24 ++-
 arch/blackfin/mach-bf538/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf538/include/mach/mem_map.h  |   57 +----
 arch/blackfin/mach-bf548/boards/ezkit.c          |    1 -
 arch/blackfin/mach-bf548/include/mach/anomaly.h  |   20 +-
 arch/blackfin/mach-bf548/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf548/include/mach/mem_map.h  |   51 +---
 arch/blackfin/mach-bf561/boards/ezkit.c          |    1 -
 arch/blackfin/mach-bf561/include/mach/anomaly.h  |   89 ++++---
 arch/blackfin/mach-bf561/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf561/include/mach/mem_map.h  |   58 +++-
 arch/blackfin/mach-common/arch_checks.c          |    4 +-
 arch/blackfin/mach-common/cpufreq.c              |    2 +-
 arch/blackfin/mach-common/entry.S                |    1 +
 arch/blackfin/mach-common/ints-priority.c        |   47 ++--
 arch/blackfin/mach-common/pm.c                   |    4 +-
 arch/blackfin/mm/init.c                          |    2 +-
 82 files changed, 1529 insertions(+), 1215 deletions(-)
 delete mode 100644 arch/blackfin/kernel/mcount.S
