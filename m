Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZCRLFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZCRLFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZCRLE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:04:59 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58414 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbZCRLE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:04:57 -0400
Date: Wed, 18 Mar 2009 20:00:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: What's in sh-2.6.git for 2.6.30?
Message-ID: <20090318110043.GB7391@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a summary of the stuff in the queue for 2.6.30.

Primary features of note in no sort of coherent order:

	- SH-Mobile power management
	- swsusp / suspend to disk / hibernation
	- kexec jump
	- New CPU support (SH7786, UP only for now)
	- New board support (Urquell, ESPT-Giga)
	- New drivers (CMT clockevents, VMU MTD, etc).
	- New PMB mode for inheriting existing static mappings.
	- Shared vectors mapped to shared IRQs.
	- DMA updates for newer SH-4A parts.
	- Support for exended 16-bit ASIDs on 65nm SH7786.
	- Ranged TLB flushing optimizations.

As usual, the tree is at:

	git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git

and contains:

Adrian McMenamin (2):
      sh: maple: Support block reads and writes.
      mtd: flash mapping support for Dreamcast VMU.

Francesco VIRLINZI (4):
      sh: clkfwk: add clk_set_parent/clk_get_parent
      sh: clkfwk: Add resume from hibernation support.
      sh: PMB hibernation support
      sh: clkfwk: Safer resume from hibernation.

Kay Sievers (1):
      sh: struct device - replace bus_id with dev_name(), dev_set_name()

Kuninori Morimoto (4):
      sh: Add support for SH7786 CPU subtype.
      sh: Urquell board support.
      sh: urquell: Add smc91x support and update defconfig accordingly.
      sh: Add OHCI USB support for SH7786

Magnus Damm (32):
      sh: make gpio_get/set_value() O(1)
      sh: lockless gpio_get_value()
      sh: lockless gpio_set_value()
      sh: use gpiolib
      sh: rework clocksource and sched_clock
      sh: tmu disable support
      sh: fix no sys_timer case
      sh: CMT clockevent platform driver
      sh: CMT platform data for sh7723/sh7722/sh7366/sh7343
      sh: shared register saving code for sh3/sh4/sh4a
      sh: rework register restore code for sh3/sh4/sh4a
      sh: remove EXPEVT vector from stack on sh3/sh4/sh4a
      sh: prefetch early exception data on sh4/sh4a.
      serial: sh-sci: console drainage
      rtc: sh-rtc: Add Single IRQ Support
      sh: fix P4 iounmap() pass-through
      sh: multiple vectors per irq - base
      sh: multiple vectors per irq - sh7750
      sh: multiple vectors per irq - sh7780
      sh: multiple vectors per irq - sh7785
      sh: hibernation support
      video: deferred io cleanup fix for sh_mobile_lcdcfb
      sh: Show sleep state with Migo-R LEDs
      input: add suspend wakeup support to sh_keysc
      input: sh_keysc suspend can use to_platform_device()
      sh: improve sh7785lcr power off code
      sh: SuperH Mobile suspend support
      sh: add ap325 lcd power off support
      video: sh_mobile_lcdcfb suspend/resume support
      sh: simplify kexec vbr code
      sh: rework kexec segment code
      sh: add kexec jump support

Matt Fleming (2):
      sh: Relax inline assembly constraints
      sh: Use the atomic_t "counter" member

Nobuhiro Iwamatsu (10):
      sh: multiple vectors per irq - sh7763
      sh: Restore RTC IRQ setting for SH7763 setup.
      sh: Add media/soc_camera.h to board setup of Renesas AP325RXA
      sh: dma-sh updates for multi IRQ and new SH-4A CPUs.
      sh: Revert CONFIG_NR_ONCHIP_DMA_CHANNELS to MAX_DMA_CHANNELS
      sh: Disable get_dma_error_irq for non-SH4 targets.
      sh: Fix compile error by operands(mov.l) in sh3/entry.S
      sh: Move IRQ multi definition of DMAC to defconfig
      sh: espt-giga board support
      sh: sh7763rdp: Change IRQ number for sh_eth of sh7763rdp

