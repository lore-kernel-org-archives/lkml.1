Return-Path: <linux-kernel-owner+w=401wt.eu-S933611AbXGTJr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611AbXGTJr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 05:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbXGTJrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 05:47:51 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:55473 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888AbXGTJru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 05:47:50 -0400
Date: Fri, 20 Jul 2007 18:47:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] More sh updates for 2.6.23-rc1
Message-ID: <20070720094729.GA26886@linux-sh.org>
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

Kristoffer Ericson (1):
      sh: hd64461 tidying.

Magnus Damm (10):
      sh: Fix irq assignment for uarts on sh7722
      sh: intc - shared IPR and INTC2 controller
      sh: intc - add support for 7722 processor
      sh: clean up interrupt code for solution engine 7722 board
      sh: IPR/INTC2 IRQ setup consolidation.
      sh: intc - improve group support
      sh: intc - add support for 7780
      sh: zero terminate 8250 platform data for r2d board
      sh: update r2d defconfig and fix SH7751R pci compliation
      sh: intc - add support for SH7750 and its variants

Paul Mundt (15):
      sh: cpufreq: Fix driver dependencies and flag as broken.
      sh: push-switch: Correct license string.
      sh: Fix up SH-3 and SH-4 driver dependencies.
      sh: Wire up fallocate() syscall.
      sh: Fix up PCI section mismatch warnings.
      sh: Implement clk_round_rate() in the clock framework.
      sh: Support rate rounding for SH7722 FRQCR clocks.
      sh: cpufreq: clock framework support.
      Merge branch 'clkfwk'
      sh: Fix up CPU dependencies for on-chip DMAC.
      sh: Make on-chip DMA channel selection explicit.
      sh: cpufreq: Fix up the build for SH-2.
      sh: Many symbol exports for nommu allmodconfig.
      sh: heartbeat: Shut up resource size warning.
      sh: Move entry point code to .text.head.

Yoshihiro Shimoda (1):
      sh: r7780rp: Add R8A66597 and M66592 support.

 arch/sh/Kconfig                                    |   10 +
 arch/sh/Makefile                                   |    3 +-
 arch/sh/boards/mpc1211/pci.c                       |    2 +-
 arch/sh/boards/renesas/r7780rp/setup.c             |   54 +++
 arch/sh/boards/renesas/rts7751r2d/setup.c          |    3 +-
 arch/sh/boards/se/7722/irq.c                       |   96 ++----
 arch/sh/boards/se/7722/setup.c                     |    5 +-
 arch/sh/cchips/hd6446x/Makefile                    |    2 +
 .../cchips/hd6446x/{hd64461/setup.c => hd64461.c}  |    1 -
 arch/sh/cchips/hd6446x/hd64461/Makefile            |    6 -
 arch/sh/cchips/hd6446x/hd64461/io.c                |  150 --------
 arch/sh/configs/landisk_defconfig                  |    2 +-
 arch/sh/configs/lboxre2_defconfig                  |    2 +-
 arch/sh/configs/r7780mp_defconfig                  |    2 +-
 arch/sh/configs/r7780rp_defconfig                  |    2 +-
 arch/sh/configs/rts7751r2d_defconfig               |    8 +-
 arch/sh/configs/se7722_defconfig                   |    4 +-
 arch/sh/configs/se7750_defconfig                   |    2 +-
 arch/sh/configs/se7780_defconfig                   |    1 +
 arch/sh/drivers/dma/Kconfig                        |    3 +-
 arch/sh/drivers/heartbeat.c                        |    2 +-
 arch/sh/drivers/pci/Makefile                       |    1 +
 arch/sh/drivers/pci/ops-sh4.c                      |    2 +-
 arch/sh/drivers/pci/pci-st40.c                     |    2 +-
 arch/sh/drivers/pci/pci.c                          |    2 +-
 arch/sh/drivers/push-switch.c                      |    2 +-
 arch/sh/kernel/cpu/clock.c                         |   16 +
 arch/sh/kernel/cpu/irq/Makefile                    |    1 +
 arch/sh/kernel/cpu/irq/intc.c                      |  405 ++++++++++++++++++++
 arch/sh/kernel/cpu/sh2/setup-sh7619.c              |    2 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c             |    2 +-
 arch/sh/kernel/cpu/sh3/setup-sh7705.c              |    2 +-
 arch/sh/kernel/cpu/sh3/setup-sh7709.c              |    2 +-
 arch/sh/kernel/cpu/sh3/setup-sh7710.c              |    2 +-
 arch/sh/kernel/cpu/sh4/setup-sh7750.c              |  255 +++++++++----
 arch/sh/kernel/cpu/sh4/setup-sh7760.c              |    8 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c             |   15 +
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c             |  178 +++++++--
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c             |  221 +++++++++--
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c             |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-shx3.c               |    2 +-
 arch/sh/kernel/cpufreq.c                           |  215 ++++-------
 arch/sh/kernel/head.S                              |    3 +-
 arch/sh/kernel/irq.c                               |    9 +-
 arch/sh/kernel/setup.c                             |    7 +-
 arch/sh/kernel/sh_bios.c                           |    3 +-
 arch/sh/kernel/sh_ksyms.c                          |   35 ++
 arch/sh/kernel/syscalls.S                          |    1 +
 arch/sh/kernel/vmlinux.lds.S                       |    1 +
 arch/sh/mm/Kconfig                                 |   16 +-
 drivers/char/watchdog/Kconfig                      |    2 +-
 drivers/rtc/Kconfig                                |    2 +-
 include/asm-sh/clock.h                             |    1 +
 include/asm-sh/hw_irq.h                            |   77 ++++-
 include/asm-sh/se7722.h                            |   40 +-
 include/asm-sh/unistd.h                            |    3 +-
 56 files changed, 1326 insertions(+), 571 deletions(-)
