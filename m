Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbXFNCFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbXFNCFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 22:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbXFNCFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 22:05:44 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:5425 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbXFNCFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 22:05:43 -0400
X-IronPort-AV: i="4.16,418,1175486400"; 
   d="scan'208"; a="42085251:sNHT260055775"
Subject: [GIT PULL] Blackfin updates for 2.6.22-rc4
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 14 Jun 2007 10:06:25 +0800
Message-Id: <1181786785.21995.5.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 14 Jun 2007 02:05:08.0873 (UTC) FILETIME=[6F121790:01C7AE28]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Sorry for word-wrapping in previous git pull request email.
 
please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git master

to receive the following updates:

Aubrey Li (2):
      Blackfin arch: DMA code minor naming convention fix
      Blackfin arch: try to split up functions like this into smaller units according to LKML review

Bernd Schmidt (1):
      Blackfin arch: defines and provides entry points for certain user space functions at fixed addresses

Bryan Wu (2):
      Blackfin arch: fixup Blackfin MAINTIANERS team member list
      Blackfin SPI driver: fix bug SPI DMA incomplete transmission

Jean-Christian de Rivaz (1):
      Blackfin SMC91X ethernet supporting driver: SMC91C111 LEDs are note drived in the kernel like in uboot

Michael Hennerich (3):
      Blackfin arch: As Mike pointed out range goes form m..MAX_BLACKFIN_GPIO -1
      Blackfin arch: add missing gpio.h header to fix compiling in some pm configurations
      Blackfin arch: fix bug can not wakeup from sleep via push buttons

Mike Frysinger (21):
      Blackfin arch: mark our memory init functions with __init so they get freed after init
      Blackfin arch: implement a basic /proc/sram file for L1 allocation visibility
      Blackfin arch: scrub old console defines
      Blackfin arch: update defconfigs
      Blackfin arch: unify differences between our diff head.S files -- no functional changes
      Blackfin arch: move more of our startup code to .init so it can be freed once we are up and running
      Blackfin arch: add proper ENDPROC()
      Blackfin arch: fix spelling typo in output
      Blackfin arch: add support for Alon Bar-Lev's dynamic kernel command-line
      Blackfin arch: need to rename function after moving to match new internal dma API
      Blackfin arch: new kernel config for BF548-EZKIT
      Blackfin arch: make sure we initialize our L1 Data B section properly based on the linked kernel
      Blackfin arch: redo our linker script a bit
      Blackfin arch: move HI/LO macros into blackfin.h and punt the rest of macros.h as it includes VDSP macros we never use
      Blackfin serial driver: hook up our UARTs STP bit with userspaces CMSPAR
      Blackfin serial driver: ignore framing and parity errors
      Blackfin serial driver: actually implement the break_ctl() function
      Blackfin serial driver: decouple PARODD and CMSPAR checking from PARENB
      Blackfin RTC drivers: update MAINTAINERS information
      Blackfin SPI driver: tweak spi cleanup function to match newer kernel changes
      Blackfin on-chip watchdog driver

Robin Getz (1):
      Blackfin arch: all symbols were offset by 4k, since we didn't have the __text label.

Roy Huang (4):
      Blackfin arch:  fix bug ad1836 fails to build properly for BF533-EZKIT
      Blackfin arch: Add header files for BF548
      Blackfin arch: initial supporting for BF548-EZKIT
      Blackfin serial driver: supporting BF548-EZKIT serial port

