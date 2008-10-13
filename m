Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYJMIj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYJMIj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYJMIjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:39:20 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:32442 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbYJMIjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:39:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=LoGd0fmn39x/E2YNYoQIcJh/ma8EEy0BndC+hhptAg4jBNA9bmhd0VnYRd4L2ogoR3
         oY6Al6lvGlK3C59+UfHARIaudeLkUVazhjrE+TD4TdPWyzhx9bK2iiXWr8S5wyX05X2R
         y6ywvviICkMvkU8BJWSIBCCZDJA9Io4sYMMcM=
Message-ID: <386072610810130139xab24235vff9ccd4a09e8e962@mail.gmail.com>
Date: Mon, 13 Oct 2008 16:39:17 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Blackfin arch updates for 2.6.28
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 4a3aa7d64b646bed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This git-pull request includes some major updates and bug fixings for
this 2.6.28 merge windows

 - kgdb supports on Blackfin
 - new board bf526 ezbrd support
 - rework double fault handling
 - L2 memory allocator

So please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 Documentation/blackfin/kgdb.txt                    |  155 ---
 arch/blackfin/Kconfig                              |   75 +-
 arch/blackfin/Kconfig.debug                        |   55 +
 arch/blackfin/Makefile                             |    1 +
 arch/blackfin/configs/BF526-EZBRD_defconfig        | 1427 ++++++++++++++++++++
 arch/blackfin/configs/H8606_defconfig              |   36 +-
 arch/blackfin/include/asm/bfin-global.h            |    5 +-
 arch/blackfin/include/asm/bfrom.h                  |   85 ++
 arch/blackfin/include/asm/cacheflush.h             |    2 -
 arch/blackfin/include/asm/cplb.h                   |    8 +-
 arch/blackfin/include/asm/cplbinit.h               |   16 +-
 arch/blackfin/include/asm/cpumask.h                |    6 -
 arch/blackfin/include/asm/dma-mapping.h            |   11 +
 arch/blackfin/include/asm/kgdb.h                   |   21 +-
 arch/blackfin/include/asm/mmu_context.h            |   79 +-
 arch/blackfin/include/asm/processor.h              |    6 +
 arch/blackfin/include/asm/ptrace.h                 |    2 +
 arch/blackfin/include/asm/traps.h                  |    5 +-
 arch/blackfin/kernel/asm-offsets.c                 |    1 +
 arch/blackfin/kernel/bfin_gpio.c                   |    9 +-
 arch/blackfin/kernel/cplb-mpu/cplbinit.c           |   12 +-
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c            |   14 +-
 arch/blackfin/kernel/cplb-nompu/cplbinit.c         |    6 +-
 arch/blackfin/kernel/early_printk.c                |   12 +
 arch/blackfin/kernel/kgdb.c                        |  711 ++++++++---
 arch/blackfin/kernel/ptrace.c                      |  215 ++--
 arch/blackfin/kernel/reboot.c                      |   18 +-
 arch/blackfin/kernel/setup.c                       |   97 +-
 arch/blackfin/kernel/traps.c                       |  367 +++--
 arch/blackfin/mach-bf527/boards/Kconfig            |    5 +
 arch/blackfin/mach-bf527/boards/Makefile           |    1 +
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |   17 +-
 arch/blackfin/mach-bf527/boards/ezbrd.c            |  734 ++++++++++
 arch/blackfin/mach-bf527/boards/ezkit.c            |   53 +-
 arch/blackfin/mach-bf527/head.S                    |    3 +
 arch/blackfin/mach-bf527/include/mach/anomaly.h    |  160 ++-
 arch/blackfin/mach-bf527/include/mach/bf527.h      |   21 +-
 .../mach-bf527/include/mach/defBF52x_base.h        |   27 +
 arch/blackfin/mach-bf527/include/mach/portmux.h    |    4 +
 arch/blackfin/mach-bf533/boards/H8606.c            |   34 +-
 arch/blackfin/mach-bf533/head.S                    |    3 +
 arch/blackfin/mach-bf533/include/mach/anomaly.h    |   49 +-
 arch/blackfin/mach-bf533/include/mach/bf533.h      |   12 +-
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |   85 ++-
 arch/blackfin/mach-bf537/head.S                    |    3 +
 arch/blackfin/mach-bf537/include/mach/anomaly.h    |    2 +
 arch/blackfin/mach-bf537/include/mach/bf537.h      |   12 +-
 arch/blackfin/mach-bf548/boards/cm_bf548.c         |   22 +-
 arch/blackfin/mach-bf548/boards/ezkit.c            |   58 +-
 arch/blackfin/mach-bf548/head.S                    |   52 +-
 arch/blackfin/mach-bf548/include/mach/anomaly.h    |   93 ++-
 arch/blackfin/mach-bf548/include/mach/bf548.h      |   25 +-
 arch/blackfin/mach-bf548/include/mach/mem_map.h    |   14 +-
 arch/blackfin/mach-bf561/head.S                    |    3 +
 arch/blackfin/mach-bf561/include/mach/anomaly.h    |    2 +
 arch/blackfin/mach-bf561/include/mach/bf561.h      |    8 +-
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |    2 +-
 arch/blackfin/mach-bf561/include/mach/mem_map.h    |   18 +-
 arch/blackfin/mach-common/entry.S                  |  219 +++-
 arch/blackfin/mach-common/head.S                   |   52 +-
 arch/blackfin/mach-common/interrupt.S              |   11 +-
 arch/blackfin/mach-common/ints-priority.c          |   25 +-
 arch/blackfin/mm/Makefile                          |    2 +-
 arch/blackfin/mm/isram-driver.c                    |  201 +++
 arch/blackfin/mm/{blackfin_sram.c => sram-alloc.c} |   31 +-
 66 files changed, 4503 insertions(+), 1019 deletions(-)
 delete mode 100644 Documentation/blackfin/kgdb.txt
 create mode 100644 arch/blackfin/configs/BF526-EZBRD_defconfig
 create mode 100644 arch/blackfin/include/asm/bfrom.h
 delete mode 100644 arch/blackfin/include/asm/cpumask.h
 create mode 100644 arch/blackfin/mach-bf527/boards/ezbrd.c
 create mode 100644 arch/blackfin/mm/isram-driver.c
 rename arch/blackfin/mm/{blackfin_sram.c => sram-alloc.c} (96%)

