Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbXEIL7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbXEIL7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbXEIL7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:59:33 -0400
Received: from p2020-adsah02tachib-acca.tokyo.ocn.ne.jp ([219.161.11.20]:60858
	"EHLO eggplant.ddo.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbXEIL7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:59:32 -0400
Message-ID: <1657.192.168.1.10.1178711970.squirrel@eggplant.ddo.jp>
Date: Wed, 9 May 2007 20:59:30 +0900 (JST)
Subject: [PATCH 1/3] rtc:rtc-rs5c313.c : error and warning are fixed.
From: "kogiidena" <kogiidena@eggplant.ddo.jp>
To: linux-kernel@vger.kernel.org
Reply-To: kogiidena@eggplant.ddo.jp
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch is a patch that corrects the compile error and warning.
Please apply.

Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>
---
diff -urpN OLD/drivers/rtc/Kconfig NEW/drivers/rtc/Kconfig
--- OLD/drivers/rtc/Kconfig	2007-05-07 12:12:02.000000000 +0900
+++ NEW/drivers/rtc/Kconfig	2007-05-08 19:30:53.000000000 +0900
@@ -396,7 +396,7 @@ config RTC_DRV_BFIN

 config RTC_DRV_RS5C313
 	tristate "Ricoh RS5C313"
-	depends on RTC_CLASS && BROKEN
+	depends on RTC_CLASS && SH_LANDISK
 	help
 	  If you say yes here you get support for the Ricoh RS5C313 RTC chips.

diff -urpN OLD/drivers/rtc/rtc-rs5c313.c NEW/drivers/rtc/rtc-rs5c313.c
--- OLD/drivers/rtc/rtc-rs5c313.c	2007-05-07 12:12:02.000000000 +0900
+++ NEW/drivers/rtc/rtc-rs5c313.c	2007-05-08 19:36:51.000000000 +0900
@@ -126,7 +126,7 @@ static void rs5c313_write_data(unsigned
 static unsigned char rs5c313_read_data(void)
 {
 	int i;
-	unsigned char data;
+	unsigned char data = 0;

 	for (i = 0; i < 8; i++) {
 		ndelay(700);
@@ -194,7 +194,7 @@ static void rs5c313_write_reg(unsigned c
 	return;
 }

-static inline unsigned char rs5c313_read_cntreg(unsigned char addr)
+static inline unsigned char rs5c313_read_cntreg(void)
 {
 	return rs5c313_read_reg(RS5C313_ADDR_CNTREG);
 }
@@ -356,7 +356,7 @@ static int rs5c313_rtc_probe(struct plat

 	platform_set_drvdata(pdev, rtc);

-	return err;
+	return 0;
 }

 static int __devexit rs5c313_rtc_remove(struct platform_device *pdev)




