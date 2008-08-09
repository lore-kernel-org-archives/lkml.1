Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYHIOKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYHIOKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 10:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYHIOJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 10:09:53 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:54869 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbYHIOJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 10:09:52 -0400
Date: Sat, 9 Aug 2008 16:09:02 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org
Subject: [GIT PULL] avr32 fixes for 2.6.27
Message-ID: <20080809160902.1e8db45d@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Aug 2008 14:09:06.0004 (UTC) FILETIME=[7BF0C940:01C8FA29]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

to receive the below updates. This includes the final step of Russell's
six-step headerfile program: removing the now-unused asm/arch headers
that were copied into arch/avr32/mach-at32ap/include/mach earlier.

This should also make the DataFlash more reliable on ATNGW100, and make
it easier for boards to tweak the on-chip bus through the HMATRIX
configuration registers.

Haavard Skinnemoen (7):
      avr32: Remove include/asm-avr32/arch-at32ap
      avr32: Introduce <mach/chip.h>
      avr32: Add MMIO address definitions for certain controllers
      avr32: Clean up HMATRIX code
      avr32: Update defconfigs
      avr32: Reduce DataFlash bus speed to 8 MHz on ATNGW100
      avr32: Make atstk1006_nand_data definition static

 arch/avr32/Makefile                              |   14 -
 arch/avr32/boards/atngw100/setup.c               |    2 +-
 arch/avr32/boards/atstk1000/atstk1002.c          |    2 +-
 arch/avr32/configs/atngw100_defconfig            |  106 ++-
 arch/avr32/configs/atstk1002_defconfig           |  153 ++-
 arch/avr32/configs/atstk1003_defconfig           |  140 ++-
 arch/avr32/configs/atstk1004_defconfig           |   46 +-
 arch/avr32/configs/atstk1006_defconfig           | 1304 ++++++++++++++++++++++
 arch/avr32/mach-at32ap/Makefile                  |    1 +
 arch/avr32/mach-at32ap/at32ap700x.c              |   26 +-
 arch/avr32/mach-at32ap/clock.c                   |    2 +
 arch/avr32/mach-at32ap/hmatrix.c                 |   88 ++
 arch/avr32/mach-at32ap/hmatrix.h                 |  182 ---
 arch/avr32/mach-at32ap/include/mach/at32ap700x.h |   37 +
 arch/avr32/mach-at32ap/include/mach/chip.h       |   19 +
 arch/avr32/mach-at32ap/include/mach/hmatrix.h    |   55 +
 arch/avr32/mach-at32ap/pm.c                      |    4 +-
 arch/avr32/mach-at32ap/pm.h                      |   12 +-
 include/asm-avr32/arch-at32ap/at32ap700x.h       |   49 -
 include/asm-avr32/arch-at32ap/board.h            |  121 --
 include/asm-avr32/arch-at32ap/cpu.h              |   35 -
 include/asm-avr32/arch-at32ap/gpio.h             |   45 -
 include/asm-avr32/arch-at32ap/init.h             |   18 -
 include/asm-avr32/arch-at32ap/io.h               |   39 -
 include/asm-avr32/arch-at32ap/irq.h              |   14 -
 include/asm-avr32/arch-at32ap/pm.h               |   51 -
 include/asm-avr32/arch-at32ap/portmux.h          |   29 -
 include/asm-avr32/arch-at32ap/smc.h              |  113 --
 include/asm-avr32/arch-at32ap/sram.h             |   30 -
 29 files changed, 1807 insertions(+), 930 deletions(-)
 create mode 100644 arch/avr32/configs/atstk1006_defconfig
 create mode 100644 arch/avr32/mach-at32ap/hmatrix.c
 delete mode 100644 arch/avr32/mach-at32ap/hmatrix.h
 create mode 100644 arch/avr32/mach-at32ap/include/mach/chip.h
 create mode 100644 arch/avr32/mach-at32ap/include/mach/hmatrix.h
 delete mode 100644 include/asm-avr32/arch-at32ap/at32ap700x.h
 delete mode 100644 include/asm-avr32/arch-at32ap/board.h
 delete mode 100644 include/asm-avr32/arch-at32ap/cpu.h
 delete mode 100644 include/asm-avr32/arch-at32ap/gpio.h
 delete mode 100644 include/asm-avr32/arch-at32ap/init.h
 delete mode 100644 include/asm-avr32/arch-at32ap/io.h
 delete mode 100644 include/asm-avr32/arch-at32ap/irq.h
 delete mode 100644 include/asm-avr32/arch-at32ap/pm.h
 delete mode 100644 include/asm-avr32/arch-at32ap/portmux.h
 delete mode 100644 include/asm-avr32/arch-at32ap/smc.h
 delete mode 100644 include/asm-avr32/arch-at32ap/sram.h
