Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbYBNF7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbYBNF7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYBNF7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:59:03 -0500
Received: from pip12.gyao.ne.jp ([61.122.117.250]:59593 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752004AbYBNF7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:59:00 -0500
Date: Thu, 14 Feb 2008 14:57:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.25-rc2
Message-ID: <20080214055744.GD12436@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
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

Adrian McMenamin (4):
      maple: fix up whitespace damage.
      maple: more robust device detection.
      maple: Drop unused prototypes from linux/maple.h.
      maple: improve detection of attached peripherals

Alan Cox (1):
      sh: termios ioctl definitions

Hideo Saito (1):
      sh: Fix multiple UTLB hit on UP SH-4.

Kristoffer Ericson (1):
      sh: Tidy include/asm-sh/hp6xx.h

Magnus Damm (18):
      sh: declared coherent memory support V2 fix
      sh: add sh7722 support to EARLY_SCIF_CONSOLE
      sh: add probe support for new sh7722 cut
      sh: break out unaligned sign extension code
      sh: migor board support
      sh: make copy_to/from_user() static inline
      sh: add byte support to the sign extension code
      sh: use opcode_t and enable unaligned code for sh2a
      sh: update r2d defconfigs with usb, spi and rtc
      sh: trapped io support V2
      sh: trapped io support for r2d V2
      sh: trapped io support for highlander V2
      sh: fix ptrace copy_from/to_user() compilation error
      sh: remove maskreg irq code
      sh: add support for sh7366 processor
      sh: use ctrl_in/out for on chip pci access
      sh: fix ioreadN_rep and iowriteN_rep
      sh: fix pci io access for r2d boards

Paul Mundt (19):
      sh: Wire up new timerfd syscalls.
      sh: Add mach-type entries for MigoR and SDK7780.
      sh: Use max_t in io_trapped.
      sh: Clean up whitespace damage in Kconfig.debug.
      sh: Symbol exports for trapped I/O.
      sh: Handle SH7366 CPU in check_bugs().
      sh: Disable big endian for SH-5.
      sh: Fix up pte_mkhuge() build breakage for SH-5.
      sh: Fix up set_fixmap_nocache() for SH-5.
      sh: Update SH-5 flush_cache_sigtramp() for API changes.
      sh: Shut up some trivial build warnings.
      sh: asm/tlb.h needs linux/pagemap.h for CONFIG_SWAP=n.
      sh: Kill off bogus SH_SDK7780_STANDALONE symbol.
      maple: Fix up maple build failure.
      sh: Get SH-5 caches working again post-unification.
      serial: sh-sci: Fix up SH-5 build.
      sh: asm/irq.h needs asm/cpu/irq.h.
      sh: __uncached_start only on sh32.
      sh: Kill off more dead symbols.

Peter Zijlstra (1):
      sh: fix xtime_lock deadlocking.

Stephen Rothwell (1):
      sh: remove unneeded cast

 arch/sh/Kconfig                           |   19 +
 arch/sh/Kconfig.cpu                       |    4 +-
 arch/sh/Kconfig.debug                     |    3 +-
 arch/sh/Makefile                          |    1 +
 arch/sh/boards/renesas/migor/Makefile     |    1 +
 arch/sh/boards/renesas/migor/setup.c      |   61 ++
 arch/sh/boards/renesas/r7780rp/setup.c    |   47 +-
 arch/sh/boards/renesas/rts7751r2d/setup.c |   45 +-
 arch/sh/boards/renesas/sdk7780/Kconfig    |    7 -
 arch/sh/cchips/hd6446x/hd64465/setup.c    |   47 +-
 arch/sh/configs/migor_defconfig           |  824 +++++++++++++++++++++++
 arch/sh/configs/rts7751r2d1_defconfig     |  340 ++++++++---
 arch/sh/configs/rts7751r2dplus_defconfig  |  340 ++++++++---
 arch/sh/configs/se7705_defconfig          |    1 -
 arch/sh/drivers/dma/dma-api.c             |    2 +-
 arch/sh/drivers/pci/fixups-lboxre2.c      |    4 +-
 arch/sh/drivers/pci/fixups-rts7751r2d.c   |    4 +-
 arch/sh/drivers/pci/ops-dreamcast.c       |   44 +-
 arch/sh/drivers/pci/ops-rts7751r2d.c      |    3 +-
 arch/sh/drivers/pci/pci-sh4.h             |    4 +-
 arch/sh/drivers/pci/pci-sh7751.c          |   16 +-
 arch/sh/drivers/pci/pci-sh7780.c          |    2 +-
 arch/sh/kernel/Makefile_32                |    1 +
 arch/sh/kernel/Makefile_64                |    1 +
 arch/sh/kernel/cpu/irq/Makefile           |    1 -
 arch/sh/kernel/cpu/irq/intc-sh5.c         |   27 +-
 arch/sh/kernel/cpu/irq/maskreg.c          |   93 ---
 arch/sh/kernel/cpu/sh4/probe.c            |    8 +-
 arch/sh/kernel/cpu/sh4a/Makefile          |    2 +
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c    |   10 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c    |  177 +++++
 arch/sh/kernel/cpu/sh5/probe.c            |   61 +-
 arch/sh/kernel/io.c                       |    8 +-
 arch/sh/kernel/io_generic.c               |   24 +-
 arch/sh/kernel/io_trapped.c               |  276 ++++++++
 arch/sh/kernel/irq.c                      |    3 -
 arch/sh/kernel/process_64.c               |    9 +-
 arch/sh/kernel/ptrace_32.c                |    4 +-
 arch/sh/kernel/setup.c                    |    2 +-
 arch/sh/kernel/syscalls_32.S              |    4 +-
 arch/sh/kernel/syscalls_64.S              |    4 +-
 arch/sh/kernel/time_32.c                  |   19 +-
 arch/sh/kernel/time_64.c                  |   31 +-
 arch/sh/kernel/timers/timer-mtu2.c        |    1 -
 arch/sh/kernel/traps_32.c                 |  164 +++---
 arch/sh/kernel/traps_64.c                 |    4 +-
 arch/sh/kernel/vmlinux_64.lds.S           |    2 +-
 arch/sh/mm/cache-sh5.c                    | 1019 ++++++++++++-----------------
 arch/sh/mm/consistent.c                   |   30 +-
 arch/sh/mm/fault_32.c                     |   11 +
 arch/sh/mm/init.c                         |    2 +
 arch/sh/tools/mach-types                  |    2 +
 drivers/serial/sh-sci.c                   |    2 +-
 drivers/serial/sh-sci.h                   |    9 +-
 drivers/sh/maple/maple.c                  |  981 ++++++++++++++--------------
 include/asm-sh/bugs.h                     |    2 +-
 include/asm-sh/cpu-sh4/freq.h             |    4 +-
 include/asm-sh/cpu-sh5/cacheflush.h       |    6 +-
 include/asm-sh/cpu-sh5/mmu_context.h      |    6 -
 include/asm-sh/hp6xx.h                    |   28 +-
 include/asm-sh/io.h                       |   22 +-
 include/asm-sh/io_trapped.h               |   58 ++
 include/asm-sh/ioctls.h                   |    4 +
 include/asm-sh/irq.h                      |    4 +
 include/asm-sh/mmu_context_64.h           |    3 +
 include/asm-sh/page.h                     |    7 +-
 include/asm-sh/pgtable_64.h               |   13 +
 include/asm-sh/processor.h                |    2 +-
 include/asm-sh/r7780rp.h                  |    3 -
 include/asm-sh/rts7751r2d.h               |    3 -
 include/asm-sh/system.h                   |    5 +
 include/asm-sh/system_32.h                |    3 +
 include/asm-sh/termbits.h                 |    5 +-
 include/asm-sh/termios.h                  |    6 +-
 include/asm-sh/tlb.h                      |    1 +
 include/asm-sh/uaccess.h                  |   29 +
 include/asm-sh/uaccess_32.h               |   24 +-
 include/asm-sh/uaccess_64.h               |   19 -
 include/asm-sh/unistd_32.h                |    6 +-
 include/asm-sh/unistd_64.h                |    6 +-
 include/linux/maple.h                     |  100 ++--
 81 files changed, 3351 insertions(+), 1829 deletions(-)
 create mode 100644 arch/sh/boards/renesas/migor/Makefile
 create mode 100644 arch/sh/boards/renesas/migor/setup.c
 create mode 100644 arch/sh/configs/migor_defconfig
 delete mode 100644 arch/sh/kernel/cpu/irq/maskreg.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/setup-sh7366.c
 create mode 100644 arch/sh/kernel/io_trapped.c
 create mode 100644 include/asm-sh/io_trapped.h
