Return-Path: <linux-kernel-owner+w=401wt.eu-S1759081AbYFFQMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081AbYFFQMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbYFFQMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:12:20 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39476 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbYFFQMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:12:19 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-mtd@lists.infradead.org, kernel@avr32linux.org
Cc: Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 1/8] at91_nand: Convert to generic GPIO API
Date: Fri,  6 Jun 2008 18:04:51 +0200
Message-Id: <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 06 Jun 2008 16:04:19.0092 (UTC) FILETIME=[FA064D40:01C8C7EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in using an AT91-specific GPIO API when the generic API works
just as well.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mtd/nand/at91_nand.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/at91_nand.c b/drivers/mtd/nand/at91_nand.c
index 0adb287..2dcaeea 100644
--- a/drivers/mtd/nand/at91_nand.c
+++ b/drivers/mtd/nand/at91_nand.c
@@ -31,12 +31,10 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 
+#include <asm/gpio.h>
 #include <asm/io.h>
-#include <asm/sizes.h>
 
-#include <asm/hardware.h>
 #include <asm/arch/board.h>
-#include <asm/arch/gpio.h>
 
 #ifdef CONFIG_MTD_NAND_AT91_ECC_HW
 #define hard_ecc	1
@@ -99,7 +97,7 @@ struct at91_nand_host {
 static void at91_nand_enable(struct at91_nand_host *host)
 {
 	if (host->board->enable_pin)
-		at91_set_gpio_value(host->board->enable_pin, 0);
+		gpio_set_value(host->board->enable_pin, 0);
 }
 
 /*
@@ -108,7 +106,7 @@ static void at91_nand_enable(struct at91_nand_host *host)
 static void at91_nand_disable(struct at91_nand_host *host)
 {
 	if (host->board->enable_pin)
-		at91_set_gpio_value(host->board->enable_pin, 1);
+		gpio_set_value(host->board->enable_pin, 1);
 }
 
 /*
@@ -142,7 +140,7 @@ static int at91_nand_device_ready(struct mtd_info *mtd)
 	struct nand_chip *nand_chip = mtd->priv;
 	struct at91_nand_host *host = nand_chip->priv;
 
-	return at91_get_gpio_value(host->board->rdy_pin);
+	return gpio_get_value(host->board->rdy_pin);
 }
 
 /*
@@ -447,7 +445,7 @@ static int __init at91_nand_probe(struct platform_device *pdev)
 	at91_nand_enable(host);
 
 	if (host->board->det_pin) {
-		if (at91_get_gpio_value(host->board->det_pin)) {
+		if (gpio_get_value(host->board->det_pin)) {
 			printk ("No SmartMedia card inserted.\n");
 			res = ENXIO;
 			goto out;
-- 
1.5.5.1

