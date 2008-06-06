Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbYFFQFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbYFFQFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbYFFQFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:05:11 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39415 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbYFFQFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:05:10 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-mtd@lists.infradead.org, kernel@avr32linux.org
Cc: Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 0/8] Make at91_nand usable on AVR32
Date: Fri,  6 Jun 2008 18:04:50 +0200
Message-Id: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.1
X-OriginalArrivalTime: 06 Jun 2008 16:04:19.0076 (UTC) FILETIME=[FA03DC40:01C8C7EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset renames at91_nand to atmel_nand and makes it usable on
AVR32. It also fixes a couple of bugs in the process.

The patchset also adds support for the ATSTK1006 daughterboard which
is currently in production, and is what I used for testing. It's
basically the same as ATSTK1002 except that it has more RAM (handled
by u-boot) and NAND flash (handled by patch #8) on board.

This patchset hopefully makes the at32_nand driver (which doesn't
support hardware ECC) obsolete. It has never been submitted for
inclusion in mainline, and I don't intend to do so. Please use this
driver instead.

I saw a lot of ECC errors when trying to use hardware ECC, but I
suspect that might be because I tested software ECC first, which uses
an incompatible oob layout.

Haavard


Haavard Skinnemoen (8):
      at91_nand: Convert to generic GPIO API
      rename at91_nand -> atmel_nand: file names and Kconfig
      rename at91_nand -> atmel_nand: internal symbols
      atmel_nand: Clean up and fix probe() error path
      avr32: move hsmc_init() to core_initcall
      avr32: atmel_nand platform code for AT32AP700x
      atmel_nand: make available on AVR32
      avr32: Add support for ATSTK1006

 arch/arm/mach-at91/at91cap9_devices.c          |    8 +-
 arch/arm/mach-at91/at91rm9200_devices.c        |    8 +-
 arch/arm/mach-at91/at91sam9260_devices.c       |    8 +-
 arch/arm/mach-at91/at91sam9261_devices.c       |   12 +-
 arch/arm/mach-at91/at91sam9263_devices.c       |    8 +-
 arch/arm/mach-at91/at91sam9rl_devices.c        |   12 +-
 arch/arm/mach-at91/board-cam60.c               |    2 +-
 arch/arm/mach-at91/board-cap9adk.c             |    2 +-
 arch/arm/mach-at91/board-dk.c                  |    2 +-
 arch/arm/mach-at91/board-kb9202.c              |    2 +-
 arch/arm/mach-at91/board-sam9-l9260.c          |    2 +-
 arch/arm/mach-at91/board-sam9260ek.c           |    2 +-
 arch/arm/mach-at91/board-sam9261ek.c           |    2 +-
 arch/arm/mach-at91/board-sam9263ek.c           |    2 +-
 arch/arm/mach-at91/board-sam9rlek.c            |    2 +-
 arch/arm/mach-at91/board-yl-9200.c             |    2 +-
 arch/avr32/boards/atstk1000/Kconfig            |    4 +
 arch/avr32/boards/atstk1000/Makefile           |    1 +
 arch/avr32/boards/atstk1000/atstk1002.c        |   78 +++++++++-
 arch/avr32/mach-at32ap/at32ap700x.c            |   52 ++++++
 arch/avr32/mach-at32ap/hsmc.c                  |    2 +-
 drivers/mtd/nand/Kconfig                       |   27 ++--
 drivers/mtd/nand/Makefile                      |    2 +-
 drivers/mtd/nand/{at91_nand.c => atmel_nand.c} |  213 ++++++++++++------------
 drivers/mtd/nand/atmel_nand_ecc.h              |   36 ++++
 include/asm-arm/arch-at91/at91_ecc.h           |   38 -----
 include/asm-arm/arch-at91/board.h              |    4 +-
 include/asm-avr32/arch-at32ap/board.h          |   13 ++
 28 files changed, 344 insertions(+), 202 deletions(-)
 rename drivers/mtd/nand/{at91_nand.c => atmel_nand.c} (69%)
 create mode 100644 drivers/mtd/nand/atmel_nand_ecc.h
 delete mode 100644 include/asm-arm/arch-at91/at91_ecc.h
