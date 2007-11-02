Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbXKBGZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbXKBGZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 02:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbXKBGYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 02:24:31 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:23837 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbXKBGY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 02:24:29 -0400
X-IronPort-AV: i="4.21,361,1188792000"; 
   d="scan'208"; a="55433965:sNHT25398072"
From: Bryan Wu <bryan.wu@analog.com>
To: khali@linux-fr.org, i2c@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 4/4] Blackfin I2C/TWI driver: add driver descriptions, versions and some module useful information
Date: Fri,  2 Nov 2007 14:24:24 +0800
Message-Id: <1193984664-10609-5-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193984664-10609-1-git-send-email-bryan.wu@analog.com>
References: <1193984664-10609-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 727625b..ae41c0b 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -37,6 +37,15 @@
 #include <asm/portmux.h>
 #include <asm/irq.h>
 
+#define DRV_NAME	"i2c-bfin-twi"
+#define DRV_AUTHOR	"Sonic Zhang, Bryan Wu"
+#define DRV_DESC	"Blackfin BF5xx on-chip I2C TWI Contoller Driver"
+#define DRV_VERSION	"1.8"
+
+MODULE_AUTHOR(DRV_AUTHOR);
+MODULE_DESCRIPTION(DRV_DESC);
+MODULE_LICENSE("GPL");
+
 #define POLL_TIMEOUT       (2 * HZ)
 
 /* SMBus mode*/
@@ -701,8 +710,8 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 	else
 		platform_set_drvdata(pdev, iface);
 
-	dev_info(&pdev->dev, "Blackfin I2C TWI controller, regs_base@%p\n",
-		iface->regs_base);
+	dev_info(&pdev->dev, "%s, Version %s, regs_base@%p\n",
+		DRV_DESC, DRV_VERSION, iface->regs_base);
 
 	return rc;
 
@@ -735,7 +744,7 @@ static struct platform_driver i2c_bfin_twi_driver = {
 	.suspend	= i2c_bfin_twi_suspend,
 	.resume		= i2c_bfin_twi_resume,
 	.driver		= {
-		.name	= "i2c-bfin-twi",
+		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
 	},
 };
@@ -750,9 +759,5 @@ static void __exit i2c_bfin_twi_exit(void)
 	platform_driver_unregister(&i2c_bfin_twi_driver);
 }
 
-MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
-MODULE_DESCRIPTION("I2C-Bus adapter routines for Blackfin TWI");
-MODULE_LICENSE("GPL");
-
 module_init(i2c_bfin_twi_init);
 module_exit(i2c_bfin_twi_exit);
-- 
1.5.3.4
