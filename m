Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZCBLle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZCBLle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 06:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZCBLlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 06:41:09 -0500
Received: from cathcart.site5.com ([74.54.107.137]:56350 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbZCBLlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 06:41:07 -0500
From: Mike Rapoport <mike@compulab.co.il>
To: alessandro.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org, raph@8d.com,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] rtc-v3020: coding style cleanup
Date: Mon,  2 Mar 2009 13:40:56 +0200
Message-Id: <cdee64e76c2e293c33ac3ea04964925373dc717f.1235400430.git.mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <cover.1235400430.git.mike@compulab.co.il>
References: <cover.1235400430.git.mike@compulab.co.il>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/rtc/rtc-v3020.c |   40 ++++++++++++++++++----------------------
 1 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
index 14d4f03..66955cc 100644
--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -28,7 +28,7 @@
 #include <linux/rtc-v3020.h>
 #include <linux/delay.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 
 #undef DEBUG
 
@@ -63,7 +63,7 @@ static void v3020_set_reg(struct v3020 *chip, unsigned char address,
 
 static unsigned char v3020_get_reg(struct v3020 *chip, unsigned char address)
 {
-	unsigned int data=0;
+	unsigned int data = 0;
 	int i;
 
 	for (i = 0; i < 4; i++) {
@@ -106,16 +106,14 @@ static int v3020_read_time(struct device *dev, struct rtc_time *dt)
 	tmp = v3020_get_reg(chip, V3020_YEAR);
 	dt->tm_year = bcd2bin(tmp)+100;
 
-#ifdef DEBUG
-	printk("\n%s : Read RTC values\n",__func__);
-	printk("tm_hour: %i\n",dt->tm_hour);
-	printk("tm_min : %i\n",dt->tm_min);
-	printk("tm_sec : %i\n",dt->tm_sec);
-	printk("tm_year: %i\n",dt->tm_year);
-	printk("tm_mon : %i\n",dt->tm_mon);
-	printk("tm_mday: %i\n",dt->tm_mday);
-	printk("tm_wday: %i\n",dt->tm_wday);
-#endif
+	dev_dbg(dev, "\n%s : Read RTC values\n", __func__);
+	dev_dbg(dev, "tm_hour: %i\n", dt->tm_hour);
+	dev_dbg(dev, "tm_min : %i\n", dt->tm_min);
+	dev_dbg(dev, "tm_sec : %i\n", dt->tm_sec);
+	dev_dbg(dev, "tm_year: %i\n", dt->tm_year);
+	dev_dbg(dev, "tm_mon : %i\n", dt->tm_mon);
+	dev_dbg(dev, "tm_mday: %i\n", dt->tm_mday);
+	dev_dbg(dev, "tm_wday: %i\n", dt->tm_wday);
 
 	return 0;
 }
@@ -125,15 +123,13 @@ static int v3020_set_time(struct device *dev, struct rtc_time *dt)
 {
 	struct v3020 *chip = dev_get_drvdata(dev);
 
-#ifdef DEBUG
-	printk("\n%s : Setting RTC values\n",__func__);
-	printk("tm_sec : %i\n",dt->tm_sec);
-	printk("tm_min : %i\n",dt->tm_min);
-	printk("tm_hour: %i\n",dt->tm_hour);
-	printk("tm_mday: %i\n",dt->tm_mday);
-	printk("tm_wday: %i\n",dt->tm_wday);
-	printk("tm_year: %i\n",dt->tm_year);
-#endif
+	dev_dbg(dev, "\n%s : Setting RTC values\n", __func__);
+	dev_dbg(dev, "tm_sec : %i\n", dt->tm_sec);
+	dev_dbg(dev, "tm_min : %i\n", dt->tm_min);
+	dev_dbg(dev, "tm_hour: %i\n", dt->tm_hour);
+	dev_dbg(dev, "tm_mday: %i\n", dt->tm_mday);
+	dev_dbg(dev, "tm_wday: %i\n", dt->tm_wday);
+	dev_dbg(dev, "tm_year: %i\n", dt->tm_year);
 
 	/* Write all the values to ram... */
 	v3020_set_reg(chip, V3020_SECONDS, 	bin2bcd(dt->tm_sec));
@@ -191,7 +187,7 @@ static int rtc_probe(struct platform_device *pdev)
 	/* Test chip by doing a write/read sequence
 	 * to the chip ram */
 	v3020_set_reg(chip, V3020_SECONDS, 0x33);
-	if(v3020_get_reg(chip, V3020_SECONDS) != 0x33) {
+	if (v3020_get_reg(chip, V3020_SECONDS) != 0x33) {
 		retval = -ENODEV;
 		goto err_io;
 	}
-- 
1.5.6.4

