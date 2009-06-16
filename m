Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZFPKF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZFPKF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZFPKFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:05:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35236 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbZFPKFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:05:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Pull request blackfin.git
Date: Tue, 16 Jun 2009 06:05:40 -0400
Message-Id: <1245146740-13760-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f3ad116588151b3371ae4e092290e4f48e62b8bb:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../jlbec/configfs

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Graf Yang (1):
      Blackfin: bf518f-ezbrd: fix SPI CS for SPI flash

Jie Zhang (1):
      Blackfin: rename bfin_addr_dcachable to bfin_addr_dcacheable

Mike Frysinger (18):
      Blackfin: export ip_compute_csum/csum_partial_copy_from_user symbols
      Blackfin: add support for GENERIC_BUG
      Blackfin: fix trap_c() exit paths
      Blackfin: push down exception oops checking
      Blackfin: fix flag storage for irq funcs
      Blackfin: bf537-stamp: update ADP5520 resources
      Blackfin: bf548-ezkit: update smsc911x resources
      Blackfin: convert Kconfig style to def_bool
      Blackfin: add support for bzip2/lzma compressed kernel images
      Blackfin: add support for irqflags
      Blackfin: punt unused/wrong mutex-dec.h
      Blackfin: move custom sections into sections.h
      Blackfin: add preliminary support for STACKTRACE
      Blackfin: enable support for LOCKDEP
      Blackfin: initial support for ftrace
      Blackfin: initial support for ftrace grapher
      Blackfin: improve CLKIN_HZ config default
      Blackfin: hook up new rt_tgsigqueueinfo syscall

Robin Getz (3):
      Blackfin: only handle CPLB protection violations when MPU is enabled
      Blackfin: include the cpu compiled version in /proc/cpuinfo
      Blackfin: do not configure the UART early if on wrong processor

Sonic Zhang (2):
      Blackfin: add blackfin_invalidate_entire_icache for SMP systems
      Blackfin: fix deadlock in SMP IPI handler

Yi Li (2):
      Blackfin: define SPI IRQ in board resources
      Blackfin: update aedos-ipipe code to upstream 1.10-00

 arch/blackfin/Kconfig                        |   60 +++---
 arch/blackfin/Makefile                       |    7 +-
 arch/blackfin/boot/.gitignore                |    3 +-
 arch/blackfin/boot/Makefile                  |   31 +++-
 arch/blackfin/include/asm/atomic.h           |   16 +-
 arch/blackfin/include/asm/bfin-global.h      |   11 +-
 arch/blackfin/include/asm/bitops.h           |    3 +-
 arch/blackfin/include/asm/bug.h              |   57 +++++-
 arch/blackfin/include/asm/cache.h            |   11 +-
 arch/blackfin/include/asm/cacheflush.h       |    3 +-
 arch/blackfin/include/asm/cpu.h              |    1 +
 arch/blackfin/include/asm/ftrace.h           |   14 ++-
 arch/blackfin/include/asm/ipipe.h            |   28 ++--
 arch/blackfin/include/asm/irq.h              |  271 +-------------------------
 arch/blackfin/include/asm/irqflags.h         |   63 ++++++
 arch/blackfin/include/asm/mutex-dec.h        |  112 -----------
 arch/blackfin/include/asm/sections.h         |   11 +
 arch/blackfin/include/asm/system.h           |    4 +-
 arch/blackfin/include/asm/unistd.h           |    3 +-
 arch/blackfin/kernel/Makefile                |    5 +
 arch/blackfin/kernel/bfin_dma_5xx.c          |    4 +-
 arch/blackfin/kernel/bfin_ksyms.c            |    5 +
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c      |    2 +-
 arch/blackfin/kernel/cplb-nompu/cplbmgr.c    |   54 +-----
 arch/blackfin/kernel/early_printk.c          |    8 +-
 arch/blackfin/kernel/ftrace-entry.S          |  140 +++++++++++++
 arch/blackfin/kernel/ftrace.c                |   42 ++++
 arch/blackfin/kernel/ipipe.c                 |   42 ++--
 arch/blackfin/kernel/setup.c                 |   16 ++-
 arch/blackfin/kernel/stacktrace.c            |   53 +++++
 arch/blackfin/kernel/traps.c                 |  128 ++++++++-----
 arch/blackfin/kernel/vmlinux.lds.S           |   17 ++-
 arch/blackfin/lib/checksum.c                 |    2 +
 arch/blackfin/mach-bf518/boards/ezbrd.c      |   12 +-
 arch/blackfin/mach-bf527/boards/cm_bf527.c   |    5 +
 arch/blackfin/mach-bf527/boards/ezbrd.c      |    5 +
 arch/blackfin/mach-bf527/boards/ezkit.c      |    5 +
 arch/blackfin/mach-bf533/boards/H8606.c      |    5 +
 arch/blackfin/mach-bf533/boards/blackstamp.c |    5 +
 arch/blackfin/mach-bf533/boards/cm_bf533.c   |    5 +
 arch/blackfin/mach-bf533/boards/ezkit.c      |    5 +
 arch/blackfin/mach-bf533/boards/stamp.c      |    5 +
 arch/blackfin/mach-bf537/boards/cm_bf537.c   |    7 +-
 arch/blackfin/mach-bf537/boards/minotaur.c   |    5 +
 arch/blackfin/mach-bf537/boards/pnav10.c     |    7 +-
 arch/blackfin/mach-bf537/boards/stamp.c      |    2 +-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c  |    5 +
 arch/blackfin/mach-bf538/boards/ezkit.c      |   10 +
 arch/blackfin/mach-bf548/boards/cm_bf548.c   |   10 +
 arch/blackfin/mach-bf548/boards/ezkit.c      |   23 +++
 arch/blackfin/mach-bf561/boards/cm_bf561.c   |    7 +-
 arch/blackfin/mach-bf561/boards/ezkit.c      |    5 +
 arch/blackfin/mach-common/cache-c.c          |   14 ++-
 arch/blackfin/mach-common/entry.S            |   12 +-
 arch/blackfin/mach-common/smp.c              |   24 ++-
 drivers/spi/spi_bfin5xx.c                    |    4 +-
 56 files changed, 809 insertions(+), 605 deletions(-)
 create mode 100644 arch/blackfin/include/asm/irqflags.h
 delete mode 100644 arch/blackfin/include/asm/mutex-dec.h
 create mode 100644 arch/blackfin/kernel/ftrace-entry.S
 create mode 100644 arch/blackfin/kernel/ftrace.c
 create mode 100644 arch/blackfin/kernel/stacktrace.c