Paul Mundt (33):
      sh: Fix up GENERIC_GPIO build for ARCH_WANT_OPTIONAL_GPIO cases.
      sh: mach-highlander and mach-rsk require gpiolib.
      sh: Use SYS_SUPPORTS_CMT for managing CMT timer dependencies.
      sh: Fix up MTU2 support for SH7203.
      sh: Don't enable GENERIC_TIME for the CMT clockevent driver yet.
      sh: Restrict old CMT timer code to SH-2/SH-2A.
      sh: Disable unsupportable prefetching on SH-3.
      sh: Fix up SH-X3 general exception handler build.
      sh: SH7786 is an SH-X3 core, select CPU_SHX3.
      sh: Set a sensible default for the SH7786 pclk.
      sh: intc: Make missing unique IRQ mask warning more verbose.
      sh: multiple vectors per irq - sh7203.
      sh: multiple vectors per irq - sh7263.
      sh: multiple vectors per irq - sh7201.
      sh: multiple vectors per irq - sh7206.
      rtc: rtc-sh: Bump version up to reflect single IRQ support changes.
      sh: multiple vectors per irq - sh7619.
      sh: multiple vectors per irq - mxg.
      sh: multiple vectors per irq - sh770x.
      sh: multiple vectors per irq - sh7705.
      sh: multiple vectors per irq - sh7710.
      sh: multiple vectors per irq - sh7720.
      sh: Define ARCH_SHMOBILE for SH-Mobile CPUs.
      sh: Generate uImage by default on Urquell board.
      sh: Consolidate SH-Mobile CPU code in arch/sh/kernel/cpu/shmobile/.
      sh: dma: Make PVR2 DMA configurable.
      sh: dma: Make G2 DMA configurable.
      sh: Support for extended ASIDs on PTEAEX-capable SH-X3 cores.
      sh: tlb-pteaex: Kill off legacy PTEA updates.
      sh: Update debugfs ASID dumping for 16-bit ASID support.
      sh: Flush only the needed range when unmapping a VMA.
      sh: kexec: Drop SR.BL bit toggling.
      sh: kexec jump: fix for ftrace.

Roel Kluin (1):
      SH: fix start_thread and user_stack_pointer macros

