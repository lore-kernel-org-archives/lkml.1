Return-Path: <linux-kernel-owner+w=401wt.eu-S933678AbZGQAFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678AbZGQAFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933313AbZGQAFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:05:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39103 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933358AbZGQAFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 00/21] Blackfin fixes for 2.6.31
Date: Thu, 16 Jul 2009 20:05:25 -0400
Message-Id: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a whole bunch of small fixes / anomaly workarounds, nothing terribly
interesting.

Barry Song (1):
  Blackfin: bf537-stamp: fix irq decl for AD7142

Graf Yang (3):
  Blackfin: update anomaly lists to match latest sheets/usage
  Blackfin: update handling of anomaly 364 (wrong rev id in BF527-0.1)
  Blackfin: add CPLB entries for Core B on-chip L1 SRAM regions

Jie Zhang (1):
  Blackfin: fix miscompilation in lshrdi3

Julia Lawall (1):
  arch/blackfin: Add kmalloc NULL tests

Michael Hennerich (3):
  Blackfin: fix incomplete renaming of the bfin-twi-lcd driver
  Blackfin: fix bugs in GPIO resume code
  Blackfin: drop per-cpu loops_per_jiffy tracking

Mike Frysinger (5):
  Blackfin: drop dead flash_probe call
  Blackfin: restore exception banner when dumping crash info
  Blackfin: handle BF561 Core B memory regions better when SMP=n
  Blackfin: fix early_dma_memcpy() handling of busy channels
  Blackfin: define HARDIRQ_BITS again for now

Robin Getz (6):
  Blackfin: cleanup code a bit with comments and defines
  Blackfin: work around anomaly 05000281
  Blackfin: fix silent crash when no uClinux MTD filesystem exists
  Blackfin: drop duplicate runtime checking of anomaly 05000448
  Blackfin: fix handling of IPEND in interrupt context save
  Blackfin: work around anomaly 05000189

Sonic Zhang (1):
  Blackfin: fix wrong CTS inversion

 arch/blackfin/include/asm/context.S                |    7 ++-
 arch/blackfin/include/asm/cpu.h                    |    1 -
 arch/blackfin/include/asm/hardirq.h                |    3 +
 arch/blackfin/include/asm/processor.h              |   21 +++------
 arch/blackfin/kernel/bfin_dma_5xx.c                |   29 ++++++-------
 arch/blackfin/kernel/bfin_gpio.c                   |    6 +--
 arch/blackfin/kernel/cplb-nompu/cplbinit.c         |   23 ++++++++---
 arch/blackfin/kernel/process.c                     |   14 +++---
 arch/blackfin/kernel/setup.c                       |   44 ++++++++-----------
 arch/blackfin/kernel/traps.c                       |    9 +++-
 arch/blackfin/lib/lshrdi3.c                        |   16 +-------
 arch/blackfin/mach-bf518/boards/ezbrd.c            |    2 +-
 arch/blackfin/mach-bf518/include/mach/anomaly.h    |    2 +
 .../mach-bf518/include/mach/bfin_serial_5xx.h      |    2 +-
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |    2 +-
 arch/blackfin/mach-bf527/boards/ezbrd.c            |    2 +-
 arch/blackfin/mach-bf527/boards/ezkit.c            |    2 +-
 arch/blackfin/mach-bf527/include/mach/anomaly.h    |    4 +-
 .../mach-bf527/include/mach/bfin_serial_5xx.h      |    2 +-
 arch/blackfin/mach-bf533/boards/stamp.c            |    2 +-
 arch/blackfin/mach-bf533/include/mach/anomaly.h    |    1 +
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |    4 +-
 arch/blackfin/mach-bf537/include/mach/anomaly.h    |    2 +
 .../mach-bf537/include/mach/bfin_serial_5xx.h      |    2 +-
 arch/blackfin/mach-bf538/include/mach/anomaly.h    |    2 +
 .../mach-bf538/include/mach/bfin_serial_5xx.h      |    2 +-
 arch/blackfin/mach-bf548/boards/ezkit.c            |    2 +-
 arch/blackfin/mach-bf548/include/mach/anomaly.h    |    2 +
 arch/blackfin/mach-bf561/include/mach/anomaly.h    |    1 +
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |    2 +-
 arch/blackfin/mach-bf561/include/mach/mem_map.h    |   23 ++++++++++-
 arch/blackfin/mach-common/entry.S                  |   12 +++--
 arch/blackfin/mach-common/smp.c                    |   10 ++++-
 34 files changed, 145 insertions(+), 115 deletions(-)

