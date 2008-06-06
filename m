Return-Path: <linux-kernel-owner+w=401wt.eu-S1763065AbYFFQNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763065AbYFFQNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbYFFQMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:12:21 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39477 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326AbYFFQMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:12:19 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-mtd@lists.infradead.org, kernel@avr32linux.org
Cc: Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 2/8] rename at91_nand -> atmel_nand: file names and Kconfig
Date: Fri,  6 Jun 2008 18:04:52 +0200
Message-Id: <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 06 Jun 2008 16:04:19.0217 (UTC) FILETIME=[FA196010:01C8C7EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AT91 NAND driver needs just a few tiny modifications to work on
AVR32 as well. Rename it atmel_nand to reflect this.

Also move the ECC register definitions into drivers/mtd/nand since they
are only useful to the atmel_nand driver, and get rid of the useless
filename at the top of each file.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mtd/nand/Kconfig                           |   17 +++++++++--------
 drivers/mtd/nand/Makefile                          |    2 +-
 drivers/mtd/nand/{at91_nand.c => atmel_nand.c}     |   10 ++++------
 .../mtd/nand/atmel_nand_ecc.h                      |    6 ++----
 4 files changed, 16 insertions(+), 19 deletions(-)
 rename drivers/mtd/nand/{at91_nand.c => atmel_nand.c} (98%)
 rename include/asm-arm/arch-at91/at91_ecc.h => drivers/mtd/nand/atmel_nand_ecc.h (93%)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 5076faf..7bbf386 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -272,7 +272,7 @@ config MTD_NAND_CS553X
 
 	  If you say "m", the module will be called "cs553x_nand.ko".
 
-config MTD_NAND_AT91
+config MTD_NAND_ATMEL
 	bool "Support for NAND Flash / SmartMedia on AT91"
 	depends on ARCH_AT91
 	help
@@ -280,14 +280,15 @@ config MTD_NAND_AT91
 	  on Atmel AT91 processors.
 choice
 	prompt "ECC management for NAND Flash / SmartMedia on AT91"
-	depends on MTD_NAND_AT91
+	depends on MTD_NAND_ATMEL
 
-config MTD_NAND_AT91_ECC_HW
+config MTD_NAND_ATMEL_ECC_HW
 	bool "Hardware ECC"
 	depends on ARCH_AT91SAM9263 || ARCH_AT91SAM9260
 	help
-	  Uses hardware ECC provided by the at91sam9260/at91sam9263 chip
-	  instead of software ECC.
+	  Use hardware ECC instead of software ECC when the chip
+	  supports it.
+
 	  The hardware ECC controller is capable of single bit error
 	  correction and 2-bit random detection per page.
 
@@ -297,16 +298,16 @@ config MTD_NAND_AT91_ECC_HW
 
 	  If unsure, say Y
 
-config MTD_NAND_AT91_ECC_SOFT
+config MTD_NAND_ATMEL_ECC_SOFT
 	bool "Software ECC"
 	help
-	  Uses software ECC.
+	  Use software ECC.
 
 	  NB : hardware and software ECC schemes are incompatible.
 	  If you switch from one to another, you'll have to erase your
 	  mtd partition.
 
-config MTD_NAND_AT91_ECC_NONE
+config MTD_NAND_ATMEL_ECC_NONE
 	bool "No ECC (testing only, DANGEROUS)"
 	depends on DEBUG_KERNEL
 	help
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index a6e74a4..e3d738a 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -24,7 +24,7 @@ obj-$(CONFIG_MTD_NAND_TS7250)		+= ts7250.o
 obj-$(CONFIG_MTD_NAND_NANDSIM)		+= nandsim.o
 obj-$(CONFIG_MTD_NAND_CS553X)		+= cs553x_nand.o
 obj-$(CONFIG_MTD_NAND_NDFC)		+= ndfc.o
-obj-$(CONFIG_MTD_NAND_AT91)		+= at91_nand.o
+obj-$(CONFIG_MTD_NAND_ATMEL)		+= atmel_nand.o
 obj-$(CONFIG_MTD_NAND_CM_X270)		+= cmx270_nand.o
 obj-$(CONFIG_MTD_NAND_BASLER_EXCITE)	+= excite_nandflash.o
 obj-$(CONFIG_MTD_NAND_PXA3xx)		+= pxa3xx_nand.o
diff --git a/drivers/mtd/nand/at91_nand.c b/drivers/mtd/nand/atmel_nand.c
similarity index 98%
rename from drivers/mtd/nand/at91_nand.c
rename to drivers/mtd/nand/atmel_nand.c
index 2dcaeea..51b7031 100644
--- a/drivers/mtd/nand/at91_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -1,6 +1,4 @@
 /*
- * drivers/mtd/nand/at91_nand.c
- *
  *  Copyright (C) 2003 Rick Bronson
  *
  *  Derived from drivers/mtd/nand/autcpu12.c
@@ -36,13 +34,13 @@
 
 #include <asm/arch/board.h>
 
-#ifdef CONFIG_MTD_NAND_AT91_ECC_HW
+#ifdef CONFIG_MTD_NAND_ATMEL_ECC_HW
 #define hard_ecc	1
 #else
 #define hard_ecc	0
 #endif
 
-#ifdef CONFIG_MTD_NAND_AT91_ECC_NONE
+#ifdef CONFIG_MTD_NAND_ATMEL_ECC_NONE
 #define no_ecc		1
 #else
 #define no_ecc		0
@@ -54,7 +52,7 @@
 #define ecc_writel(add, reg, value)			\
 	__raw_writel((value), add + AT91_ECC_##reg)
 
-#include <asm/arch/at91_ecc.h> /* AT91SAM9260/3 ECC registers */
+#include "atmel_nand_ecc.h"	/* Hardware ECC registers */
 
 /* oob layout for large page size
  * bad block info is on bytes 0 and 1
@@ -588,5 +586,5 @@ module_exit(at91_nand_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rick Bronson");
-MODULE_DESCRIPTION("NAND/SmartMedia driver for AT91RM9200 / AT91SAM9");
+MODULE_DESCRIPTION("NAND/SmartMedia driver for AT91 / AVR32");
 MODULE_ALIAS("platform:at91_nand");
diff --git a/include/asm-arm/arch-at91/at91_ecc.h b/drivers/mtd/nand/atmel_nand_ecc.h
similarity index 93%
rename from include/asm-arm/arch-at91/at91_ecc.h
rename to drivers/mtd/nand/atmel_nand_ecc.h
index 1e5a8ca..170db86 100644
--- a/include/asm-arm/arch-at91/at91_ecc.h
+++ b/drivers/mtd/nand/atmel_nand_ecc.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-arm/arch-at91/at91_ecc.h
- *
  * Error Corrected Code Controller (ECC) - System peripherals regsters.
  * Based on AT91SAM9260 datasheet revision B.
  *
@@ -10,8 +8,8 @@
  * option) any later version.
  */
 
-#ifndef AT91_ECC_H
-#define AT91_ECC_H
+#ifndef ATMEL_NAND_ECC_H
+#define ATMEL_NAND_ECC_H
 
 #define AT91_ECC_CR		0x00			/* Control register */
 #define		AT91_ECC_RST		(1 << 0)		/* Reset parity */
-- 
1.5.5.1

