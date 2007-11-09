Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXKIJdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXKIJdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 04:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXKIJd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 04:33:28 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:10611 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751440AbXKIJd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 04:33:26 -0500
Date: Fri, 9 Nov 2007 18:33:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: [GIT PULL] sh updates for 2.6.24-rc3
Message-ID: <20071109093307.GA6840@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The only thing of note here (depending on whether one has a sadistic
inclination towards page colouring or not) is basically some of the
kmap_coherent() interfacing which fixes up regressions observed on some
old parts with 2-way aliasing VIPT dcaches. The clear_user_highpage() and
copy_user_highpage() bits are more or less directly adapted from MIPS,
with the PG_dcache_dirty/PG_mapped logic for lazy dcache writeback
flipped. These particular regressions started showing up in 2.6.23 after
the initial interface was merged. The rest is just idle bug fixing and
killing off some dead code.

sh64 also had a total of 1 trivial changeset, so that got pulled in to
this update as well for general completeness.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Jiri Olsa (1):
      sh: remove dead config symbols from SH code

Mike Frysinger (1):
      sh: remove PTRACE_O_TRACESYSGOOD from asm/ptrace.h

Nobuhiro Iwamatsu (4):
      sh: Add SH7705 and other to the support of Solution Engine.
      sh: Fix compression method when making uImage.
      sh: Remove SCI_NPORTS from sh-sci.h
      sh: Fix heartbeart on Solution Engine series

Paul Mundt (22):
      sh64: Kill off duplicate includes.
      sh: Kill off duplicate includes.
      sh: ubc wakeup for SH-4 only.
      sh: Fix up kgdb-on-NMI branch target.
      sh: Export __{s,u}divsi3_i4i on all CPUs.
      sh: Fix up kgdb build with modular sh-sci.
      sh: Add -Werror for clean directories.
      sh: kgdb sysrq depends on magic sysrq.
      superhyway: Handle device_register() retval properly.
      sh: Kill off the remaining ST40 cruft.
      sh: Wire up clear_user_highpage().
      sh: Optimized copy_{to,from}_user_page() for SH-4.
      sh: Kill off __{copy,clear}_user_page().
      sh: hs7751rvoip: irq.c needs linux/interrupt.h.
      sh: hs7751rvoip: Kill off dead IPR IRQ mappings.
      sh: Fix up PAGE_KERNEL_PCC() for nommu.
      rtc: sh-rtc: Handle rtc_device_register() failure properly.
      rtc: rtc-sh: Zero out tm value for invalid rtc states.
      sh: Add a dummy vga.h.
      sh: Kill off broken snapgear ds1302 code.
      Merge branch 'page_colouring_despair'
      Merge master.kernel.org:/.../lethal/sh64-2.6

 arch/sh/Kconfig                             |   10 +-
 arch/sh/Kconfig.debug                       |    3 +-
 arch/sh/boards/renesas/hs7751rvoip/irq.c    |    1 +
 arch/sh/boards/renesas/hs7751rvoip/setup.c  |   19 +-
 arch/sh/boards/renesas/sh7710voipgw/setup.c |    1 -
 arch/sh/boards/se/7206/irq.c                |    1 -
 arch/sh/boards/se/770x/setup.c              |    1 +
 arch/sh/boards/se/7722/setup.c              |    8 +
 arch/sh/boards/se/7780/setup.c              |    8 +
 arch/sh/boards/snapgear/Makefile            |    3 +-
 arch/sh/boards/snapgear/rtc.c               |  309 -----------------
 arch/sh/boards/snapgear/setup.c             |   16 +-
 arch/sh/boot/Makefile                       |    2 +-
 arch/sh/cchips/hd6446x/Makefile             |    2 +
 arch/sh/cchips/voyagergx/Makefile           |    1 +
 arch/sh/drivers/pci/Makefile                |    1 -
 arch/sh/drivers/pci/pci-st40.c              |  488 ---------------------------
 arch/sh/drivers/pci/pci-st40.h              |  136 --------
 arch/sh/kernel/Makefile                     |    3 +-
 arch/sh/kernel/cpu/sh3/ex.S                 |    2 +-
 arch/sh/kernel/cpu/sh4/probe.c              |    8 -
 arch/sh/kernel/irq.c                        |    1 -
 arch/sh/kernel/kgdb_stub.c                  |    9 +-
 arch/sh/kernel/setup.c                      |    1 -
 arch/sh/kernel/sh_ksyms.c                   |    2 -
 arch/sh/lib/Makefile                        |    2 +
 arch/sh/mm/Kconfig                          |   21 +--
 arch/sh/mm/Makefile                         |    2 +
 arch/sh/mm/clear_page.S                     |   45 ---
 arch/sh/mm/copy_page.S                      |   61 ----
 arch/sh/mm/pg-sh4.c                         |   75 +++--
 arch/sh/oprofile/Makefile                   |    1 +
 arch/sh64/kernel/process.c                  |   10 +-
 arch/sh64/kernel/traps.c                    |    5 -
 drivers/rtc/rtc-sh.c                        |    6 +-
 drivers/serial/sh-sci.h                     |   19 +-
 drivers/sh/superhyway/superhyway.c          |    7 +-
 include/asm-sh/cacheflush.h                 |   18 +-
 include/asm-sh/cpu-sh3/timer.h              |    6 +-
 include/asm-sh/page.h                       |   11 +-
 include/asm-sh/pgtable.h                    |    4 +-
 include/asm-sh/processor.h                  |    2 +-
 include/asm-sh/ptrace.h                     |    3 -
 include/asm-sh/vga.h                        |    6 +
 include/asm-sh64/ptrace.h                   |    2 -
 45 files changed, 148 insertions(+), 1194 deletions(-)
