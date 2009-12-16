Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbZLPGFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbZLPGFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 01:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761578AbZLPGFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 01:05:30 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42252 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761574AbZLPGF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 01:05:29 -0500
Date: Wed, 16 Dec 2009 15:05:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.33-rc1, part 2.
Message-ID: <20091216060525.GE31265@linux-sh.org>
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

Francesco VIRLINZI (1):
      sh: intc: Fixed resume from hibernation

Kuninori Morimoto (6):
      sh: mach-ap325rxa: Add SOCAM_DATA_ACTIVE_HIGH flags for soc-camera
      sh: mach-ecovec24: MEMORY_SIZE fixup
      sh: ms7724se: Add ak4642 support
      sh: mach-ecovec24: Add tw9910 support
      sh: mach-ecovec24: Add mt9t112 camera support
      sh: mach-ecovec24: Add FSI sound support

Magnus Damm (14):
      sh: fix size calculation for NUMA node 0
      sh: NUMA lmb fixes
      sh: add a start_transfer() callback to the LCDC driver
      sh: LCDC start_transfer() for the KFR2R09 board
      sh-sci: Extend sh-sci driver with early console V2
      sh: sh2 scif pdata (sh7616)
      sh: sh2a scif pdata (sh7201/sh7203/sh7206/mxg)
      sh: sh3 scif pdata (sh7705/sh770x/sh7710/sh7720)
      sh: sh4 scif pdata (sh7750/sh7760/sh4-202)
      sh: sh4a scif pdata (sh7343/sh7366/sh7722/sh7723/sh7724)
      sh: sh4a scif pdata (sh7757/sh7763/sh7770/sh7780/sh7785/sh7786/x3)
      sh: sh5 scif pdata (sh5-101/sh5-103)
      sh: Remove old early serial console code V2
      sh: MSIOF/mmc_spi platform data for the Ecovec24 board

Matt Fleming (3):
      sh: Can't compare physical and virtual addresses for aliases
      sh: Couple kernel and user write page perm bits for CONFIG_X2TLB
      sh: Fix up FPU build for SH5

Nicolas Palix (1):
      sh: Replace an explicit computation by the use of the container_of macro

Paul Mundt (7):
      sh: intc: Fixup compile breakage.
      sh: pfc: Fixup type mismatch in debug printks.
      sh: ftrace: Fix up syscall tracing build.
      sh: Wire up recvmmsg syscall.
      sh: Make the unaligned trap handler always obey notification levels.
      sh: wire up vmallocinfo support in ioremap() implementations.
      sh: Stub in P3 ioremap support for nommu parts.

Roel Kluin (1):
      sh: Fix test of unsigned in se7722_irq_demux()

 arch/sh/Kconfig.debug                       |   44 ----
 arch/sh/boards/mach-ap325rxa/setup.c        |    3 +-
 arch/sh/boards/mach-ecovec24/setup.c        |  322 ++++++++++++++++++++++++++-
 arch/sh/boards/mach-kfr2r09/lcd_wqvga.c     |    6 +
 arch/sh/boards/mach-kfr2r09/setup.c         |    1 +
 arch/sh/boards/mach-se/7722/irq.c           |    7 +-
 arch/sh/boards/mach-se/7724/setup.c         |   17 ++
 arch/sh/configs/ecovec24-romimage_defconfig |    2 +-
 arch/sh/configs/ecovec24_defconfig          |    2 +-
 arch/sh/configs/rts7751r2d1_defconfig       |    2 +-
 arch/sh/configs/rts7751r2dplus_defconfig    |    2 +-
 arch/sh/include/asm/io.h                    |   11 +-
 arch/sh/include/asm/pgtable_32.h            |    5 +-
 arch/sh/include/asm/unistd_32.h             |    3 +-
 arch/sh/include/asm/unistd_64.h             |    3 +-
 arch/sh/include/mach-kfr2r09/mach/kfr2r09.h |    6 +
 arch/sh/kernel/Makefile                     |    3 +-
 arch/sh/kernel/cpu/irq/ipr.c                |    7 +-
 arch/sh/kernel/cpu/sh2/setup-sh7619.c       |   71 ++++--
 arch/sh/kernel/cpu/sh2a/setup-mxg.c         |   23 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7201.c      |  181 +++++++++++----
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c      |   89 +++++---
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c      |   89 +++++---
 arch/sh/kernel/cpu/sh3/setup-sh7705.c       |   49 +++--
 arch/sh/kernel/cpu/sh3/setup-sh770x.c       |   80 +++++--
 arch/sh/kernel/cpu/sh3/setup-sh7710.c       |   50 +++--
 arch/sh/kernel/cpu/sh3/setup-sh7720.c       |   50 +++--
 arch/sh/kernel/cpu/sh4/setup-sh4-202.c      |   23 +-
 arch/sh/kernel/cpu/sh4/setup-sh7750.c       |   47 +++--
 arch/sh/kernel/cpu/sh4/setup-sh7760.c       |   89 +++++---
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c      |  112 ++++++----
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c      |   39 ++--
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c      |   91 +++++---
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c      |  160 +++++++++-----
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c      |  149 +++++++++----
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c      |   92 +++++---
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c      |   81 +++++---
 arch/sh/kernel/cpu/sh4a/setup-sh7770.c      |  225 ++++++++++++++-----
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c      |   60 +++---
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c      |  159 +++++++++-----
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c      |  138 ++++++++----
 arch/sh/kernel/cpu/sh4a/setup-shx3.c        |   76 ++++---
 arch/sh/kernel/cpu/sh5/fpu.c                |    4 +-
 arch/sh/kernel/cpu/sh5/setup-sh5.c          |   22 +-
 arch/sh/kernel/early_printk.c               |  157 +-------------
 arch/sh/kernel/ftrace.c                     |   76 +------
 arch/sh/kernel/process_64.c                 |    4 +-
 arch/sh/kernel/ptrace_64.c                  |    4 +-
 arch/sh/kernel/setup.c                      |    3 +
 arch/sh/kernel/signal_64.c                  |    2 +-
 arch/sh/kernel/syscalls_32.S                |    1 +
 arch/sh/kernel/traps_32.c                   |   18 +-
 arch/sh/kernel/traps_64.c                   |    4 +-
 arch/sh/mm/cache-sh4.c                      |    3 +-
 arch/sh/mm/ioremap_32.c                     |   10 +-
 arch/sh/mm/ioremap_64.c                     |    6 +-
 arch/sh/mm/numa.c                           |   15 +-
 drivers/serial/sh-sci.c                     |   54 ++++-
 drivers/sh/intc.c                           |    2 +
 drivers/sh/pfc.c                            |    2 +-
 drivers/video/sh_mobile_lcdcfb.c            |   10 +-
 include/video/sh_mobile_lcdc.h              |    2 +
 62 files changed, 1961 insertions(+), 1107 deletions(-)
