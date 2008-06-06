Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbYFFQMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbYFFQMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYFFQMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:12:18 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39470 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbYFFQMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:12:14 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-mtd@lists.infradead.org, kernel@avr32linux.org
Cc: Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 3/8] rename at91_nand -> atmel_nand: internal symbols
Date: Fri,  6 Jun 2008 18:04:53 +0200
Message-Id: <1212768298-13614-4-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 06 Jun 2008 16:04:19.0279 (UTC) FILETIME=[FA22D5F0:01C8C7EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is basically s/at91_nand/atmel_nand/g with some manual inspection.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/arm/mach-at91/at91cap9_devices.c    |    8 +-
 arch/arm/mach-at91/at91rm9200_devices.c  |    8 +-
 arch/arm/mach-at91/at91sam9260_devices.c |    8 +-
 arch/arm/mach-at91/at91sam9261_devices.c |   12 +-
 arch/arm/mach-at91/at91sam9263_devices.c |    8 +-
 arch/arm/mach-at91/at91sam9rl_devices.c  |   12 +-
 arch/arm/mach-at91/board-cam60.c         |    2 +-
 arch/arm/mach-at91/board-cap9adk.c       |    2 +-
 arch/arm/mach-at91/board-dk.c            |    2 +-
 arch/arm/mach-at91/board-kb9202.c        |    2 +-
 arch/arm/mach-at91/board-sam9-l9260.c    |    2 +-
 arch/arm/mach-at91/board-sam9260ek.c     |    2 +-
 arch/arm/mach-at91/board-sam9261ek.c     |    2 +-
 arch/arm/mach-at91/board-sam9263ek.c     |    2 +-
 arch/arm/mach-at91/board-sam9rlek.c      |    2 +-
 arch/arm/mach-at91/board-yl-9200.c       |    2 +-
 drivers/mtd/nand/atmel_nand.c            |  152 +++++++++++++++---------------
 drivers/mtd/nand/atmel_nand_ecc.h        |   34 ++++----
 include/asm-arm/arch-at91/board.h        |    4 +-
 19 files changed, 133 insertions(+), 133 deletions(-)

diff --git a/arch/arm/mach-at91/at91cap9_devices.c b/arch/arm/mach-at91/at91cap9_devices.c
index be52674..fe5148e 100644
--- a/arch/arm/mach-at91/at91cap9_devices.c
+++ b/arch/arm/mach-at91/at91cap9_devices.c
@@ -278,7 +278,7 @@ void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data) {}
  * -------------------------------------------------------------------- */
 
 #if defined(CONFIG_MTD_NAND_AT91) || defined(CONFIG_MTD_NAND_AT91_MODULE)
-static struct at91_nand_data nand_data;
+static struct atmel_nand_data nand_data;
 
 #define NAND_BASE	AT91_CHIPSELECT_3
 
