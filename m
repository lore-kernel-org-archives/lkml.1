Return-Path: <linux-kernel-owner+w=401wt.eu-S935598AbYBHUjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935598AbYBHUjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933336AbYBHUjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:39:17 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:40148 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934377AbYBHUjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:39:12 -0500
X-IronPort-AV: E=Sophos;i="4.25,322,1199682000"; 
   d="scan'208";a="48168685"
Subject: [GIT PULL] Blackfin arch fixing for 2.6.25-rc0
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Sat, 09 Feb 2008 04:39:07 +0800
Message-Id: <1202503147.6400.7.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 08 Feb 2008 20:39:10.0975 (UTC) FILETIME=[A8CBB0F0:01C86A92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 - merge dual core and single core intr-priority code together
 - add bf547 support
 - bug fixing

 arch/blackfin/Kconfig                              |   49 +-
 arch/blackfin/Kconfig.debug                        |    2 +-
 arch/blackfin/Makefile                             |    1 +
 arch/blackfin/configs/BF533-STAMP_defconfig        |   16 +-
 arch/blackfin/kernel/bfin_dma_5xx.c                |   10 +
 arch/blackfin/kernel/bfin_gpio.c                   |   20 +-
 arch/blackfin/kernel/cplb-mpu/cplbinit.c           |    4 +
 arch/blackfin/kernel/init_task.c                   |    2 +-
 arch/blackfin/kernel/setup.c                       |  583 +++++++---
 arch/blackfin/kernel/traps.c                       |    2 +-
 arch/blackfin/kernel/vmlinux.lds.S                 |   47 +-
 arch/blackfin/mach-bf527/boards/ezkit.c            |   19 +
 arch/blackfin/mach-bf533/boards/ezkit.c            |   18 +
 arch/blackfin/mach-bf533/boards/stamp.c            |   22 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |   16 +
 arch/blackfin/mach-bf548/boards/ezkit.c            |   22 +-
 arch/blackfin/mach-bf548/dma.c                     |    4 +-
 arch/blackfin/mach-bf561/boards/ezkit.c            |   87 ++
 arch/blackfin/mach-common/Makefile                 |    4 +-
 arch/blackfin/mach-common/dpmc.S                   |   32 +-
 arch/blackfin/mach-common/entry.S                  |   12 +-
 arch/blackfin/mach-common/ints-priority-dc.c       |  484 --------
 .../{ints-priority-sc.c => ints-priority.c}        |  271 ++++-
 arch/blackfin/mach-common/pm.c                     |   44 +-
 arch/blackfin/mm/init.c                            |   12 +-
 include/asm-blackfin/bfin-global.h                 |    2 +
 include/asm-blackfin/bfin5xx_spi.h                 |   44 +-
 include/asm-blackfin/dpmc.h                        |    8 +-
 include/asm-blackfin/gpio.h                        |    8 +-
 include/asm-blackfin/mach-bf548/blackfin.h         |    8 +-
 include/asm-blackfin/mach-bf548/cdefBF547.h        |  865 ++++++++++++++
 include/asm-blackfin/mach-bf548/defBF547.h         | 1244 ++++++++++++++++++++
 include/asm-blackfin/mach-bf548/defBF548.h         |    4 +-
 include/asm-blackfin/mach-bf548/dma.h              |    4 +
 include/asm-blackfin/mach-bf548/irq.h              |    8 +
 include/asm-blackfin/mach-bf561/blackfin.h         |   20 +
 include/asm-blackfin/termios.h                     |   18 -
 include/asm-blackfin/trace.h                       |   35 +-
 38 files changed, 3185 insertions(+), 866 deletions(-)
 delete mode 100644 arch/blackfin/mach-common/ints-priority-dc.c
 rename arch/blackfin/mach-common/{ints-priority-sc.c => ints-priority.c} (83%)
 create mode 100644 include/asm-blackfin/mach-bf548/cdefBF547.h
 create mode 100644 include/asm-blackfin/mach-bf548/defBF547.h

Bryan Wu (1):
      [Blackfin] arch: fix bug: redefinition warning when compile EZKIT548

Michael Hennerich (8):
      [Blackfin] arch: Merge BF561 support into ints-priority
      [Blackfin] arch: hook up set_irq_wake in Blackfin's irq code
      [Blackfin] arch: Add Support for ISP1362
      [Blackfin] arch: Fix header file information
      [Blackfin] arch: Fix BUG - Enable ISP1362 driver to work ok with BF561
      [Blackfin] arch:Fix BUG [#3876] pfbutton test for BTN3 on bf533 don't show complete info
      [Blackfin] arch: Enable NET2272 on BF561-EZkit - remove request_mem_region
      [Blackfin] arch: Encourage users to use the spidev character driver: Provide platform support

Mike Frysinger (12):
      [Blackfin] arch: error out if ANOMALY_05000263 applies while enabling the MPU
      [Blackfin] arch: add support for cmdline partitioning to the BF533-STAMP flash map driver and enable it as a module by default
      [Blackfin] arch: add slightly better help text for CPLB_INFO
      [Blackfin] arch: this is an ezkit, not a stamp, so fixup the init function name
      [Blackfin] arch: fix typo in printk message
      [Blackfin] arch: change the trace buffer control start/stop logic in the exception handlers
      [Blackfin] arch: move the init sections to the end of memory
      [Blackfin] arch: simpler header and update dates
      [Blackfin] arch: fix building with mtd uclinux by putting the mtd_phys option into the function it actually gets used in
      [Blackfin] arch: declare default INSTALL_PATH for Blackfin ports
      [Blackfin] arch: fix build fails only include header files when enabled
      [Blackfin] arch: import defines for BF547 -- it is just like the BF548, but no CAN

Sonic Zhang (1):
      [Blackfin] arch: Enable UART2 and UART3 for bf548

Tilman Schmidt (1):
      [Blackfin] arch: remove duplicated definitions of the line discipline numbers N_* in asm-blackfin/termios.h

Yi Li (1):
      [Blackfin] arch: add "memmap=nn[KMG]@ss[KMG]" and "memmap=nn[KMG]$ss[KMG]" options to blackfin, based on arch/i386/kernel/e820.c
