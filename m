Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbYEIWMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbYEIWMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYEIWMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:12:40 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63216 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756032AbYEIWMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:12:39 -0400
Date: Fri, 9 May 2008 23:12:05 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Alexander Bigga <ab@mycable.de>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Wim Van Sebroeck <wim@iguana.be>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] RTC/watchdog: M41T80: Fix a potential use of unitialized
 data
Message-ID: <Pine.LNX.4.55.0805092303570.10552@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Watchdog handlers within the driver make use of "save_client" -- make
sure it has been initalized before the handlers are registered.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 It should be obvious.  Please apply.

  Maciej

patch-2.6.26-rc1-20080505-m41t80-save_client-14
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c
--- linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c	2008-05-05 02:55:40.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c	2008-05-09 22:00:13.000000000 +0000
@@ -803,6 +803,7 @@ static int m41t80_probe(struct i2c_clien
 
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
 	if (clientdata->features & M41T80_FEATURE_HT) {
+		save_client = client;
 		rc = misc_register(&wdt_dev);
 		if (rc)
 			goto exit;
@@ -811,7 +812,6 @@ static int m41t80_probe(struct i2c_clien
 			misc_deregister(&wdt_dev);
 			goto exit;
 		}
-		save_client = client;
 	}
 #endif
 	return 0;