@@ -296,7 +296,7 @@ static struct resource nand_resources[] = {
 };
 
 static struct platform_device at91cap9_nand_device = {
-	.name		= "at91_nand",
+	.name		= "atmel_nand",
 	.id		= -1,
 	.dev		= {
 				.platform_data	= &nand_data,
@@ -305,7 +305,7 @@ static struct platform_device at91cap9_nand_device = {
 	.num_resources	= ARRAY_SIZE(nand_resources),
 };
 
-void __init at91_add_device_nand(struct at91_nand_data *data)
+void __init at91_add_device_nand(struct atmel_nand_data *data)
 {
 	unsigned long csa, mode;
 
@@ -346,7 +346,7 @@ void __init at91_add_device_nand(struct at91_nand_data *data)
 	platform_device_register(&at91cap9_nand_device);
 }
 #else
-void __init at91_add_device_nand(struct at91_nand_data *data) {}
+void __init at91_add_device_nand(struct atmel_nand_data *data) {}
 #endif
 
 
diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index de19bee..8ced9bc 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -369,7 +369,7 @@ void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data) {}
  * -------------------------------------------------------------------- */
 
 #if defined(CONFIG_MTD_NAND_AT91) || defined(CONFIG_MTD_NAND_AT91_MODULE)
-static struct at91_nand_data nand_data;
+static struct atmel_nand_data nand_data;
 
 #define NAND_BASE	AT91_CHIPSELECT_3
 
@@ -382,7 +382,7 @@ static struct resource nand_resources[] = {
 };
 
 static struct platform_device at91rm9200_nand_device = {
-	.name		= "at91_nand",
+	.name		= "atmel_nand",
 	.id		= -1,
 	.dev		= {
 				.platform_data	= &nand_data,
@@ -391,7 +391,7 @@ static struct platform_device at91rm9200_nand_device = {
 	.num_resources	= ARRAY_SIZE(nand_resources),
 };
 
-void __init at91_add_device_nand(struct at91_nand_data *data)
+void __init at91_add_device_nand(struct atmel_nand_data *data)
 {
 	unsigned int csa;
 
@@ -429,7 +429,7 @@ void __init at91_add_device_nand(struct at91_nand_data *data)
 	platform_device_register(&at91rm9200_nand_device);
 }
 #else
-void __init at91_add_device_nand(struct at91_nand_data *data) {}
+void __init at91_add_device_nand(struct atmel_nand_data *data) {}
 #endif
 
 
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index 393a32a..3aa62b1 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -283,7 +283,7 @@ void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data) {}
  * -------------------------------------------------------------------- */
 
 #if defined(CONFIG_MTD_NAND_AT91) || defined(CONFIG_MTD_NAND_AT91_MODULE)
-static struct at91_nand_data nand_data;
+static struct atmel_nand_data nand_data;
 
 #define NAND_BASE	AT91_CHIPSELECT_3
 
@@ -301,7 +301,7 @@ static struct resource nand_resources[] = {
 };
 
 static struct platform_device at91sam9260_nand_device = {
-	.name		= "at91_nand",
+	.name		= "atmel_nand",
 	.id		= -1,
 	.dev		= {
 				.platform_data	= &nand_data,
@@ -310,7 +310,7 @@ static struct platform_device at91sam9260_nand_device = {
 	.num_resources	= ARRAY_SIZE(nand_resources),
 };
 
-void __init at91_add_device_nand(struct at91_nand_data *data)
+void __init at91_add_device_nand(struct atmel_nand_data *data)
 {
 	unsigned long csa, mode;
 
@@ -351,7 +351,7 @@ void __init at91_add_device_nand(struct at91_nand_data *data)
 	platform_device_register(&at91sam9260_nand_device);
 }
 #else
-void __init at91_add_device_nand(struct at91_nand_data *data) {}
+void __init at91_add_device_nand(struct atmel_nand_data *data) {}
 #endif
 
 
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index 0babb64..247e8e7 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -199,7 +199,7 @@ void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data) {}
  * -------------------------------------------------------------------- */
 
 #if defined(CONFIG_MTD_NAND_AT91) || defined(CONFIG_MTD_NAND_AT91_MODULE)
-static struct at91_nand_data nand_data;
+static struct atmel_nand_data nand_data;
 
 #define NAND_BASE	AT91_CHIPSELECT_3
 
@@ -211,8 +211,8 @@ static struct resource nand_resources[] = {
 	}
 };
 
-static struct platform_device at91_nand_device = {
-	.name		= "at91_nand",
+static struct platform_device atmel_nand_device = {
+	.name		= "atmel_nand",
 	.id		= -1,
 	.dev		= {
 				.platform_data	= &nand_data,
@@ -221,7 +221,7 @@ static struct platform_device at91_nand_device = {
 	.num_resources	= ARRAY_SIZE(nand_resources),
 };
 
-void __init at91_add_device_nand(struct at91_nand_data *data)
+void __init at91_add_device_nand(struct atmel_nand_data *data)
 {
 	unsigned long csa, mode;
 
@@ -262,11 +262,11 @@ void __init at91_add_device_nand(struct at91_nand_data *data)
 	at91_set_A_periph(AT91_PIN_PC1, 0);		/* NANDWE */
 
 	nand_data = *data;
-	platform_device_register(&at91_nand_device);
+	platform_device_register(&atmel_nand_device);
 }
 
 #else
-void __init at91_add_device_nand(struct at91_nand_data *data) {}
+void __init at91_add_device_nand(struct atmel_nand_data *data) {}
 #endif
 
 
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 719667e..f1dfbfe 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -353,7 +353,7 @@ void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data) {}
  * -------------------------------------------------------------------- */
 
 #if defined(CONFIG_MTD_NAND_AT91) || defined(CONFIG_MTD_NAND_AT91_MODULE)
-static struct at91_nand_data nand_data;
+static struct atmel_nand_data nand_data;
 
 #define NAND_BASE	AT91_CHIPSELECT_3
 
@@ -371,7 +371,7 @@ static struct resource nand_resources[] = {
 };
 
 static struct platform_device at91sam9263_nand_device = {
-	.name		= "at91_nand",
+	.name		= "atmel_nand",
 	.id		= -1,
 	.dev		= {
 				.platform_data	= &nand_data,
@@ -380,7 +380,7 @@ static struct platform_device at91sam9263_nand_device = {
 	.num_resources	= ARRAY_SIZE(nand_resources),
 };
 
-void __init at91_add_device_nand(struct at91_nand_data *data)
+void __init at91_add_device_nand(struct atmel_nand_data *data)
 {
 	unsigned long csa, mode;
 
@@ -421,7 +421,7 @@ void __init at91_add_device_nand(struct at91_nand_data *data)
 	platform_device_register(&at91sam9263_nand_device);
 }
 #else
-void __init at91_add_device_nand(struct at91_nand_data *data) {}
+void __init at91_add_device_nand(struct atmel_nand_data *data) {}
 #endif
 
 
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 450db30..9945cd2 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -100,7 +100,7 @@ void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data) {}
  * -------------------------------------------------------------------- */
 
 #if defined(CONFIG_MTD_NAND_AT91) || defined(CONFIG_MTD_NAND_AT91_MODULE)
-static struct at91_nand_data nand_data;
+static struct atmel_nand_data nand_data;
 
 #define NAND_BASE	AT91_CHIPSELECT_3
 
@@ -117,8 +117,8 @@ static struct resource nand_resources[] = {
 	}
 };
 
-static struct platform_device at91_nand_device = {
-	.name		= "at91_nand",
+static struct platform_device atmel_nand_device = {
+	.name		= "atmel_nand",
 	.id		= -1,
 	.dev		= {
 				.platform_data	= &nand_data,
@@ -127,7 +127,7 @@ static struct platform_device at91_nand_device = {
 	.num_resources	= ARRAY_SIZE(nand_resources),
 };
 
-void __init at91_add_device_nand(struct at91_nand_data *data)
+void __init at91_add_device_nand(struct atmel_nand_data *data)
 {
 	unsigned long csa;
 
@@ -164,11 +164,11 @@ void __init at91_add_device_nand(struct at91_nand_data *data)
 	at91_set_A_periph(AT91_PIN_PB5, 0);		/* NANDWE */
 
 	nand_data = *data;
-	platform_device_register(&at91_nand_device);
+	platform_device_register(&atmel_nand_device);
 }
 
 #else
-void __init at91_add_device_nand(struct at91_nand_data *data) {}
+void __init at91_add_device_nand(struct atmel_nand_data *data) {}
 #endif
 
 
diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
index b22a1a0..af2c33a 100644
--- a/arch/arm/mach-at91/board-cam60.c
+++ b/arch/arm/mach-at91/board-cam60.c
@@ -142,7 +142,7 @@ static struct mtd_partition * __init nand_partitions(int size, int *num_partitio
 	return cam60_nand_partition;
 }
 
-static struct at91_nand_data __initdata cam60_nand_data = {
+static struct atmel_nand_data __initdata cam60_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 	// .det_pin	= ... not there
diff --git a/arch/arm/mach-at91/board-cap9adk.c b/arch/arm/mach-at91/board-cap9adk.c
index e5512d1..7144e1a 100644
--- a/arch/arm/mach-at91/board-cap9adk.c
+++ b/arch/arm/mach-at91/board-cap9adk.c
@@ -175,7 +175,7 @@ static struct mtd_partition * __init nand_partitions(int size, int *num_partitio
 	return cap9adk_nand_partitions;
 }
 
-static struct at91_nand_data __initdata cap9adk_nand_data = {
+static struct atmel_nand_data __initdata cap9adk_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 //	.det_pin	= ... not connected
diff --git a/arch/arm/mach-at91/board-dk.c b/arch/arm/mach-at91/board-dk.c
index c1a813c..ffecacb 100644
--- a/arch/arm/mach-at91/board-dk.c
+++ b/arch/arm/mach-at91/board-dk.c
@@ -150,7 +150,7 @@ static struct mtd_partition * __init nand_partitions(int size, int *num_partitio
 	return dk_nand_partition;
 }
 
-static struct at91_nand_data __initdata dk_nand_data = {
+static struct atmel_nand_data __initdata dk_nand_data = {
 	.ale		= 22,
 	.cle		= 21,
 	.det_pin	= AT91_PIN_PB1,
diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
index 4b39b9c..153450f 100644
--- a/arch/arm/mach-at91/board-kb9202.c
+++ b/arch/arm/mach-at91/board-kb9202.c
@@ -102,7 +102,7 @@ static struct mtd_partition * __init nand_partitions(int size, int *num_partitio
 	return kb9202_nand_partition;
 }
 
-static struct at91_nand_data __initdata kb9202_nand_data = {
+static struct atmel_nand_data __initdata kb9202_nand_data = {
 	.ale		= 22,
 	.cle		= 21,
 	// .det_pin	= ... not there
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index 8f76af5..57a6221 100644
--- a/arch/arm/mach-at91/board-sam9-l9260.c
+++ b/arch/arm/mach-at91/board-sam9-l9260.c
@@ -141,7 +141,7 @@ static struct mtd_partition * __init nand_partitions(int size, int *num_partitio
 	return ek_nand_partition;
 }
 
-static struct at91_nand_data __initdata ek_nand_data = {
+static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 //	.det_pin	= ... not connected
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index 4d1d9c7..6a68079 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -178,7 +178,7 @@ static struct mtd_partition * __init nand_partitions(int size, int *num_partitio
 	return ek_nand_partition;
 }
 
-static struct at91_nand_data __initdata ek_nand_data = {
+static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 //	.det_pin	= ... not connected
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index 08382c0..43dfbd0 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -183,7 +183,7 @@ static struct mtd_partition * __init nand_partitions(int size, int *num_partitio
 	return ek_nand_partition;
 }
 
-static struct at91_nand_data __initdata ek_nand_data = {
+static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 22,
 	.cle		= 21,
 //	.det_pin	= ... not connected
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index b4cd5d0..6605a09 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -187,7 +187,7 @@ static struct mtd_partition * __init nand_partitions(int size, int *num_partitio
 	return ek_nand_partition;
 }
 
-static struct at91_nand_data __initdata ek_nand_data = {
+static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 //	.det_pin	= ... not connected
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index ffc0597..35e69e5 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -88,7 +88,7 @@ static struct mtd_partition * __init nand_partitions(int size, int *num_partitio
 	return ek_nand_partition;
 }
 
-static struct at91_nand_data __initdata ek_nand_data = {
+static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 //	.det_pin	= ... not connected
diff --git a/arch/arm/mach-at91/board-yl-9200.c b/arch/arm/mach-at91/board-yl-9200.c
index b571710..e642b3a 100755
--- a/arch/arm/mach-at91/board-yl-9200.c
+++ b/arch/arm/mach-at91/board-yl-9200.c
@@ -251,7 +251,7 @@ static struct mtd_partition * __init nand_partitions(int size, int *num_partitio
 	return yl_9200_nand_partition;
 }
 
-static struct at91_nand_data __initdata yl_9200_nand_data = {
+static struct atmel_nand_data __initdata yl_9200_nand_data = {
 	.ale= 6,
 	.cle= 7,
 	/*.det_pin	= AT91_PIN_PCxx,*/   /*we don't have a det pin because NandFlash is fixed to board*/
diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 51b7031..675a82c 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -48,9 +48,9 @@
 
 /* Register access macros */
 #define ecc_readl(add, reg)				\
-	__raw_readl(add + AT91_ECC_##reg)
+	__raw_readl(add + ATMEL_ECC_##reg)
 #define ecc_writel(add, reg, value)			\
-	__raw_writel((value), add + AT91_ECC_##reg)
+	__raw_writel((value), add + ATMEL_ECC_##reg)
 
 #include "atmel_nand_ecc.h"	/* Hardware ECC registers */
 
@@ -59,7 +59,7 @@
  * the bytes have to be consecutives to avoid
  * several NAND_CMD_RNDOUT during read
  */
-static struct nand_ecclayout at91_oobinfo_large = {
+static struct nand_ecclayout atmel_oobinfo_large = {
 	.eccbytes = 4,
 	.eccpos = {60, 61, 62, 63},
 	.oobfree = {
@@ -72,7 +72,7 @@ static struct nand_ecclayout at91_oobinfo_large = {
  * the bytes have to be consecutives to avoid
  * several NAND_CMD_RNDOUT during read
  */
-static struct nand_ecclayout at91_oobinfo_small = {
+static struct nand_ecclayout atmel_oobinfo_small = {
 	.eccbytes = 4,
 	.eccpos = {0, 1, 2, 3},
 	.oobfree = {
@@ -80,11 +80,11 @@ static struct nand_ecclayout at91_oobinfo_small = {
 	},
 };
 
-struct at91_nand_host {
+struct atmel_nand_host {
 	struct nand_chip	nand_chip;
 	struct mtd_info		mtd;
 	void __iomem		*io_base;
-	struct at91_nand_data	*board;
+	struct atmel_nand_data	*board;
 	struct device		*dev;
 	void __iomem		*ecc;
 };
@@ -92,7 +92,7 @@ struct at91_nand_host {
 /*
  * Enable NAND.
  */
-static void at91_nand_enable(struct at91_nand_host *host)
+static void atmel_nand_enable(struct atmel_nand_host *host)
 {
 	if (host->board->enable_pin)
 		gpio_set_value(host->board->enable_pin, 0);
@@ -101,7 +101,7 @@ static void at91_nand_enable(struct at91_nand_host *host)
 /*
  * Disable NAND.
  */
-static void at91_nand_disable(struct at91_nand_host *host)
+static void atmel_nand_disable(struct atmel_nand_host *host)
 {
 	if (host->board->enable_pin)
 		gpio_set_value(host->board->enable_pin, 1);
@@ -110,16 +110,16 @@ static void at91_nand_disable(struct at91_nand_host *host)
 /*
  * Hardware specific access to control-lines
  */
-static void at91_nand_cmd_ctrl(struct mtd_info *mtd, int cmd, unsigned int ctrl)
+static void atmel_nand_cmd_ctrl(struct mtd_info *mtd, int cmd, unsigned int ctrl)
 {
 	struct nand_chip *nand_chip = mtd->priv;
-	struct at91_nand_host *host = nand_chip->priv;
+	struct atmel_nand_host *host = nand_chip->priv;
 
 	if (ctrl & NAND_CTRL_CHANGE) {
 		if (ctrl & NAND_NCE)
-			at91_nand_enable(host);
+			atmel_nand_enable(host);
 		else
-			at91_nand_disable(host);
+			atmel_nand_disable(host);
 	}
 	if (cmd == NAND_CMD_NONE)
 		return;
@@ -133,10 +133,10 @@ static void at91_nand_cmd_ctrl(struct mtd_info *mtd, int cmd, unsigned int ctrl)
 /*
  * Read the Device Ready pin.
  */
-static int at91_nand_device_ready(struct mtd_info *mtd)
+static int atmel_nand_device_ready(struct mtd_info *mtd)
 {
 	struct nand_chip *nand_chip = mtd->priv;
-	struct at91_nand_host *host = nand_chip->priv;
+	struct atmel_nand_host *host = nand_chip->priv;
 
 	return gpio_get_value(host->board->rdy_pin);
 }
@@ -144,7 +144,7 @@ static int at91_nand_device_ready(struct mtd_info *mtd)
 /*
  * write oob for small pages
  */
-static int at91_nand_write_oob_512(struct mtd_info *mtd,
+static int atmel_nand_write_oob_512(struct mtd_info *mtd,
 		struct nand_chip *chip, int page)
 {
 	int chunk = chip->ecc.bytes + chip->ecc.prepad + chip->ecc.postpad;
@@ -172,7 +172,7 @@ static int at91_nand_write_oob_512(struct mtd_info *mtd,
 /*
  * read oob for small pages
  */
-static int at91_nand_read_oob_512(struct mtd_info *mtd,
+static int atmel_nand_read_oob_512(struct mtd_info *mtd,
 		struct nand_chip *chip,	int page, int sndcmd)
 {
 	if (sndcmd) {
@@ -192,11 +192,11 @@ static int at91_nand_read_oob_512(struct mtd_info *mtd,
  * dat:        raw data (unused)
  * ecc_code:   buffer for ECC
  */
-static int at91_nand_calculate(struct mtd_info *mtd,
+static int atmel_nand_calculate(struct mtd_info *mtd,
 		const u_char *dat, unsigned char *ecc_code)
 {
 	struct nand_chip *nand_chip = mtd->priv;
-	struct at91_nand_host *host = nand_chip->priv;
+	struct atmel_nand_host *host = nand_chip->priv;
 	uint32_t *eccpos = nand_chip->ecc.layout->eccpos;
 	unsigned int ecc_value;
 
@@ -207,7 +207,7 @@ static int at91_nand_calculate(struct mtd_info *mtd,
 	ecc_code[eccpos[1]] = (ecc_value >> 8) & 0xFF;
 
 	/* get the last 2 ECC bytes */
-	ecc_value = ecc_readl(host->ecc, NPR) & AT91_ECC_NPARITY;
+	ecc_value = ecc_readl(host->ecc, NPR) & ATMEL_ECC_NPARITY;
 
 	ecc_code[eccpos[2]] = ecc_value & 0xFF;
 	ecc_code[eccpos[3]] = (ecc_value >> 8) & 0xFF;
@@ -222,7 +222,7 @@ static int at91_nand_calculate(struct mtd_info *mtd,
  * chip:       nand chip info structure
  * buf:        buffer to store read data
  */
-static int at91_nand_read_page(struct mtd_info *mtd,
+static int atmel_nand_read_page(struct mtd_info *mtd,
 		struct nand_chip *chip, uint8_t *buf)
 {
 	int eccsize = chip->ecc.size;
@@ -281,11 +281,11 @@ static int at91_nand_read_page(struct mtd_info *mtd,
  *
  * Detect and correct a 1 bit error for a page
  */
-static int at91_nand_correct(struct mtd_info *mtd, u_char *dat,
+static int atmel_nand_correct(struct mtd_info *mtd, u_char *dat,
 		u_char *read_ecc, u_char *isnull)
 {
 	struct nand_chip *nand_chip = mtd->priv;
-	struct at91_nand_host *host = nand_chip->priv;
+	struct atmel_nand_host *host = nand_chip->priv;
 	unsigned int ecc_status;
 	unsigned int ecc_word, ecc_bit;
 
@@ -293,43 +293,43 @@ static int at91_nand_correct(struct mtd_info *mtd, u_char *dat,
 	ecc_status = ecc_readl(host->ecc, SR);
 
 	/* if there's no error */
-	if (likely(!(ecc_status & AT91_ECC_RECERR)))
+	if (likely(!(ecc_status & ATMEL_ECC_RECERR)))
 		return 0;
 
 	/* get error bit offset (4 bits) */
-	ecc_bit = ecc_readl(host->ecc, PR) & AT91_ECC_BITADDR;
+	ecc_bit = ecc_readl(host->ecc, PR) & ATMEL_ECC_BITADDR;
 	/* get word address (12 bits) */
-	ecc_word = ecc_readl(host->ecc, PR) & AT91_ECC_WORDADDR;
+	ecc_word = ecc_readl(host->ecc, PR) & ATMEL_ECC_WORDADDR;
 	ecc_word >>= 4;
 
 	/* if there are multiple errors */
-	if (ecc_status & AT91_ECC_MULERR) {
+	if (ecc_status & ATMEL_ECC_MULERR) {
 		/* check if it is a freshly erased block
 		 * (filled with 0xff) */
-		if ((ecc_bit == AT91_ECC_BITADDR)
-				&& (ecc_word == (AT91_ECC_WORDADDR >> 4))) {
+		if ((ecc_bit == ATMEL_ECC_BITADDR)
+				&& (ecc_word == (ATMEL_ECC_WORDADDR >> 4))) {
 			/* the block has just been erased, return OK */
 			return 0;
 		}
 		/* it doesn't seems to be a freshly
 		 * erased block.
 		 * We can't correct so many errors */
-		dev_dbg(host->dev, "at91_nand : multiple errors detected."
+		dev_dbg(host->dev, "atmel_nand : multiple errors detected."
 				" Unable to correct.\n");
 		return -EIO;
 	}
 
 	/* if there's a single bit error : we can correct it */
-	if (ecc_status & AT91_ECC_ECCERR) {
+	if (ecc_status & ATMEL_ECC_ECCERR) {
 		/* there's nothing much to do here.
 		 * the bit error is on the ECC itself.
 		 */
-		dev_dbg(host->dev, "at91_nand : one bit error on ECC code."
+		dev_dbg(host->dev, "atmel_nand : one bit error on ECC code."
 				" Nothing to correct\n");
 		return 0;
 	}
 
-	dev_dbg(host->dev, "at91_nand : one bit error on data."
+	dev_dbg(host->dev, "atmel_nand : one bit error on data."
 			" (word offset in the page :"
 			" 0x%x bit offset : 0x%x)\n",
 			ecc_word, ecc_bit);
@@ -341,14 +341,14 @@ static int at91_nand_correct(struct mtd_info *mtd, u_char *dat,
 		/* 8 bits words */
 		dat[ecc_word] ^= (1 << ecc_bit);
 	}
-	dev_dbg(host->dev, "at91_nand : error corrected\n");
+	dev_dbg(host->dev, "atmel_nand : error corrected\n");
 	return 1;
 }
 
 /*
  * Enable HW ECC : unsused
  */
-static void at91_nand_hwctl(struct mtd_info *mtd, int mode) { ; }
+static void atmel_nand_hwctl(struct mtd_info *mtd, int mode) { ; }
 
 #ifdef CONFIG_MTD_PARTITIONS
 static const char *part_probes[] = { "cmdlinepart", NULL };
@@ -357,9 +357,9 @@ static const char *part_probes[] = { "cmdlinepart", NULL };
 /*
  * Probe for the NAND device.
  */
-static int __init at91_nand_probe(struct platform_device *pdev)
+static int __init atmel_nand_probe(struct platform_device *pdev)
 {
-	struct at91_nand_host *host;
+	struct atmel_nand_host *host;
 	struct mtd_info *mtd;
 	struct nand_chip *nand_chip;
 	struct resource *regs;
@@ -372,21 +372,21 @@ static int __init at91_nand_probe(struct platform_device *pdev)
 #endif
 
 	/* Allocate memory for the device structure (and zero it) */
-	host = kzalloc(sizeof(struct at91_nand_host), GFP_KERNEL);
+	host = kzalloc(sizeof(struct atmel_nand_host), GFP_KERNEL);
 	if (!host) {
-		printk(KERN_ERR "at91_nand: failed to allocate device structure.\n");
+		printk(KERN_ERR "atmel_nand: failed to allocate device structure.\n");
 		return -ENOMEM;
 	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem) {
-		printk(KERN_ERR "at91_nand: can't get I/O resource mem\n");
+		printk(KERN_ERR "atmel_nand: can't get I/O resource mem\n");
 		return -ENXIO;
 	}
 
 	host->io_base = ioremap(mem->start, mem->end - mem->start + 1);
 	if (host->io_base == NULL) {
-		printk(KERN_ERR "at91_nand: ioremap failed\n");
+		printk(KERN_ERR "atmel_nand: ioremap failed\n");
 		kfree(host);
 		return -EIO;
 	}
@@ -403,14 +403,14 @@ static int __init at91_nand_probe(struct platform_device *pdev)
 	/* Set address of NAND IO lines */
 	nand_chip->IO_ADDR_R = host->io_base;
 	nand_chip->IO_ADDR_W = host->io_base;
-	nand_chip->cmd_ctrl = at91_nand_cmd_ctrl;
+	nand_chip->cmd_ctrl = atmel_nand_cmd_ctrl;
 
 	if (host->board->rdy_pin)
-		nand_chip->dev_ready = at91_nand_device_ready;
+		nand_chip->dev_ready = atmel_nand_device_ready;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (!regs && hard_ecc) {
-		printk(KERN_ERR "at91_nand: can't get I/O resource "
+		printk(KERN_ERR "atmel_nand: can't get I/O resource "
 				"regs\nFalling back on software ECC\n");
 	}
 
@@ -420,15 +420,15 @@ static int __init at91_nand_probe(struct platform_device *pdev)
 	if (hard_ecc && regs) {
 		host->ecc = ioremap(regs->start, regs->end - regs->start + 1);
 		if (host->ecc == NULL) {
-			printk(KERN_ERR "at91_nand: ioremap failed\n");
+			printk(KERN_ERR "atmel_nand: ioremap failed\n");
 			res = -EIO;
 			goto err_ecc_ioremap;
 		}
 		nand_chip->ecc.mode = NAND_ECC_HW_SYNDROME;
-		nand_chip->ecc.calculate = at91_nand_calculate;
-		nand_chip->ecc.correct = at91_nand_correct;
-		nand_chip->ecc.hwctl = at91_nand_hwctl;
-		nand_chip->ecc.read_page = at91_nand_read_page;
+		nand_chip->ecc.calculate = atmel_nand_calculate;
+		nand_chip->ecc.correct = atmel_nand_correct;
+		nand_chip->ecc.hwctl = atmel_nand_hwctl;
+		nand_chip->ecc.read_page = atmel_nand_read_page;
 		nand_chip->ecc.bytes = 4;
 		nand_chip->ecc.prepad = 0;
 		nand_chip->ecc.postpad = 0;
@@ -440,7 +440,7 @@ static int __init at91_nand_probe(struct platform_device *pdev)
 		nand_chip->options |= NAND_BUSWIDTH_16;
 
 	platform_set_drvdata(pdev, host);
-	at91_nand_enable(host);
+	atmel_nand_enable(host);
 
 	if (host->board->det_pin) {
 		if (gpio_get_value(host->board->det_pin)) {
@@ -463,22 +463,22 @@ static int __init at91_nand_probe(struct platform_device *pdev)
 		/* set ECC page size and oob layout */
 		switch (mtd->writesize) {
 		case 512:
-			nand_chip->ecc.layout = &at91_oobinfo_small;
-			nand_chip->ecc.read_oob = at91_nand_read_oob_512;
-			nand_chip->ecc.write_oob = at91_nand_write_oob_512;
-			ecc_writel(host->ecc, MR, AT91_ECC_PAGESIZE_528);
+			nand_chip->ecc.layout = &atmel_oobinfo_small;
+			nand_chip->ecc.read_oob = atmel_nand_read_oob_512;
+			nand_chip->ecc.write_oob = atmel_nand_write_oob_512;
+			ecc_writel(host->ecc, MR, ATMEL_ECC_PAGESIZE_528);
 			break;
 		case 1024:
-			nand_chip->ecc.layout = &at91_oobinfo_large;
-			ecc_writel(host->ecc, MR, AT91_ECC_PAGESIZE_1056);
+			nand_chip->ecc.layout = &atmel_oobinfo_large;
+			ecc_writel(host->ecc, MR, ATMEL_ECC_PAGESIZE_1056);
 			break;
 		case 2048:
-			nand_chip->ecc.layout = &at91_oobinfo_large;
-			ecc_writel(host->ecc, MR, AT91_ECC_PAGESIZE_2112);
+			nand_chip->ecc.layout = &atmel_oobinfo_large;
+			ecc_writel(host->ecc, MR, ATMEL_ECC_PAGESIZE_2112);
 			break;
 		case 4096:
-			nand_chip->ecc.layout = &at91_oobinfo_large;
-			ecc_writel(host->ecc, MR, AT91_ECC_PAGESIZE_4224);
+			nand_chip->ecc.layout = &atmel_oobinfo_large;
+			ecc_writel(host->ecc, MR, ATMEL_ECC_PAGESIZE_4224);
 			break;
 		default:
 			/* page size not handled by HW ECC */
@@ -503,7 +503,7 @@ static int __init at91_nand_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_MTD_PARTITIONS
 #ifdef CONFIG_MTD_CMDLINE_PARTS
-	mtd->name = "at91_nand";
+	mtd->name = "atmel_nand";
 	num_partitions = parse_mtd_partitions(mtd, part_probes,
 					      &partitions, 0);
 #endif
@@ -512,7 +512,7 @@ static int __init at91_nand_probe(struct platform_device *pdev)
 							 &num_partitions);
 
 	if ((!partitions) || (num_partitions == 0)) {
-		printk(KERN_ERR "at91_nand: No parititions defined, or unsupported device.\n");
+		printk(KERN_ERR "atmel_nand: No parititions defined, or unsupported device.\n");
 		res = ENXIO;
 		goto release;
 	}
@@ -534,7 +534,7 @@ out:
 	iounmap(host->ecc);
 
 err_ecc_ioremap:
-	at91_nand_disable(host);
+	atmel_nand_disable(host);
 	platform_set_drvdata(pdev, NULL);
 	iounmap(host->io_base);
 	kfree(host);
@@ -544,14 +544,14 @@ err_ecc_ioremap:
 /*
  * Remove a NAND device.
  */
-static int __devexit at91_nand_remove(struct platform_device *pdev)
+static int __devexit atmel_nand_remove(struct platform_device *pdev)
 {
-	struct at91_nand_host *host = platform_get_drvdata(pdev);
+	struct atmel_nand_host *host = platform_get_drvdata(pdev);
 	struct mtd_info *mtd = &host->mtd;
 
 	nand_release(mtd);
 
-	at91_nand_disable(host);
+	atmel_nand_disable(host);
 
 	iounmap(host->io_base);
 	iounmap(host->ecc);
@@ -560,31 +560,31 @@ static int __devexit at91_nand_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver at91_nand_driver = {
-	.probe		= at91_nand_probe,
-	.remove		= at91_nand_remove,
+static struct platform_driver atmel_nand_driver = {
+	.probe		= atmel_nand_probe,
+	.remove		= atmel_nand_remove,
 	.driver		= {
-		.name	= "at91_nand",
+		.name	= "atmel_nand",
 		.owner	= THIS_MODULE,
 	},
 };
 
-static int __init at91_nand_init(void)
+static int __init atmel_nand_init(void)
 {
-	return platform_driver_register(&at91_nand_driver);
+	return platform_driver_register(&atmel_nand_driver);
 }
 
 
-static void __exit at91_nand_exit(void)
+static void __exit atmel_nand_exit(void)
 {
-	platform_driver_unregister(&at91_nand_driver);
+	platform_driver_unregister(&atmel_nand_driver);
 }
 
 
-module_init(at91_nand_init);
-module_exit(at91_nand_exit);
+module_init(atmel_nand_init);
+module_exit(atmel_nand_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rick Bronson");
 MODULE_DESCRIPTION("NAND/SmartMedia driver for AT91 / AVR32");
-MODULE_ALIAS("platform:at91_nand");
+MODULE_ALIAS("platform:atmel_nand");
diff --git a/drivers/mtd/nand/atmel_nand_ecc.h b/drivers/mtd/nand/atmel_nand_ecc.h
index 170db86..1ee7f99 100644
--- a/drivers/mtd/nand/atmel_nand_ecc.h
+++ b/drivers/mtd/nand/atmel_nand_ecc.h
@@ -11,26 +11,26 @@
 #ifndef ATMEL_NAND_ECC_H
 #define ATMEL_NAND_ECC_H
 
-#define AT91_ECC_CR		0x00			/* Control register */
-#define		AT91_ECC_RST		(1 << 0)		/* Reset parity */
+#define ATMEL_ECC_CR		0x00			/* Control register */
+#define		ATMEL_ECC_RST		(1 << 0)		/* Reset parity */
 
-#define AT91_ECC_MR		0x04			/* Mode register */
-#define		AT91_ECC_PAGESIZE	(3 << 0)		/* Page Size */
-#define			AT91_ECC_PAGESIZE_528		(0)
-#define			AT91_ECC_PAGESIZE_1056		(1)
-#define			AT91_ECC_PAGESIZE_2112		(2)
-#define			AT91_ECC_PAGESIZE_4224		(3)
+#define ATMEL_ECC_MR		0x04			/* Mode register */
+#define		ATMEL_ECC_PAGESIZE	(3 << 0)		/* Page Size */
+#define			ATMEL_ECC_PAGESIZE_528		(0)
+#define			ATMEL_ECC_PAGESIZE_1056		(1)
+#define			ATMEL_ECC_PAGESIZE_2112		(2)
+#define			ATMEL_ECC_PAGESIZE_4224		(3)
 
-#define AT91_ECC_SR		0x08			/* Status register */
-#define		AT91_ECC_RECERR		(1 << 0)		/* Recoverable Error */
-#define		AT91_ECC_ECCERR		(1 << 1)		/* ECC Single Bit Error */
-#define		AT91_ECC_MULERR		(1 << 2)		/* Multiple Errors */
+#define ATMEL_ECC_SR		0x08			/* Status register */
+#define		ATMEL_ECC_RECERR		(1 << 0)		/* Recoverable Error */
+#define		ATMEL_ECC_ECCERR		(1 << 1)		/* ECC Single Bit Error */
+#define		ATMEL_ECC_MULERR		(1 << 2)		/* Multiple Errors */
 
-#define AT91_ECC_PR		0x0c			/* Parity register */
-#define		AT91_ECC_BITADDR	(0xf << 0)		/* Bit Error Address */
-#define		AT91_ECC_WORDADDR	(0xfff << 4)		/* Word Error Address */
+#define ATMEL_ECC_PR		0x0c			/* Parity register */
+#define		ATMEL_ECC_BITADDR	(0xf << 0)		/* Bit Error Address */
+#define		ATMEL_ECC_WORDADDR	(0xfff << 4)		/* Word Error Address */
 
-#define AT91_ECC_NPR		0x10			/* NParity register */
-#define		AT91_ECC_NPARITY	(0xffff << 0)		/* NParity */
+#define ATMEL_ECC_NPR		0x10			/* NParity register */
+#define		ATMEL_ECC_NPARITY	(0xffff << 0)		/* NParity */
 
 #endif
diff --git a/include/asm-arm/arch-at91/board.h b/include/asm-arm/arch-at91/board.h
index dc189f0..6296922 100644
--- a/include/asm-arm/arch-at91/board.h
+++ b/include/asm-arm/arch-at91/board.h
@@ -85,7 +85,7 @@ struct at91_usbh_data {
 extern void __init at91_add_device_usbh(struct at91_usbh_data *data);
 
  /* NAND / SmartMedia */
-struct at91_nand_data {
+struct atmel_nand_data {
 	u8		enable_pin;	/* chip enable */
 	u8		det_pin;	/* card detect */
 	u8		rdy_pin;	/* ready/busy */
@@ -94,7 +94,7 @@ struct at91_nand_data {
 	u8		bus_width_16;	/* buswidth is 16 bit */
 	struct mtd_partition* (*partition_info)(int, int*);
 };
-extern void __init at91_add_device_nand(struct at91_nand_data *data);
+extern void __init at91_add_device_nand(struct atmel_nand_data *data);
 
  /* I2C*/
 extern void __init at91_add_device_i2c(struct i2c_board_info *devices, int nr_devices);
-- 
1.5.5.1

