Return-Path: <linux-kernel-owner+w=401wt.eu-S940385AbXGaEQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940385AbXGaEQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936396AbXGaEQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:16:12 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:39999 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935185AbXGaEQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:16:10 -0400
Date: Tue, 31 Jul 2007 13:15:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.23-rc2
Message-ID: <20070731041527.GB32301@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.23.git

Which contains:

Adrian McMenamin (1):
      sh: Fix Dreamcast DMA issues.

David McCullough (2):
      sh: arch/sh/boot - fix shell usage
      sh: fix get_wchan() for SH kernels without framepointers

Magnus Damm (4):
      sh: remove old broken pint code
      sh: remove support for sh73180 and solution engine 73180
      sh: sh-sci - fix SH7708 support
      sh: remove support for sh7300 and solution engine 7300

Markus Brunner (1):
      rtc: rtc-sh: Correct sh_rtc_set_time() for some SH-3 parts.

Paul Mundt (8):
      sh: Add kmap_coherent()/kunmap_coherent() interface for SH-4.
      sh: Reclaim beginning of P3 space for vmalloc area.
      sh: Kill the rest of the SE73180 cruft.
      sh: Silence sq compile warning on sh4 nommu.
      sh: Restrict DSP support to specific CPUs.
      sh: Kill off virt_to_bus()/bus_to_virt().
      sh: Add sh to the CC_OPTIMIZE_FOR_SIZE dependencies.
      sh: Fix fs.h removal from mm.h regressions.

 arch/sh/Kconfig                                    |   33 +-
 arch/sh/Makefile                                   |    2 -
 arch/sh/boards/se/7300/Makefile                    |    5 -
 arch/sh/boards/se/7300/io.c                        |  268 --------
 arch/sh/boards/se/7300/irq.c                       |   40 --
 arch/sh/boards/se/7300/setup.c                     |   74 --
 arch/sh/boards/se/73180/Makefile                   |    5 -
 arch/sh/boards/se/73180/io.c                       |  268 --------
 arch/sh/boards/se/73180/irq.c                      |  136 ----
 arch/sh/boards/se/73180/setup.c                    |   75 ---
 arch/sh/boot/Makefile                              |    7 +-
 arch/sh/boot/compressed/Makefile                   |    7 +-
 arch/sh/configs/se7300_defconfig                   |  696 --------------------
 arch/sh/configs/se73180_defconfig                  |  648 ------------------
 arch/sh/drivers/dma/dma-api.c                      |    7 +-
 arch/sh/kernel/cpu/irq/Makefile                    |    1 -
 arch/sh/kernel/cpu/irq/ipr.c                       |    2 +-
 arch/sh/kernel/cpu/irq/pint.c                      |  220 ------
 arch/sh/kernel/cpu/sh3/Makefile                    |    4 +-
 .../cpu/sh3/{clock-sh7300.c => clock-sh7710.c}     |   26 +-
 arch/sh/kernel/cpu/sh3/setup-sh7300.c              |   43 --
 arch/sh/kernel/cpu/sh4/probe.c                     |    6 -
 arch/sh/kernel/cpu/sh4/sq.c                        |   18 +-
 arch/sh/kernel/cpu/sh4a/Makefile                   |    2 -
 arch/sh/kernel/cpu/sh4a/clock-sh73180.c            |   81 ---
 arch/sh/kernel/cpu/sh4a/setup-sh73180.c            |   43 --
 arch/sh/kernel/init_task.c                         |    2 +-
 arch/sh/kernel/process.c                           |    7 +-
 arch/sh/kernel/setup.c                             |    3 +-
 arch/sh/kernel/sys_sh.c                            |    1 +
 arch/sh/kernel/timers/timer-tmu.c                  |    3 +-
 arch/sh/kernel/vsyscall/vsyscall.c                 |    1 +
 arch/sh/mm/Kconfig                                 |   14 +-
 arch/sh/mm/cache-sh4.c                             |   14 -
 arch/sh/mm/pg-sh4.c                                |   76 +--
 arch/sh/tools/mach-types                           |    2 -
 drivers/rtc/rtc-sh.c                               |    1 +
 drivers/serial/sh-sci.c                            |    9 +-
 drivers/serial/sh-sci.h                            |   66 +--
 include/asm-sh/bugs.h                              |    4 +-
 include/asm-sh/cpu-sh3/freq.h                      |    4 -
 include/asm-sh/cpu-sh3/mmu_context.h               |    1 -
 include/asm-sh/cpu-sh3/timer.h                     |    3 +-
 include/asm-sh/cpu-sh4/freq.h                      |    2 +-
 include/asm-sh/dma-mapping.h                       |    8 +-
 include/asm-sh/dma.h                               |    1 +
 include/asm-sh/fixmap.h                            |    8 +-
 include/asm-sh/floppy.h                            |    4 +-
 include/asm-sh/io.h                                |    4 -
 include/asm-sh/pgtable.h                           |    6 +-
 include/asm-sh/processor.h                         |    4 +-
 include/asm-sh/se7300.h                            |   64 --
 include/asm-sh/se73180.h                           |   66 --
 include/asm-sh/ubc.h                               |    3 +-
 init/Kconfig                                       |    2 +-
 sound/sh/aica.h                                    |    2 +-
 56 files changed, 138 insertions(+), 2964 deletions(-)
