Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbXFNHGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbXFNHGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbXFNHFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:05:47 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:21736 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbXFNHFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:05:46 -0400
X-IronPort-AV: i="4.16,419,1175486400"; 
   d="scan'208"; a="32405861:sNHT32429530"
Subject: [GIT PULL] Blackfin updates for 2.6.22-rc4
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
       Jeff Garzik <jeff@garzik.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 14 Jun 2007 15:09:11 +0800
Message-Id: <1181804951.21995.38.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 14 Jun 2007 07:05:45.0345 (UTC) FILETIME=[6DA54F10:01C7AE52]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Changes from last git-request-pull email:

 - remove some new platform and new driver patches out of this git-pull series as Paul mentioned
 - use scripts/checkpatch.pl to check and fix the coding style issues as Jeff pointed out

please pull from:

  master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git master

to receive the following updates:

Aubrey Li (2):
      Blackfin arch: DMA code minor naming convention fix
      Blackfin arch: try to split up functions like this into smaller units according to LKML review

Bryan Wu (2):
      Blackfin arch: fixup Blackfin MAINTIANERS team member list
      Blackfin SPI driver: fix bug SPI DMA incomplete transmission

Jean-Christian de Rivaz (1):
      Blackfin SMC91X ethernet supporting driver: SMC91C111 LEDs are note drived in the kernel like in uboot

Michael Hennerich (3):
      Blackfin arch: As Mike pointed out range goes form m..MAX_BLACKFIN_GPIO -1
      Blackfin arch: add missing gpio.h header to fix compiling in some pm configurations
      Blackfin arch: fix bug can not wakeup from sleep via push buttons

Mike Frysinger (19):
      Blackfin arch: remove defconfig file
      Blackfin arch: mark our memory init functions with __init so they get freed after init
      Blackfin arch: implement a basic /proc/sram file for L1 allocation visibility
      Blackfin arch: scrub old console defines
      Blackfin arch: update defconfigs
      Blackfin arch: unify differences between our diff head.S files -- no functional changes
      Blackfin arch: move more of our startup code to .init so it can be freed once we are up and running
      Blackfin arch: add proper ENDPROC()
      Blackfin arch: fix spelling typo in output
      Blackfin arch: add support for Alon Bar-Lev's dynamic kernel command-line
      Blackfin arch: make sure we initialize our L1 Data B section properly based on the linked kernel
      Blackfin arch: redo our linker script a bit
      Blackfin arch: move HI/LO macros into blackfin.h and punt the rest of macros.h as it includes VDSP macros we never use
      Blackfin serial driver: hook up our UARTs STP bit with userspaces CMSPAR
      Blackfin serial driver: ignore framing and parity errors
      Blackfin serial driver: actually implement the break_ctl() function
      Blackfin serial driver: decouple PARODD and CMSPAR checking from PARENB
      Blackfin RTC drivers: update MAINTAINERS information
      Blackfin SPI driver: tweak spi cleanup function to match newer kernel changes

Robin Getz (1):
      Blackfin arch: all symbols were offset by 4k, since we didn't have the __text label.

Roy Huang (1):
      Blackfin arch:  fix bug ad1836 fails to build properly for BF533-EZKIT

Simon Arlott (1):
      Blackfin arch: spelling fixes

 MAINTAINERS                                       |   78 +-
 arch/blackfin/Kconfig                             |   35 -
 arch/blackfin/configs/BF533-EZKIT_defconfig       |  241 +++-
 arch/blackfin/configs/BF533-STAMP_defconfig       |   92 +-
 arch/blackfin/configs/BF537-STAMP_defconfig       |   98 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig       |  192 +++-
 arch/blackfin/configs/PNAV-10_defconfig           |  119 ++-
 arch/blackfin/defconfig                           | 1327 ---------------------
 arch/blackfin/kernel/bfin_dma_5xx.c               |    6 +-
 arch/blackfin/kernel/bfin_gpio.c                  |   14 +-
 arch/blackfin/kernel/entry.S                      |    5 +
 arch/blackfin/kernel/irqchip.c                    |    2 +-
 arch/blackfin/kernel/setup.c                      |  248 ++--
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
 arch/blackfin/mach-bf533/boards/cm_bf533.c        |    2 +-
 arch/blackfin/mach-bf533/boards/ezkit.c           |    2 +-
 arch/blackfin/mach-bf533/head.S                   |   30 +-
 arch/blackfin/mach-bf533/ints-priority.c          |    2 +-
 arch/blackfin/mach-bf537/boards/generic_board.c   |    2 +-
 arch/blackfin/mach-bf537/boards/pnav10.c          |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c           |    2 +-
 arch/blackfin/mach-bf537/head.S                   |   35 +-
 arch/blackfin/mach-bf537/ints-priority.c          |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c        |    4 +-
 arch/blackfin/mach-bf561/head.S                   |   33 +-
 arch/blackfin/mach-bf561/ints-priority.c          |    2 +-
 arch/blackfin/mach-common/cache.S                 |   10 +
 arch/blackfin/mach-common/cacheinit.S             |    4 +
 arch/blackfin/mach-common/cplbhdlr.S              |    4 +-
 arch/blackfin/mach-common/cplbinfo.c              |    2 +-
 arch/blackfin/mach-common/cplbmgr.S               |    1 +
 arch/blackfin/mach-common/entry.S                 |   18 +
 arch/blackfin/mach-common/interrupt.S             |    2 +
 arch/blackfin/mach-common/ints-priority-dc.c      |    2 +-
 arch/blackfin/mach-common/ints-priority-sc.c      |    2 +-
 arch/blackfin/mach-common/lock.S                  |    4 +-
 arch/blackfin/mach-common/pm.c                    |    2 +-
 arch/blackfin/mm/blackfin_sram.c                  |  111 ++-
 arch/blackfin/mm/init.c                           |   20 +-
 drivers/net/smc91x.h                              |    2 +
 drivers/serial/bfin_5xx.c                         |   19 +-
 drivers/spi/spi_bfin5xx.c                         |   17 +-
 include/asm-blackfin/blackfin.h                   |    6 +-
 include/asm-blackfin/gpio.h                       |    1 +
 include/asm-blackfin/mach-common/def_LPBlackfin.h |   22 +
 include/asm-blackfin/macros.h                     |   95 --
 60 files changed, 1070 insertions(+), 2049 deletions(-)
 delete mode 100644 arch/blackfin/defconfig