Simon Arlott (1):
      Blackfin arch: spelling fixes

 MAINTAINERS                                       |   86 +-
 arch/blackfin/Kconfig                             |   82 +-
 arch/blackfin/Makefile                            |    2 +
 arch/blackfin/configs/BF533-EZKIT_defconfig       |  241 +++-
 arch/blackfin/configs/BF533-STAMP_defconfig       |   92 +-
 arch/blackfin/configs/BF537-STAMP_defconfig       |   98 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig       | 1096 ++++++++++++++++++
 arch/blackfin/configs/BF561-EZKIT_defconfig       |  192 +++-
 arch/blackfin/configs/PNAV-10_defconfig           |  119 ++-
 arch/blackfin/kernel/Makefile                     |    6 +-
 arch/blackfin/kernel/bfin_dma_5xx.c               |  211 +----
 arch/blackfin/kernel/bfin_gpio.c                  |    7 +-
 arch/blackfin/kernel/entry.S                      |    5 +
 arch/blackfin/kernel/fixed_code.S                 |  132 +++
 arch/blackfin/kernel/irqchip.c                    |    2 +-
 arch/blackfin/kernel/process.c                    |   65 ++
 arch/blackfin/kernel/setup.c                      |  261 +++--
 arch/blackfin/kernel/traps.c                      |    2 +-
 arch/blackfin/kernel/vmlinux.lds.S                |  166 +--
 arch/blackfin/lib/divsi3.S                        |    3 +
 arch/blackfin/lib/ins.S                           |    4 +-
 arch/blackfin/lib/memchr.S                        |    2 +-
 arch/blackfin/lib/memcmp.S                        |    2 +-
 arch/blackfin/lib/memcpy.S                        |    2 +
 arch/blackfin/lib/memmove.S                       |    2 +-
 arch/blackfin/lib/memset.S                        |    2 +-
 arch/blackfin/lib/modsi3.S                        |    2 +
 arch/blackfin/lib/outs.S                          |    3 +
 arch/blackfin/lib/smulsi3_highpart.S              |    2 +
 arch/blackfin/lib/udivsi3.S                       |    2 +
 arch/blackfin/lib/umodsi3.S                       |    4 +
 arch/blackfin/lib/umulsi3_highpart.S              |    2 +
 arch/blackfin/mach-bf533/Makefile                 |    2 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c        |    2 +-
 arch/blackfin/mach-bf533/boards/ezkit.c           |    2 +-
 arch/blackfin/mach-bf533/dma.c                    |   95 ++
 arch/blackfin/mach-bf533/head.S                   |   30 +-
 arch/blackfin/mach-bf533/ints-priority.c          |    2 +-
 arch/blackfin/mach-bf537/Makefile                 |    2 +-
 arch/blackfin/mach-bf537/boards/generic_board.c   |    2 +-
 arch/blackfin/mach-bf537/boards/pnav10.c          |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c           |    2 +-
 arch/blackfin/mach-bf537/dma.c                    |  115 ++
 arch/blackfin/mach-bf537/head.S                   |   35 +-
 arch/blackfin/mach-bf537/ints-priority.c          |    2 +-
 arch/blackfin/mach-bf548/Kconfig                  |  282 +++++
 arch/blackfin/mach-bf548/Makefile                 |    9 +
 arch/blackfin/mach-bf548/boards/Makefile          |    5 +
 arch/blackfin/mach-bf548/boards/ezkit.c           |  114 ++
 arch/blackfin/mach-bf548/boards/led.S             |  172 +++
 arch/blackfin/mach-bf548/cpu.c                    |  159 +++
 arch/blackfin/mach-bf548/dma.c                    |  156 +++
 arch/blackfin/mach-bf548/gpio.c                   |  175 +++
 arch/blackfin/mach-bf548/head.S                   |  502 ++++++++
 arch/blackfin/mach-bf548/ints-priority.c          |  137 +++
 arch/blackfin/mach-bf561/Makefile                 |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c        |    4 +-
 arch/blackfin/mach-bf561/dma.c                    |  131 +++
 arch/blackfin/mach-bf561/head.S                   |   33 +-
 arch/blackfin/mach-bf561/ints-priority.c          |    2 +-
 arch/blackfin/mach-common/Makefile                |    4 +-
 arch/blackfin/mach-common/cache.S                 |   10 +
 arch/blackfin/mach-common/cacheinit.S             |    4 +
 arch/blackfin/mach-common/cplbhdlr.S              |    4 +-
 arch/blackfin/mach-common/cplbinfo.c              |    2 +-
 arch/blackfin/mach-common/cplbmgr.S               |    1 +
 arch/blackfin/mach-common/entry.S                 |   22 +
 arch/blackfin/mach-common/interrupt.S             |    2 +
 arch/blackfin/mach-common/ints-priority-dc.c      |    2 +-
 arch/blackfin/mach-common/ints-priority-sc.c      |   52 +-
 arch/blackfin/mach-common/lock.S                  |    4 +-
 arch/blackfin/mach-common/pm.c                    |    2 +-
 arch/blackfin/mm/blackfin_sram.c                  |  105 ++-
 arch/blackfin/mm/init.c                           |   20 +-
 drivers/char/watchdog/Kconfig                     |   13 +
 drivers/char/watchdog/Makefile                    |    3 +
 drivers/char/watchdog/bfin_wdt.c                  |  490 ++++++++
 drivers/net/smc91x.h                              |    2 +
 drivers/serial/Kconfig                            |   46 +-
 drivers/serial/bfin_5xx.c                         |   96 ++-
 drivers/spi/spi_bfin5xx.c                         |   17 +-
 include/asm-blackfin/Kbuild                       |    2 +
 include/asm-blackfin/bfin-global.h                |   12 +
 include/asm-blackfin/blackfin.h                   |    6 +-
 include/asm-blackfin/cplbinit.h                   |    4 +-
 include/asm-blackfin/fixed_code.h                 |   20 +
 include/asm-blackfin/gpio.h                       |    9 +-
 include/asm-blackfin/mach-bf533/dma.h             |    3 +
 include/asm-blackfin/mach-bf537/dma.h             |    3 +
 include/asm-blackfin/mach-bf548/anomaly.h         |   72 ++
 include/asm-blackfin/mach-bf548/bf548.h           |  286 +++++
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |  193 ++++
 include/asm-blackfin/mach-bf548/blackfin.h        |  168 +++
 include/asm-blackfin/mach-bf548/cdefBF54x_base.h  |   46 +-
 include/asm-blackfin/mach-bf548/defBF542.h        |  281 -----
 include/asm-blackfin/mach-bf548/defBF544.h        |   60 -
 include/asm-blackfin/mach-bf548/defBF548.h        |  341 ------
 include/asm-blackfin/mach-bf548/defBF549.h        |  763 +------------
 include/asm-blackfin/mach-bf548/defBF54x_base.h   | 1281 ++-------------------
 include/asm-blackfin/mach-bf548/dma.h             |   73 ++
 include/asm-blackfin/mach-bf548/gpio.h            |  210 ++++
 include/asm-blackfin/mach-bf548/irq.h             |  378 ++++++
 include/asm-blackfin/mach-bf548/mem_init.h        |  189 +++
 include/asm-blackfin/mach-bf548/mem_map.h         |   97 ++
 include/asm-blackfin/mach-bf561/dma.h             |    3 +
 include/asm-blackfin/mach-common/def_LPBlackfin.h |   22 +
 include/asm-blackfin/macros.h                     |   95 --
 107 files changed, 7034 insertions(+), 3557 deletions(-)
 create mode 100644 arch/blackfin/configs/BF548-EZKIT_defconfig
 create mode 100644 arch/blackfin/kernel/fixed_code.S
 create mode 100644 arch/blackfin/mach-bf533/dma.c
 create mode 100644 arch/blackfin/mach-bf537/dma.c
 create mode 100644 arch/blackfin/mach-bf548/Kconfig
 create mode 100644 arch/blackfin/mach-bf548/Makefile
 create mode 100644 arch/blackfin/mach-bf548/boards/Makefile
 create mode 100644 arch/blackfin/mach-bf548/boards/ezkit.c
 create mode 100644 arch/blackfin/mach-bf548/boards/led.S
 create mode 100644 arch/blackfin/mach-bf548/cpu.c
 create mode 100644 arch/blackfin/mach-bf548/dma.c
 create mode 100644 arch/blackfin/mach-bf548/gpio.c
 create mode 100644 arch/blackfin/mach-bf548/head.S
 create mode 100644 arch/blackfin/mach-bf548/ints-priority.c
 create mode 100644 arch/blackfin/mach-bf561/dma.c
 create mode 100644 drivers/char/watchdog/bfin_wdt.c
 create mode 100644 include/asm-blackfin/fixed_code.h
 create mode 100644 include/asm-blackfin/mach-bf548/anomaly.h
 create mode 100644 include/asm-blackfin/mach-bf548/bf548.h
 create mode 100644 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
 create mode 100644 include/asm-blackfin/mach-bf548/blackfin.h
 create mode 100644 include/asm-blackfin/mach-bf548/dma.h
 create mode 100644 include/asm-blackfin/mach-bf548/gpio.h
 create mode 100644 include/asm-blackfin/mach-bf548/irq.h
 create mode 100644 include/asm-blackfin/mach-bf548/mem_init.h
 create mode 100644 include/asm-blackfin/mach-bf548/mem_map.h
