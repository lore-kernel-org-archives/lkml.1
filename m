Return-Path: <linux-kernel-owner+w=401wt.eu-S1760408AbYA0Mlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbYA0Mlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758848AbYA0Mk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:40:27 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:64363 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760047AbYA0MkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:40:23 -0500
X-IronPort-AV: E=Sophos;i="4.25,256,1199682000"; 
   d="scan'208";a="60998320"
Subject: [GIT PATCH] Blackfin arch updates for 2.6.25
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Sun, 27 Jan 2008 20:39:22 +0800
Message-Id: <1201437562.17932.7.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 27 Jan 2008 12:40:21.0564 (UTC) FILETIME=[C7C677C0:01C860E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:
 - Some new boards BSP added
 - Initial add CPLB MPU with original CPLB NOMPU code.
 - Bug fixing

 MAINTAINERS                                        |    6 +-
 arch/blackfin/Kconfig                              |  131 +++-----
 arch/blackfin/Makefile                             |   12 +
 arch/blackfin/configs/BF527-EZKIT_defconfig        |   17 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig        |   17 +-
 arch/blackfin/configs/BF533-STAMP_defconfig        |   39 +--
 arch/blackfin/configs/BF537-STAMP_defconfig        |   50 ++--
 arch/blackfin/configs/BF548-EZKIT_defconfig        |   90 ++++--
 arch/blackfin/configs/BF561-EZKIT_defconfig        |   32 +-
 arch/blackfin/kernel/Makefile                      |    2 +-
 arch/blackfin/kernel/bfin_dma_5xx.c                |    4 +-
 arch/blackfin/kernel/bfin_gpio.c                   |  171 +++++++----
 arch/blackfin/kernel/cplb-mpu/Makefile             |    8 +
 arch/blackfin/kernel/{ => cplb-mpu}/cacheinit.c    |   23 +-
 arch/blackfin/kernel/cplb-mpu/cplbinfo.c           |  144 +++++++++
 arch/blackfin/kernel/cplb-mpu/cplbinit.c           |   91 ++++++
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c            |  338 ++++++++++++++++++++
 arch/blackfin/kernel/cplb-nompu/Makefile           |    8 +
 arch/blackfin/kernel/{ => cplb-nompu}/cacheinit.c  |    2 +
 .../{mach-common => kernel/cplb-nompu}/cplbhdlr.S  |    0 
 .../{mach-common => kernel/cplb-nompu}/cplbinfo.c  |    0 
 arch/blackfin/kernel/{ => cplb-nompu}/cplbinit.c   |    0 
 .../{mach-common => kernel/cplb-nompu}/cplbmgr.S   |   37 ++-
 arch/blackfin/kernel/early_printk.c                |    4 +-
 arch/blackfin/kernel/process.c                     |   32 +--
 arch/blackfin/kernel/reboot.c                      |   13 +-
 arch/blackfin/kernel/setup.c                       |   13 +-
 arch/blackfin/kernel/time.c                        |   70 ----
 arch/blackfin/kernel/traps.c                       |  212 +++++++++----
 arch/blackfin/lib/memcpy.S                         |    8 +-
 arch/blackfin/mach-bf527/Kconfig                   |    2 +-
 arch/blackfin/mach-bf527/boards/ezkit.c            |  107 ++++++-
 arch/blackfin/mach-bf533/boards/H8606.c            |   83 +++++-
 arch/blackfin/mach-bf533/boards/ezkit.c            |   52 +++
 arch/blackfin/mach-bf533/boards/stamp.c            |  103 ++++++-
 arch/blackfin/mach-bf537/boards/Kconfig            |    6 +
 arch/blackfin/mach-bf537/boards/Makefile           |    1 +
 arch/blackfin/mach-bf537/boards/cm_bf537.c         |   11 +
 arch/blackfin/mach-bf537/boards/generic_board.c    |   11 +-
 arch/blackfin/mach-bf537/boards/minotaur.c         |  317 ++++++++++++++++++
 arch/blackfin/mach-bf537/boards/pnav10.c           |    9 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |   80 +++++-
 arch/blackfin/mach-bf548/Kconfig                   |    2 +-
 arch/blackfin/mach-bf548/boards/ezkit.c            |   96 ++++--
 arch/blackfin/mach-bf548/head.S                    |   55 +++-
 arch/blackfin/mach-bf548/ints-priority.c           |    4 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |   11 +
 arch/blackfin/mach-bf561/boards/ezkit.c            |   96 ++++++
 arch/blackfin/mach-bf561/coreb.c                   |   12 +-
 arch/blackfin/mach-common/Makefile                 |    3 +-
 arch/blackfin/mach-common/dpmc.S                   |   74 +++--
 arch/blackfin/mach-common/entry.S                  |   26 ++-
 arch/blackfin/mach-common/interrupt.S              |   48 ++-
 arch/blackfin/mach-common/ints-priority-dc.c       |   10 +-
 arch/blackfin/mach-common/ints-priority-sc.c       |   84 ++++--
 arch/blackfin/mach-common/irqpanic.c               |   50 ---
 arch/blackfin/mach-common/pm.c                     |   16 +
 arch/blackfin/mm/init.c                            |   33 ++-
 drivers/serial/bfin_5xx.c                          |    6 +-
 drivers/video/bf54x-lq043fb.c                      |    6 +-
 include/asm-blackfin/bfin-global.h                 |    2 +-
 include/asm-blackfin/cplb-mpu.h                    |   61 ++++
 include/asm-blackfin/cplb.h                        |    4 +
 include/asm-blackfin/cplbinit.h                    |    8 +
 include/asm-blackfin/dma.h                         |    6 +-
 include/asm-blackfin/gpio.h                        |   84 +++---
 include/asm-blackfin/mach-bf527/bfin_serial_5xx.h  |    2 +-
 include/asm-blackfin/mach-bf527/portmux.h          |    2 +
 include/asm-blackfin/mach-bf533/anomaly.h          |   12 +-
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h  |    2 +-
 include/asm-blackfin/mach-bf533/portmux.h          |    2 +
 include/asm-blackfin/mach-bf537/anomaly.h          |   14 +-
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h  |    2 +-
 include/asm-blackfin/mach-bf537/portmux.h          |    2 +
 include/asm-blackfin/mach-bf548/anomaly.h          |   54 ++--
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h  |    2 +-
 include/asm-blackfin/mach-bf548/cdefBF54x_base.h   |   33 --
 include/asm-blackfin/mach-bf548/defBF542.h         |    4 +-
 include/asm-blackfin/mach-bf548/defBF548.h         |    4 +-
 include/asm-blackfin/mach-bf548/defBF54x_base.h    |   31 ++-
 include/asm-blackfin/mach-bf548/irq.h              |    4 +-
 include/asm-blackfin/mach-bf548/mem_init.h         |   62 ++++-
 include/asm-blackfin/mach-bf548/portmux.h          |    2 +
 include/asm-blackfin/mach-bf561/anomaly.h          |   18 +-
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h  |    2 +-
 include/asm-blackfin/mach-bf561/portmux.h          |    2 +
 include/asm-blackfin/mmu.h                         |    4 +-
 include/asm-blackfin/mmu_context.h                 |   62 ++++-
 include/asm-blackfin/traps.h                       |    4 +
 include/asm-blackfin/uaccess.h                     |    2 +-
 include/asm-blackfin/unistd.h                      |    3 +-
 91 files changed, 2710 insertions(+), 774 deletions(-)
 create mode 100644 arch/blackfin/kernel/cplb-mpu/Makefile
 copy arch/blackfin/kernel/{ => cplb-mpu}/cacheinit.c (75%)
 create mode 100644 arch/blackfin/kernel/cplb-mpu/cplbinfo.c
 create mode 100644 arch/blackfin/kernel/cplb-mpu/cplbinit.c
 create mode 100644 arch/blackfin/kernel/cplb-mpu/cplbmgr.c
 create mode 100644 arch/blackfin/kernel/cplb-nompu/Makefile
 rename arch/blackfin/kernel/{ => cplb-nompu}/cacheinit.c (98%)
 rename arch/blackfin/{mach-common => kernel/cplb-nompu}/cplbhdlr.S (100%)
 rename arch/blackfin/{mach-common => kernel/cplb-nompu}/cplbinfo.c (100%)
 rename arch/blackfin/kernel/{ => cplb-nompu}/cplbinit.c (100%)
 rename arch/blackfin/{mach-common => kernel/cplb-nompu}/cplbmgr.S (93%)
 create mode 100644 arch/blackfin/mach-bf537/boards/minotaur.c
 create mode 100644 include/asm-blackfin/cplb-mpu.h

Bernd Schmidt (4):
      [Blackfin] arch: fix up coding style in uaccess.h
      [Blackfin] arch: move all code related to CPLB handling into a new subdirectory under kernel/
      [Blackfin] arch: Initial checkin of the memory protection support.
      [Blackfin] arch: Add the semtimedop syscall.  Upstream uClibc doesn't compile without it.

Bryan Wu (4):
      [Blackfin] arch: update defconfig of boards
      [Blackfin] arch: Fix if/def BUG - and define is multipoint NO
      [Blackfin] arch: enable generic GPIO based I2C driver in STAMP-BF533, EZKIT-BF533 and EZKIT-BF561 boards
      [Blackfin] arch: remove old I2C BF54x porting.

Cliff Cai (2):
      [Blackfin] arch: fix bug SDIO driver fails to build for BF542/BF548
      [Blackfin] arch: set default value of DEB_DMA_URGENT to YES to avoid DMA aborting caused by conflict between core and DMA

Enrik Berkhan (1):
      [Blackfin] arch: fix bug when DMA operation related core B of BF561

Javier Herrero (2):
      [Blackfin] arch: Added support for 8250-class UARTs in HV Sistemas H8606 board, modification in 8250.c driver for correct compilation with Blackfin
      [Blackfin] arch: Added support for OpenCores Keyboard Controller to H8606 board

Joe Perches (1):
      [Blackfin] arch: Spelling fixes

Martin Strubel (2):
      [Blackfin] arch: added Minotaur BSP
      [Blackfin] arch: disable bfin_get_ether_addr fucntion for boards when do not use MAC driver

Michael Hennerich (16):
      [Blackfin] arch: add Hitachi TX09D70VM1CDA TFT LCD driver resource to Blackfin board
      [Blackfin] arch: Enable peripheral platform resources on the BF527 EZkit
      [Blackfin] arch: Trash bf54x-hcd driver - we use the musb driver
      [Blackfin] arch: The BF527 EZkit connects UART1/PORTF
      [Blackfin] arch: Fix gpio label handling
      [Blackfin] arch: append IRQ Number to label string
      [Blackfin] arch: replace current blackfin specific pfbutton driver with kernel generic gpio key driver
      [Blackfin] arch: Enable both edge triggered GPIO IRQs on BF54x and use irq_to_gpio()
      [Blackfin] arch: Fix BUG - kernel sometimes would stuck with KEYBOARD_GPIO on
      [Blackfin] arch: Add some comments - fix semicolons
      [Blackfin] arch: set_bfin_dma_config shouldnt set SYNC or RESTART by default - add argument or option
      [Blackfin] arch: Fix BUG gpio_direction_output API is not compatitable with GENERIC_GPIO API interface
      [Blackfin] arch: GPIO API cleanup and anomaly update
      [Blackfin] arch: Update copyright date
      [Blackfin] arch: Add proper SW System Reset delay sequence
      [Blackfin] arch: Fix bug - kernel build with Debug option enabled fails to boot up

Mike Frysinger (6):
      [Blackfin] arch: scrub dead alive/idle LED code
      [Blackfin] arch: add support for BF523/BF524/BF526
      [Blackfin] arch: pull in linux/etherdevice.h for random_ether_addr() used in bfin_get_ether_addr()
      [Blackfin] arch: update to latest anomaly sheets
      [Blackfin] arch: use common flash driver to setup partitions rather than the bf5xx-flash driver
      MAINTIANERS: just use Mike gmail e-mail for contact and pawn the serial driver off onto Sonic

Robin Getz (9):
      [Blackfin] arch: Add a note describing what is going on - no functional changes
      [Blackfin] arch: fix bug - trap_tests fails to recover on some tests.
      [Blackfin] arch: fix bug gdb testing on hardware has regression
      [Blackfin] arch: do not use hard coded addresses
      [Blackfin] arch: do not use fixed numbers to describe offsets - no functional changes
      [Blackfin] arch: Let the pre-processor do the math to save a few cycles - no functional changes
      [Blackfin] arch: Clean up dump_bfin_mem
      [Blackfin] arch: Don't oops_in_progress if single step is comming from the kernel
      [Blackfin] arch: print out list of modules if kernel is crashing and tell people if the kernel is tainted

Sonic Zhang (5):
      [Blackfin] arch: Fix bug to Enable kernel to build for bf548 with PM.
      [Blackfin] arch: Fix bug to Enable bf548 to Re-program Clocks while Kernel boots.
      [Blackfin] arch: Restore default DMA priority over core on bf54x.
      [Blackfin] arch: fix bug - kgdb causing kernel panic
      [Blackfin] arch: Fix bug Only RTC interrupt can wake up deeper sleep core.

Yi Li (2):
      [Blackfin] arch: fix bug - make memcpy return the dest addr.
      [Blackfin] arch: fix bug kernel boot message: memory information is not reasonable