Bernd Schmidt (1):
      Blackfin arch: fixing bug - under IRQ stress, running
applications may wrongly trigger an ICPLB miss and be killed

Bryan Wu (3):
      Blackfin arch: use new platform data interface of musb to replace old one
      Blackfin arch: add dma mapping stub for musb driver port
      Blackfin arch: fix a typo in comments

Graf Yang (7):
      Blackfin arch: add CONFIG_APP_STACKS_L1 to enable or disable
putting kernel stacks in L1
      Blackfin arch: add a meaningful name for each irqchip
      Blackfin arch: Modify some funtion names to more genernal ones
      Blackfin arch: Not call generic set_irq_handler() in
bfin_gpio_irq_type() due to spinlock recursion
      Blackfin arch: fix define error in BF561 memory map macros
      Blackfin arch: correct icache size in show_cpuinfo(), let
c_start() return proper pointer
      Blackfin arch: Remove useless head file

Javier Herrero (1):
      Blackfin arch: flash memory map and dm9000 resources updating

Michael Hennerich (7):
      Blackfin arch: Add new board support for ADZS-BF526-EZ-BRD
      Blackfin arch: add BF54x / BF52x Rotary Input device driver
platform resource to board file
      Blackfin arch: Fix BUG: anomaly_threshold is used with ANOMALY_05000363
      Blackfin arch: Fix BUG -- BF533 + 0.5 silicon + MPU + UART PIO -> crash
      Blackfin arch: Enable framebuffer support for the BF526-EZkit
TFT LCD display
      Blackfin arch: AD7879 Touchscreen driver
      Blackfin arch: Fix bogus str_ident check in gpio code

Mike Frysinger (25):
      Blackfin arch: add note about newer ezkits using PB4 for AD7877
instead of PJ11
      Blackfin arch: only include asm/cplb.h when it is truly used
      Blackfin arch: fix bug - sometimes there is no response to the
hitting key in uboot for bf561-ezkit when running with 50mhz SCLK
      Blackfin arch: mark local gpio_error() as static
      Blackfin arch: fix merge errors during 2.6.26 upgrade
      Blackfin arch: BF561 is supported, no longer a work in progress
      Blackfin arch: fix default silicon rev selection so it works for
all supported parts
      Blackfin arch: add support for BF52x-0.2, BF533-0.6, and BF54x-0.2
      Blackfin arch: fix bug -- PTRACE_PEEKDATA does not seem to work
which breaks umoven() in strace
      Blackfin arch: ptrace - cleanup debug messages and style
      Blackfin arch: use existing ptrace_disable() func to clear
TRACE_BITS and create the opposite ptrace_enable()
      Blackfin arch: ptrace - make sure PT_ORIG_R0 and PT_ORIG_P0
offsets are declared
      Blackfin arch: give sys_strace proper entry markings
      Blackfin arch: avoid using actual config name in comment
      Blackfin arch: fix end address for parallel flash and increase
kernel partition size to 4meg
      Blackfin arch: Move all the silicon rev handling to one place
      Blackfin arch: ptrace - fix off-by-one check on end of memory regions
      Blackfin arch: have is_user_addr_valid() check for overflows
(like when address is -1)
      Blackfin arch: emulate a TTY over the EMUDAT/JTAG interface
      Blackfin arch: update board defconfigs
      Blackfin arch: remove non-bf54x ifdef logic since this file is
only compiled on bf54x parts
      Blackfin arch: bfin_reset() is an internal reboot function ...
everyone should go through machine_restart()
      Blackfin arch: update anomaly headers to match the latest sheet
      Blackfin arch: use the Blackfin on-chip ROM to do software reset
when possible
      Blackfin arch: make sure L2 start and length are always defined
(fixes building on BF542)

Robin Getz (10):
      Blackfin arch: add supporting for double fault debug handling
      Blackfin arch: Better error handling of unknown exceptions
      Blackfin arch: Make sure we protect except 2 properly, and print
out memory properly
      Blackfin arch: rename blackfin_sram.c to sram-alloc.c
      Blackfin arch: Use DTEST rather than DMA to poke at L1 SRAM
during exception context
      Blackfin arch: Make sure we program the correct values in only
when necessary for MUSB driver
      Blackfin arch: Fix bug - HW Errors never recover on BF548
      Blackfin arch: Add optional verbose debug
      Blackfin arch: print out error/warning if you are running on the
incorrect CPU type
      Blackfin arch: make sure we include the fix for SPORT hysteresis
when reprogramming clocks

Sonic Zhang (5):
      Blackfin arch: add supporting for kgdb
      Blackfin arch: Fix bug - kernel build with config kernel
debugging with remote gdb fails
      Blackfin arch: flags of UART3 mem resource is missing
      Blackfin arch: Make L2 SRAM cacheable
      Blackfin arch: early prink code still use uart core console
functions to parse and set configure option string

Vitja Makarov (1):
      Blackfin arch: introducing bfin_addr_dcachable
