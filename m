Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbYDNOT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbYDNOT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760806AbYDNOSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:18:13 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:33512 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760064AbYDNOSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:18:12 -0400
Date: Mon, 14 Apr 2008 17:17:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] let RTC_DRV_PCF8583 depend on ARCH_RPC
Message-ID: <20080414141707.GG6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error on architectures without 
asm/mc146818rtc.h:

<--  snip  -->

...
  CC [M]  drivers/rtc/rtc-pcf8583.o
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/rtc/rtc-pcf8583.c:18:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mc146818rtc.h:16:59: error: asm/mc146818rtc.h: No such file or directory
make[3]: *** [drivers/rtc/rtc-pcf8583.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d2a133b4f0bebbbf2f4045a5503b82135da2c620 diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 9e7de63..d0d6c6e 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -213,6 +213,7 @@ config RTC_DRV_PCF8563
 
 config RTC_DRV_PCF8583
 	tristate "Philips PCF8583"
+	depends on ARCH_RPC
 	help
 	  If you say yes here you get support for the Philips PCF8583
 	  RTC chip found on Acorn RiscPCs. This driver supports the

