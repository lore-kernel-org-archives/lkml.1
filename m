Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbXJKDbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbXJKDbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 23:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbXJKDbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 23:31:36 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:26176 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbXJKDbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 23:31:35 -0400
X-IronPort-AV: i="4.21,256,1188792000"; 
   d="scan'208"; a="41523615:sNHT51191280"
Subject: [GIT PULL] Blackfin updates for 2.6.24
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Thu, 11 Oct 2007 11:31:24 +0800
Message-Id: <1192073484.6206.65.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 11 Oct 2007 03:31:33.0306 (UTC) FILETIME=[386409A0:01C80BB7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

(previous email including the whole patch set is too big for the LKML, then here is the new one)

This set of commits are for Blackfin architecture updates for 2.6.24 merge window,
only thing related with Blackfin arch and some drivers will be sent out later for LKML review

 - Blackfin arch anomaly updates
 - GPIO pinmux updates
 - hardware tracing
 - rewrite reboot code
 - add earlyprintk support
 - bug fixing and code cleanup

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 Documentation/kernel-parameters.txt                |    3 +-
 MAINTAINERS                                        |   26 -
 arch/blackfin/Kconfig                              |  365 +++++++++----
 arch/blackfin/configs/BF533-EZKIT_defconfig        |  243 ++++-----
 arch/blackfin/configs/BF533-STAMP_defconfig        |  280 +++++-----
 arch/blackfin/configs/BF537-STAMP_defconfig        |  296 +++++-----
 arch/blackfin/configs/BF548-EZKIT_defconfig        |  480
+++++++++++------
 arch/blackfin/configs/BF561-EZKIT_defconfig        |  223 +++-----
 arch/blackfin/configs/PNAV-10_defconfig            |  296 +++++-----
 arch/blackfin/kernel/Makefile                      |    5 +-
 arch/blackfin/kernel/bfin_dma_5xx.c                |   81 +++-
 arch/blackfin/kernel/bfin_gpio.c                   |  549
++++++++++++++----
 arch/blackfin/kernel/bfin_ksyms.c                  |    1 +
 arch/blackfin/kernel/cacheinit.c                   |    5 +-
 arch/blackfin/kernel/cplbinit.c                    |    7 +-
 arch/blackfin/kernel/early_printk.c                |  214 +++++++
 arch/blackfin/kernel/irqchip.c                     |   12 +-
 arch/blackfin/kernel/process.c                     |   28 +-
 arch/blackfin/kernel/ptrace.c                      |   24 +-
 arch/blackfin/kernel/reboot.c                      |   78 +++
 arch/blackfin/kernel/setup.c                       |   90 ++--
 arch/blackfin/kernel/traps.c                       |  110 ++++-
 arch/blackfin/kernel/vmlinux.lds.S                 |   48 ++-
 arch/blackfin/lib/memcmp.S                         |    2 +-
 arch/blackfin/lib/memcpy.S                         |    2 +-
 arch/blackfin/lib/memmove.S                        |    4 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c         |   81 +++-
 arch/blackfin/mach-bf533/boards/ezkit.c            |   91 +++-
 arch/blackfin/mach-bf533/boards/stamp.c            |  119 ++++-
 arch/blackfin/mach-bf533/head.S                    |  344 +-----------
 arch/blackfin/mach-bf537/Kconfig                   |   27 -
 arch/blackfin/mach-bf537/boards/cm_bf537.c         |   87 +++-
 arch/blackfin/mach-bf537/boards/generic_board.c    |  397 +++++++++++--
 arch/blackfin/mach-bf537/boards/pnav10.c           |   53 ++-
 arch/blackfin/mach-bf537/boards/stamp.c            |  142 ++++-
 arch/blackfin/mach-bf537/head.S                    |  128 +----
 arch/blackfin/mach-bf548/Kconfig                   |   11 +-
 arch/blackfin/mach-bf548/Makefile                  |    2 +-
 arch/blackfin/mach-bf548/boards/ezkit.c            |  477
++++++++++++++++-
 arch/blackfin/mach-bf548/gpio.c                    |  323 -----------
 arch/blackfin/mach-bf548/head.S                    |  156 +-----
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |   84 +++-
 arch/blackfin/mach-bf561/boards/ezkit.c            |   82 +++-
 arch/blackfin/mach-bf561/head.S                    |  102 +---
 arch/blackfin/mach-common/Makefile                 |    2 +-
 arch/blackfin/mach-common/arch_checks.c            |   60 ++
 arch/blackfin/mach-common/cache.S                  |    8 +-
 arch/blackfin/mach-common/cacheinit.S              |   14 +-
 arch/blackfin/mach-common/cplbhdlr.S               |    8 +-
 arch/blackfin/mach-common/cplbmgr.S                |   56 +-
 arch/blackfin/mach-common/dpmc.S                   |   54 +-
 arch/blackfin/mach-common/entry.S                  |  268 ++++++++--
 arch/blackfin/mach-common/interrupt.S              |   56 +--
 arch/blackfin/mach-common/ints-priority-dc.c       |   13 +-
 arch/blackfin/mach-common/ints-priority-sc.c       |   17 +-
 arch/blackfin/mach-common/lock.S                   |   24 +-
 arch/blackfin/mm/init.c                            |    2 +-
 arch/blackfin/oprofile/op_blackfin.h               |    8 +-
 drivers/serial/bfin_5xx.c                          |  222 +++++---
 include/asm-blackfin/bfin5xx_spi.h                 |    2 -
 include/asm-blackfin/blackfin.h                    |  112 ++---
 include/asm-blackfin/cacheflush.h                  |   14 +-
 include/asm-blackfin/cplb.h                        |   99 +++-
 include/asm-blackfin/dma.h                         |    2 +
 include/asm-blackfin/early_printk.h                |   28 +
 include/asm-blackfin/gpio.h                        |   31 +
 include/asm-blackfin/io.h                          |   24 +-
 include/asm-blackfin/ioctls.h                      |    9 +-
 include/asm-blackfin/irq_handler.h                 |   15 +-
 include/asm-blackfin/kgdb.h                        |    1 +
 include/asm-blackfin/mach-bf527/anomaly.h          |   41 ++
 include/asm-blackfin/mach-bf527/defBF52x_base.h    |    2 +
 include/asm-blackfin/mach-bf533/anomaly.h          |  468
++++++++--------
 include/asm-blackfin/mach-bf533/bf533.h            |  157 +-----
 include/asm-blackfin/mach-bf533/blackfin.h         |    2 +-
 include/asm-blackfin/mach-bf533/cdefBF532.h        |   62 ++-
 include/asm-blackfin/mach-bf533/defBF532.h         |    3 +-
 include/asm-blackfin/mach-bf533/irq.h              |    2 +
 include/asm-blackfin/mach-bf533/mem_map.h          |   56 +-
 include/asm-blackfin/mach-bf537/anomaly.h          |  249 +++++----
 include/asm-blackfin/mach-bf537/bf537.h            |  158 +-----
 include/asm-blackfin/mach-bf537/blackfin.h         |  280 +---------
 include/asm-blackfin/mach-bf537/cdefBF534.h        |    4 +-
 include/asm-blackfin/mach-bf537/defBF534.h         |    4 +-
 include/asm-blackfin/mach-bf537/irq.h              |    2 +
 include/asm-blackfin/mach-bf537/mem_map.h          |   60 +-
 include/asm-blackfin/mach-bf537/portmux.h          |    2 +-
 include/asm-blackfin/mach-bf548/anomaly.h          |  145 +++---
 include/asm-blackfin/mach-bf548/bf548.h            |  154 +-----
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h  |   39 +-
 include/asm-blackfin/mach-bf548/blackfin.h         |    2 +-
 include/asm-blackfin/mach-bf548/cdefBF54x_base.h   |    4 +-
 include/asm-blackfin/mach-bf548/defBF544.h         |    1 +
 include/asm-blackfin/mach-bf548/defBF548.h         |    2 +
 include/asm-blackfin/mach-bf548/defBF549.h         |    2 +
 include/asm-blackfin/mach-bf548/defBF54x_base.h    |    3 +
 include/asm-blackfin/mach-bf548/gpio.h             |    5 -
 include/asm-blackfin/mach-bf548/irq.h              |  591
++++++++++----------
 include/asm-blackfin/mach-bf548/mem_map.h          |   24 +-
 include/asm-blackfin/mach-bf561/anomaly.h          |  410
++++++++------
 include/asm-blackfin/mach-bf561/bf561.h            |  178 +------
 include/asm-blackfin/mach-bf561/blackfin.h         |    2 +-
 include/asm-blackfin/mach-bf561/cdefBF561.h        |    9 +-
 include/asm-blackfin/mach-bf561/defBF561.h         |    1 +
 include/asm-blackfin/mach-bf561/irq.h              |    2 +
 include/asm-blackfin/mach-bf561/mem_map.h          |   24 +-
 include/asm-blackfin/mach-bf561/portmux.h          |    2 +-
 include/asm-blackfin/mach-common/cdef_LPBlackfin.h |    4 +-
 include/asm-blackfin/mach-common/clocks.h          |   70 +++
 include/asm-blackfin/mach-common/def_LPBlackfin.h  |  135 +++---
 include/asm-blackfin/pgtable.h                     |    2 +-
 include/asm-blackfin/reboot.h                      |   20 +
 include/asm-blackfin/system.h                      |   93 ++--
 include/asm-blackfin/termbits.h                    |    5 +-
 include/asm-blackfin/termios.h                     |   10 +-
 include/asm-blackfin/trace.h                       |   55 ++-
 116 files changed, 6069 insertions(+), 4804 deletions(-)
 create mode 100644 arch/blackfin/kernel/early_printk.c
 create mode 100644 arch/blackfin/kernel/reboot.c
 delete mode 100644 arch/blackfin/mach-bf548/gpio.c
 create mode 100644 arch/blackfin/mach-common/arch_checks.c
 create mode 100644 include/asm-blackfin/early_printk.h
 create mode 100644 include/asm-blackfin/mach-bf527/anomaly.h
 create mode 100644 include/asm-blackfin/mach-common/clocks.h
 create mode 100644 include/asm-blackfin/reboot.h

Alan Cox (1):
      blackfin enable arbitary speed serial setting

Bernd Schmidt (2):
      Blackfin arch: Export strcpy - occasionally get module link
failures otherwise
      Blackfin arch: fix bug libstdc++ calling writev with an iovec
containing { NULL, 0 } fails on Blackfin

Bryan Wu (8):
      Blackfin arch: update platform driver resource information to all
board files
      Blackfin arch: bug fixing, add missing BF533_FAMILY GPIO_PFx
definition
      Blackfin arch: fix bugs report by Andy Liu <yjhsou@gmail.com>,
AD1836 can't be probed in BF561-EZ
      Blackfin arch: kill ezkit548 compiling warning
      Blackfin arch: Board defconfig updating
      Blackfin arch: cleanup IO and DMA_IO API function definitions
according to other arches
      Blackfin arch: modify the insX/outsX and dma_insX/dma_outsX to be
compatible with other archs
      Blackfin arch: add TWIx_REGBASE and SPIx_REGBASE to specific CPU
header files, use the new REGBASE for board platform resources

Jie Zhang (1):
      Blackfin arch: Allow ptrace access the fixed code.

Michael Hennerich (21):
      Blackfin arch: Finalize the generic gpio support - add gpio_to_irq
and irq_to_gpio
      Blackfin arch: Advertise GENERIC_GPIO and remove duplicated
GENERIC_CALIBRATE_DELAY
      Blackfin arch: store labels so we later know who allocated
GPIO/Peripheral resources
      Blackfin arch: Add label to call new GPIO API
      Blackfin arch: Add PORT_J.High (needed for BF548-EZkit Touchscreen
interrupts) - remove PORT_C.H
      Blackfin arch: Fix define - SPORT0_DTPRI is first function
      Blackfin arch: add missing gpio error handling to make sure we
roll back requests in case one fails
      Blackfin arch: Some cosmetics based on LKML feedback from Joe
Perches
      Blackfin serial driver: use new GPIO API
      Blackfin arch: Add support for the M25P16 SPI FLash
      Blackfin arch: Add option to priorize DMA over Core
      Blackfin arch: bug fixing restore mach dependent ASYNC memory size
      Blackfin arch: extract gpio number from PIN function
      Blackfin arch: Merge GPIO/Peripheral Resource Allocation back into
a single file
      Blackfin arch: For compatibility reasons change IRQ_XXX_ERR into
IRQ_XXX_ERROR like on any other supported Blackfin derivative
      Blackfin arch: a few things still use bfin_read_PORT_FER()
      Blackfin arch: Remove legacy support
      Blackfin arch: Add ANOMALY_05000311 Workaround - for those who
doesnt use the generic GPIO driver
      Blackfin arch: Workaround reboot bug, issue SSYNC at the start of
bfin_reset
      Blackfin arch: Comply with revised Anomaly Workarounds for BF533
05000311 and BF561 05000323
      Blackfin arch: flush/inv the correct range when using write back
cache and fix bugs find by dmacopy

Mike Frysinger (24):
      Blackfin arch: cleanup and standardize anomaly.h file format -- no
functional changes
      Blackfin arch: revise anomaly handling by basing things on the
compiler not the kconfig defines
      Blackfin arch: update BF54x anomaly list
      Blackfin arch: use the [CS]SYNC() macros which include anomaly
workarounds rather than __builtin_bfin_[cs]sync()
      Blackfin arch: reorganize headers slightly so we can be sure
things are defined early enough
      Blackfin arch: use HI/LO macros rather than masking the bit ranges
ourselves
      Blackfin arch: fix typo... we want csync in CSYNC(), not ssync
      Blackfin arch: update to latest anomaly sheets
      Blackfin arch: scrub remaining ASSEMBLY usage since the switch to
__ASSEMBLY__
      Blackfin arch: remove unused code -- EVT0 is not controllable by
software
      Blackfin arch: remove spurious KERN_EMERG log level in output
      Blackfin arch: update BOOT_LOAD
      Blackfin arch: make sure to stub out ANOMALY_05000230 were
appropriate
      Blackfin arch: allow people to select the feature that is
unavailable to the kernel
      Blackfin arch: all our other ports call this SIZE rather than
SPI_LEN
      Blackfin arch: add an exception request/free api
      Blackfin arch: parse input sections properly when using
-ffunction-sections/-fdata-sections
      Blackfin arch: vmlinux.lds.S, break up our .init into separate
sections
      Blackfin arch: rewrite our reboot code in C
      Blackfin arch: fix typo pointed out by David Rowe (Mhz -> MHz)
      Blackfin arch: add more common defines for output sections
      Blackfin arch: trim the Blackfin arch MAINTAINERS list
      Blackfin arch: fix typo in register name
      Blackfin serial driver: pending a unique anomaly id, tie the break
flood issue to ANOMALY_05000230

Robin Getz (14):
      Blackfin arch: Fix Anomaly hanlding, as pointed out by Mike
      Blackfin arch: Fix CCLK and SCLK checks
      Blackfin arch: Add ability to expend the hardware trace buffer
      Blackfin arch: to do some consolidation of common code and common
name spaces
      Blackfin arch: fix up header for BF533
      Blackfin arch: Fix bug missing L2_MEMORY definition for
EZKIT-BF561 compiling error
      Blackfin arch: Remove cruft - CONFIG_DEBUG_SERIAL_EARLY_INIT
didn't work that well with DEBUG_KERNEL_START
      Blackfin arch: Initial patch to add earlyprintk support
      Blackfin arch: fix endless loop bug when a double fault happens
      Blackfin arch: Enable earlyprintk earlier - so any error after our
interrupt tables are set up will print out
      Blackfin arch: Print out debug info, as early as possible
      Blackfin arch: show_mem can not be marked as init, since it is
called during OOM condition
      Blackfin arch: the load address is not safe to point to as a
workaround for ANOMALY 05000281
      Blackfin arch: Remove cruft - CONFIG_DEBUG_SERIAL_EARLY_INIT and
DEBUG_KERNEL_START

Roy Huang (1):
      Blackfin arch: add set_dma_curr_addr DMA API to support sound
driver recording function

Sonic Zhang (2):
      Blackfin arch: Add DMA API to set curr descriptor address
      Blackfin arch: update kgdb patch
