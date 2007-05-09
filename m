Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbXEINC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbXEINC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbXEINCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:02:21 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:55817 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291AbXEINCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:02:20 -0400
Date: Wed, 9 May 2007 22:01:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh fixes
Message-ID: <20070509130152.GA22728@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There were some collisions with Andrew's last couple rounds of patches,
so this is a second set of updates that includes fixes for all of those
things, and gets us back to a working state.

Please pull from:

	master.kernel.org::/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Manuel Lauss (1):
      sh: SH7760 DMABRG support.

Paul Mundt (15):
      sh: generic quicklist support.
      rtc: rtc-sh: Fix up dev_dbg() warnings.
      sh: __GFP_REPEAT for pte allocations, too.
      sh: Always define TRAPA_BUG_OPCODE.
      sh: Share exception vector table for SH-3/4.
      sh: Kill off redundant __div64_32 symbol export.
      sh: Support for SH-2A 32-bit opcodes.
      sh: Fix PC adjustments for varying opcode length.
      sh: Add 32-bit opcode feature CPU flag.
      sh: Wire up utimensat syscall.
      sh: Convert to common die chain.
      rtc: rtc-sh: Fix rtc_dev pointer for rtc_update_irq().
      sh: Truncate MAX_ACTIVE_REGIONS for the common case.
      sh: clockevent/clocksource/hrtimers/nohz TMU support.
      sh: Fix stacktrace simplification fallout.

kogiidena (2):
      sh: Fixup ndelay() xloops calculation for alternate HZ.
      sh: landisk mv_nr_irqs definition.

 arch/sh/Kconfig                         |   29 +---
 arch/sh/boards/landisk/setup.c          |    1 
 arch/sh/drivers/Makefile                |    3 
 arch/sh/drivers/dma/Kconfig             |   20 ++-
 arch/sh/drivers/dma/Makefile            |    4 
 arch/sh/drivers/dma/dmabrg.c            |  196 ++++++++++++++++++++++++++++++++
 arch/sh/kernel/cpu/sh2a/Makefile        |    5 
 arch/sh/kernel/cpu/sh2a/opcode_helper.c |   55 ++++++++
 arch/sh/kernel/cpu/sh2a/probe.c         |    1 
 arch/sh/kernel/cpu/sh3/ex.S             |   13 +-
 arch/sh/kernel/cpu/sh4/Makefile         |    6 
 arch/sh/kernel/cpu/sh4/ex.S             |   62 ----------
 arch/sh/kernel/cpu/sh4/fpu.c            |    3 
 arch/sh/kernel/process.c                |   16 +-
 arch/sh/kernel/setup.c                  |    2 
 arch/sh/kernel/sh_ksyms.c               |    2 
 arch/sh/kernel/signal.c                 |   13 +-
 arch/sh/kernel/stacktrace.c             |    2 
 arch/sh/kernel/syscalls.S               |    1 
 arch/sh/kernel/time.c                   |  172 ++++++++--------------------
 arch/sh/kernel/timers/timer-tmu.c       |  182 +++++++++++++++++------------
 arch/sh/kernel/traps.c                  |   20 ---
 arch/sh/lib/delay.c                     |    5 
 arch/sh/mm/Kconfig                      |    7 +
 arch/sh/mm/fault.c                      |    2 
 arch/sh/mm/init.c                       |    2 
 drivers/rtc/rtc-sh.c                    |    8 -
 include/asm-sh/bug.h                    |    4 
 include/asm-sh/cpu-features.h           |    1 
 include/asm-sh/dmabrg.h                 |   23 +++
 include/asm-sh/kdebug.h                 |   25 ----
 include/asm-sh/pgalloc.h                |   44 ++++---
 include/asm-sh/system.h                 |    9 +
 include/asm-sh/timer.h                  |   25 ----
 include/asm-sh/unistd.h                 |    5 
 mm/Kconfig                              |    2 
 36 files changed, 572 insertions(+), 398 deletions(-)
