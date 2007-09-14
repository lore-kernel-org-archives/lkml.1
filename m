Return-Path: <linux-kernel-owner+w=401wt.eu-S934192AbXINQRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192AbXINQRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759377AbXINQRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:17:05 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:60547 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233AbXINQRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:17:04 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2007 12:17:04 EDT
Date: Sat, 15 Sep 2007 01:18:34 +0900 (JST)
Message-Id: <20070915.011834.03976911.anemo@mba.ocn.ne.jp>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [PATCH] rtc: rtc-ds1553.c should use resource_size_t for base
 address
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the rtc driver, rtc-ds1552.c uses an unsigned long to store
the base mmio address of the NVRAM/RTC.  This breaks on 32-bit systems
with larger physical addresses.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index 46da571..5ab3492 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -61,7 +61,7 @@
 struct rtc_plat_data {
 	struct rtc_device *rtc;
 	void __iomem *ioaddr;
-	unsigned long baseaddr;
+	resource_size_t baseaddr;
 	unsigned long last_jiffies;
 	int irq;
 	unsigned int irqen;
