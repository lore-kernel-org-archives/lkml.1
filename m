Return-Path: <linux-kernel-owner+w=401wt.eu-S1764795AbZFLQZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764795AbZFLQZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbZFLQYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:24:54 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39052 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbZFLQYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:24:53 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 00/27] Blackfin arch updates for 2.6.31 (part 2)
Date: Fri, 12 Jun 2009 12:24:18 -0400
Message-Id: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More bug fixes found while doing regression testing the last few weeks,
and some fun fancy stuff like:
	- selectable compression
	- irqflags
	- stacktrace
	- lockdep
	- ftrace
These low level features enable a bunch of new common code options too.

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
 arch/blackfin/include/asm/unistd.h           |    1 +
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
 56 files changed, 808 insertions(+), 604 deletions(-)
 create mode 100644 arch/blackfin/include/asm/irqflags.h
 delete mode 100644 arch/blackfin/include/asm/mutex-dec.h
 create mode 100644 arch/blackfin/kernel/ftrace-entry.S
 create mode 100644 arch/blackfin/kernel/ftrace.c
 create mode 100644 arch/blackfin/kernel/stacktrace.c