Yoshihiro Shimoda (3):
      sh: Support fixed 32-bit PMB mappings from bootloader.
      sh: sh7785lcr: Updates for fixed PMB.
      sh: pci-sh7780: fix pci memory address for fixed PMB

 arch/sh/Kconfig                            |   63 +-
 arch/sh/Kconfig.cpu                        |    3 +
 arch/sh/Makefile                           |    1 +
 arch/sh/boards/Kconfig                     |   20 +-
 arch/sh/boards/Makefile                    |    2 +
 arch/sh/boards/board-ap325rxa.c            |   12 +
 arch/sh/boards/board-espt.c                |  102 ++
 arch/sh/boards/board-sh7785lcr.c           |   13 +-
 arch/sh/boards/board-urquell.c             |  162 +++
 arch/sh/boards/mach-highlander/Kconfig     |    2 +-
 arch/sh/boards/mach-hp6xx/pm_wakeup.S      |   31 +-
 arch/sh/boards/mach-migor/setup.c          |    9 +
 arch/sh/boards/mach-rsk/Kconfig            |    2 +-
 arch/sh/boards/mach-sh7763rdp/setup.c      |   10 +-
 arch/sh/boot/Makefile                      |   20 +-
 arch/sh/configs/espt_defconfig             | 1190 +++++++++++++++++++++
 arch/sh/configs/sh7785lcr_32bit_defconfig  | 1553 ++++++++++++++++++++++++++++
 arch/sh/configs/urquell_defconfig          | 1332 ++++++++++++++++++++++++
 arch/sh/drivers/dma/Kconfig                |   40 +-
 arch/sh/drivers/dma/Makefile               |    3 +-
 arch/sh/drivers/dma/dma-sh.c               |  169 ++-
 arch/sh/drivers/dma/dma-sh.h               |   75 --
 arch/sh/drivers/pci/pci-sh7780.c           |    4 +-
 arch/sh/include/asm/addrspace.h            |    4 +-
 arch/sh/include/asm/atomic-irq.h           |   16 +-
 arch/sh/include/asm/bitops-llsc.h          |   72 +-
 arch/sh/include/asm/clock.h                |    1 +
 arch/sh/include/asm/cmpxchg-llsc.h         |   38 +-
 arch/sh/include/asm/cpu-features.h         |    1 +
 arch/sh/include/asm/dma-sh.h               |  118 +++
 arch/sh/include/asm/dma.h                  |    4 +-
 arch/sh/include/asm/entry-macros.S         |    5 +
 arch/sh/include/asm/gpio.h                 |   70 +-
 arch/sh/include/asm/io.h                   |    4 +-
 arch/sh/include/asm/kprobes.h              |    2 +-
 arch/sh/include/asm/mmu_context.h          |   15 +-
 arch/sh/include/asm/mmu_context_32.h       |   12 +
 arch/sh/include/asm/page.h                 |    7 +-
 arch/sh/include/asm/processor.h            |    2 +-
 arch/sh/include/asm/processor_32.h         |   15 +-
 arch/sh/include/asm/processor_64.h         |   14 +-
 arch/sh/include/asm/ptrace.h               |    8 +-
 arch/sh/include/asm/sections.h             |    1 +
 arch/sh/include/asm/suspend.h              |   22 +
 arch/sh/include/asm/timer.h                |    4 +-
 arch/sh/include/asm/tlb.h                  |  100 ++-
 arch/sh/include/cpu-sh3/cpu/dma.h          |   17 +-
 arch/sh/include/cpu-sh4/cpu/dma-sh4a.h     |   94 ++
 arch/sh/include/cpu-sh4/cpu/dma-sh7780.h   |   39 -
 arch/sh/include/cpu-sh4/cpu/dma.h          |   30 +-
 arch/sh/include/cpu-sh4/cpu/freq.h         |    4 +
 arch/sh/include/cpu-sh4/cpu/mmu_context.h  |   35 +-
 arch/sh/include/cpu-sh4/cpu/sh7786.h       |  192 ++++
 arch/sh/include/mach-common/mach/urquell.h |   68 ++
 arch/sh/kernel/Makefile_32                 |    1 +
 arch/sh/kernel/asm-offsets.c               |    8 +
 arch/sh/kernel/cpu/Makefile                |    1 +
 arch/sh/kernel/cpu/clock.c                 |   95 ++
 arch/sh/kernel/cpu/sh2/setup-sh7619.c      |   34 +-
 arch/sh/kernel/cpu/sh2a/setup-mxg.c        |   65 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7201.c     |  224 ++---
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c     |  236 ++---
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c     |  154 +--
 arch/sh/kernel/cpu/sh3/Makefile            |    2 +
 arch/sh/kernel/cpu/sh3/entry.S             |  357 ++++---
 arch/sh/kernel/cpu/sh3/setup-sh7705.c      |   61 +-
 arch/sh/kernel/cpu/sh3/setup-sh770x.c      |   68 +-
 arch/sh/kernel/cpu/sh3/setup-sh7710.c      |   69 +-
 arch/sh/kernel/cpu/sh3/setup-sh7720.c      |   68 +-
 arch/sh/kernel/cpu/sh3/swsusp.S            |  147 +++
 arch/sh/kernel/cpu/sh4/Makefile            |    1 +
 arch/sh/kernel/cpu/sh4/probe.c             |    7 +
 arch/sh/kernel/cpu/sh4/setup-sh7750.c      |   87 +--
 arch/sh/kernel/cpu/sh4a/Makefile           |    3 +
 arch/sh/kernel/cpu/sh4a/clock-sh7786.c     |  148 +++
 arch/sh/kernel/cpu/sh4a/pinmux-sh7786.c    |  950 +++++++++++++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c     |   34 +
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c     |   34 +
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c     |   34 +
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c     |   34 +
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c     |  114 +--
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c     |   97 +--
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c     |   95 +--
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c     |  490 +++++++++
 arch/sh/kernel/cpu/shmobile/Makefile       |    6 +
 arch/sh/kernel/cpu/shmobile/pm.c           |   92 ++
 arch/sh/kernel/cpu/shmobile/sleep.S        |  125 +++
 arch/sh/kernel/gpio.c                      |  338 ++++---
 arch/sh/kernel/irq.c                       |    2 +-
 arch/sh/kernel/machine_kexec.c             |   67 +-
 arch/sh/kernel/relocate_kernel.S           |  203 +++-
 arch/sh/kernel/setup.c                     |    3 +-
 arch/sh/kernel/swsusp.c                    |   38 +
 arch/sh/kernel/time_32.c                   |   71 +-
 arch/sh/kernel/timers/timer-mtu2.c         |    3 +-
 arch/sh/kernel/timers/timer-tmu.c          |   21 +-
 arch/sh/kernel/vmlinux_32.lds.S            |    5 +-
 arch/sh/mm/Kconfig                         |   29 +-
 arch/sh/mm/Makefile_32                     |    7 +-
 arch/sh/mm/asids-debugfs.c                 |    4 +-
 arch/sh/mm/ioremap_32.c                    |    8 +-
 arch/sh/mm/pmb-fixed.c                     |   45 +
 arch/sh/mm/pmb.c                           |   38 +
 arch/sh/mm/tlb-pteaex.c                    |   96 ++
 arch/sh/oprofile/common.c                  |    1 +
 arch/sh/tools/mach-types                   |    2 +
 drivers/clocksource/Makefile               |    1 +
 drivers/clocksource/sh_cmt.c               |  615 +++++++++++
 drivers/input/joystick/maplecontrol.c      |    4 +-
 drivers/input/keyboard/maple_keyb.c        |   37 +-
 drivers/input/keyboard/sh_keysc.c          |   26 +-
 drivers/mtd/maps/Kconfig                   |   12 +-
 drivers/mtd/maps/Makefile                  |    1 +
 drivers/mtd/maps/vmu-flash.c               |  832 +++++++++++++++
 drivers/rtc/rtc-sh.c                       |  192 +++--
 drivers/serial/sh-sci.c                    |   12 +-
 drivers/serial/sh-sci.h                    |   15 +-
 drivers/sh/intc.c                          |   47 +
 drivers/sh/maple/maple.c                   |  472 +++++-----
 drivers/sh/superhyway/superhyway.c         |    4 +-
 drivers/usb/Kconfig                        |    1 +
 drivers/usb/host/ohci-hcd.c                |    3 +-
 drivers/video/pvr2fb.c                     |   16 +-
 drivers/video/sh_mobile_lcdcfb.c           |   70 ++-
 include/linux/maple.h                      |   62 +-
 include/linux/sh_cmt.h                     |   13 +
 include/linux/sh_intc.h                    |    1 +
 sound/sh/Kconfig                           |    1 +
 128 files changed, 11085 insertions(+), 2106 deletions(-)
 create mode 100644 arch/sh/boards/board-espt.c
 create mode 100644 arch/sh/boards/board-urquell.c
 create mode 100644 arch/sh/configs/espt_defconfig
 create mode 100644 arch/sh/configs/sh7785lcr_32bit_defconfig
 create mode 100644 arch/sh/configs/urquell_defconfig
 delete mode 100644 arch/sh/drivers/dma/dma-sh.h
 create mode 100644 arch/sh/include/asm/dma-sh.h
 create mode 100644 arch/sh/include/asm/suspend.h
 create mode 100644 arch/sh/include/cpu-sh4/cpu/dma-sh4a.h
 delete mode 100644 arch/sh/include/cpu-sh4/cpu/dma-sh7780.h
 create mode 100644 arch/sh/include/cpu-sh4/cpu/sh7786.h
 create mode 100644 arch/sh/include/mach-common/mach/urquell.h
 create mode 100644 arch/sh/kernel/cpu/sh3/swsusp.S
 create mode 100644 arch/sh/kernel/cpu/sh4a/clock-sh7786.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/pinmux-sh7786.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/setup-sh7786.c
 create mode 100644 arch/sh/kernel/cpu/shmobile/Makefile
 create mode 100644 arch/sh/kernel/cpu/shmobile/pm.c
 create mode 100644 arch/sh/kernel/cpu/shmobile/sleep.S
 create mode 100644 arch/sh/kernel/swsusp.c
 create mode 100644 arch/sh/mm/pmb-fixed.c
 create mode 100644 arch/sh/mm/tlb-pteaex.c
 create mode 100644 drivers/clocksource/sh_cmt.c
 create mode 100644 drivers/mtd/maps/vmu-flash.c
 create mode 100644 include/linux/sh_cmt.h
