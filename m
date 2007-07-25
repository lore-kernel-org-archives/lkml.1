Return-Path: <linux-kernel-owner+w=401wt.eu-S1764177AbXGYOTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764177AbXGYOTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXGYOTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:19:15 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:11792 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbXGYOTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:19:14 -0400
X-IronPort-AV: i="4.16,581,1175486400"; 
   d="scan'208"; a="35649037:sNHT37530598"
Subject: [GIT PULL] Blackfin update
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Wed, 25 Jul 2007 21:30:35 +0800
Message-Id: <1185370235.9648.8.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 25 Jul 2007 14:19:11.0896 (UTC) FILETIME=[C5B1D180:01C7CEC6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull Blackfin architecture updates from:

 master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git/ master

Bug fixing, code cleanup, anomaly handling update and GPIO API update.

serial, SPI, EMAC and RTC driver updating.

Bernd Schmidt (3):
      Blackfin arch: fix bug which unaligns the init thread's stack and causes the current macro to fail.
      Blackfin arch: Initialize the exception vectors early in the boot process
      Blackfin arch: Load P0 before storing through it

Bryan Wu (5):
      Blackfin arch: fix a compiling warning about dma-mapping
      Blackfin arch: bug fixing, add missing BF533_FAMILY GPIO_PFx definition
      Blackfin arch: add BF54x I2C/TWI TWI0 driver support
      Blackfin SPI driver: Initial supporting BF54x in SPI driver
      Blackfin SPI driver update:

Michael Hennerich (14):
      Blackfin arch: store labels so we later know who allocated GPIO/Peripheral resources
      Blackfin arch: add peripheral resource allocation support
      Blackfin arch: Add label to call new GPIO API
      Blackfin arch: fix PORT_J BUG for BF537/6 EMAC driver
      Blackfin arch: Finalize the generic gpio support - add gpio_to_irq and irq_to_gpio
      Blackfin arch: Advertise GENERIC_GPIO and remove duplicated GENERIC_CALIBRATE_DELAY
      Blackfin arch: add error message when IRQ no available
      Blackfin arch: Add PORT_J.High (needed for BF548-EZkit Touchscreen interrupts) - remove PORT_C.H
      Blackfin arch: add missing gpio error handling to make sure we roll back requests in case one fails
      Blackfin Ethernet MAC driver: fix bug Report returned -ENOMEM upwards (in case L1/uncached memory alloc fails)
      Blackfin serial driver: use new GPIO API
      Blackfin SPI driver: Make BF54x SPI work and add support for  portmux API
      Blackfin SPI driver: use new GPIO API and add error handling
      Input Serio: Blackfin doesnt support I8042 - make sure it doesnt get selected

Mike Frysinger (12):
      Blackfin arch: cleanup and standardize anomaly.h file format -- no functional changes
      Blackfin arch: setup aliases for some core Core A MMRs
      Blackfin arch: use bfin_read_SWRST() now that BF561 provides it
      Blackfin arch: add selections for BF544 and BF542
      Blackfin arch: use HI/LO macros rather than masking the bit ranges ourselves
      Blackfin arch: switch to using proper defines this time THREAD_SIZE and PAGE_SIZE instead of just PAGE_SIZE everywhere
      Blackfin arch: revise anomaly handling by basing things on the compiler not the kconfig defines
      Blackfin arch: scrub remaining ASSEMBLY usage since the switch to __ASSEMBLY__
      Blackfin arch: update BF54x anomaly list
      Blackfin arch: use the [CS]SYNC() macros which include anomaly workarounds rather than __builtin_bfin_[cs]sync()
      Blackfin arch: reorganize headers slightly so we can be sure things are defined early enough
      Blackfin On-Chip RTC driver update for supporting BF54x

Robin Getz (1):
      Blackfin arch: Add ability to expend the hardware trace buffer

Sonic Zhang (1):
      Blackfin arch: fix KGDB bug, dont forget last parameter.

 arch/blackfin/Kconfig                              |   83 ++++-
 arch/blackfin/Makefile                             |    4 +
 arch/blackfin/kernel/bfin_gpio.c                   |  301 +++++++++++--
 arch/blackfin/kernel/cplbinit.c                    |    4 +-
 arch/blackfin/kernel/dma-mapping.c                 |    3 +-
 arch/blackfin/kernel/irqchip.c                     |    9 +
 arch/blackfin/kernel/setup.c                       |   25 +-
 arch/blackfin/kernel/traps.c                       |   55 ++-
 arch/blackfin/kernel/vmlinux.lds.S                 |   16 +-
 arch/blackfin/lib/memcmp.S                         |    2 +-
 arch/blackfin/lib/memcpy.S                         |    2 +-
 arch/blackfin/lib/memmove.S                        |    4 +-
 arch/blackfin/mach-bf533/head.S                    |   24 +-
 arch/blackfin/mach-bf537/head.S                    |   32 +-
 arch/blackfin/mach-bf548/Kconfig                   |    4 +-
 arch/blackfin/mach-bf548/boards/ezkit.c            |   30 ++
 arch/blackfin/mach-bf548/gpio.c                    |   98 ++++-
 arch/blackfin/mach-bf548/head.S                    |   16 +-
 arch/blackfin/mach-bf561/head.S                    |   35 +-
 arch/blackfin/mach-common/cache.S                  |    8 +-
 arch/blackfin/mach-common/cacheinit.S              |    9 +-
 arch/blackfin/mach-common/cplbmgr.S                |   54 ++--
 arch/blackfin/mach-common/dpmc.S                   |   52 ++--
 arch/blackfin/mach-common/entry.S                  |   83 ++++-
 arch/blackfin/mach-common/interrupt.S              |    6 +-
 arch/blackfin/mach-common/ints-priority-dc.c       |   43 +-
 arch/blackfin/mach-common/ints-priority-sc.c       |   56 ++-
 arch/blackfin/mach-common/lock.S                   |   20 +-
 arch/blackfin/oprofile/op_blackfin.h               |    8 +-
 drivers/i2c/busses/Kconfig                         |    4 +-
 drivers/input/serio/Kconfig                        |    2 +-
 drivers/net/bfin_mac.c                             |    6 +-
 drivers/rtc/rtc-bfin.c                             |    2 +-
 drivers/serial/bfin_5xx.c                          |   14 +-
 drivers/spi/spi_bfin5xx.c                          |  202 ++++-----
 include/asm-blackfin/bfin-global.h                 |    1 +
 include/asm-blackfin/bfin5xx_spi.h                 |    6 +
 include/asm-blackfin/blackfin.h                    |  124 +++---
 include/asm-blackfin/gpio.h                        |   31 ++
 include/asm-blackfin/mach-bf533/anomaly.h          |  467 ++++++++++----------
 include/asm-blackfin/mach-bf533/bf533.h            |    2 +-
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h  |   11 +-
 include/asm-blackfin/mach-bf533/blackfin.h         |    2 +-
 include/asm-blackfin/mach-bf533/cdefBF532.h        |   10 +-
 include/asm-blackfin/mach-bf533/irq.h              |    2 +
 include/asm-blackfin/mach-bf533/portmux.h          |    2 +-
 include/asm-blackfin/mach-bf537/anomaly.h          |  248 ++++++-----
 include/asm-blackfin/mach-bf537/bf537.h            |    2 +-
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h  |   23 +-
 include/asm-blackfin/mach-bf537/blackfin.h         |    2 +-
 include/asm-blackfin/mach-bf537/cdefBF534.h        |    4 +-
 include/asm-blackfin/mach-bf537/irq.h              |    2 +
 include/asm-blackfin/mach-bf537/portmux.h          |   35 ++-
 include/asm-blackfin/mach-bf548/anomaly.h          |  130 +++---
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h  |   39 +-
 include/asm-blackfin/mach-bf548/blackfin.h         |    2 +-
 include/asm-blackfin/mach-bf548/cdefBF54x_base.h   |   37 ++-
 include/asm-blackfin/mach-bf548/defBF54x_base.h    |   17 +
 include/asm-blackfin/mach-bf548/gpio.h             |    5 -
 include/asm-blackfin/mach-bf548/irq.h              |    3 +
 include/asm-blackfin/mach-bf561/anomaly.h          |  409 ++++++++++-------
 include/asm-blackfin/mach-bf561/bf561.h            |    2 +-
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h  |   11 +-
 include/asm-blackfin/mach-bf561/blackfin.h         |    2 +-
 include/asm-blackfin/mach-bf561/cdefBF561.h        |   15 +-
 include/asm-blackfin/mach-bf561/defBF561.h         |    4 +
 include/asm-blackfin/mach-bf561/irq.h              |    2 +
 include/asm-blackfin/mach-common/cdef_LPBlackfin.h |    4 +-
 include/asm-blackfin/mach-common/def_LPBlackfin.h  |  132 +++---
 include/asm-blackfin/portmux.h                     |   22 +
 include/asm-blackfin/system.h                      |   93 +++--
 include/asm-blackfin/thread_info.h                 |   12 +-
 include/asm-blackfin/trace.h                       |   55 ++-
 73 files changed, 2058 insertions(+), 1228 deletions(-)
