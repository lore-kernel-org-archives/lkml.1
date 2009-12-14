Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZLNKcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZLNKcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbZLNKc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:32:29 -0500
Received: from smtp.nokia.com ([192.100.122.233]:30202 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZLNKc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:32:26 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Aaro Koskinen <aaro.koskinen@nokia.com>,
       David Brownell <david-b@pacbell.net>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@openedhand.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [RFC/PATCH 3/4] rtc: twl4030: move to request_threaded_irq
Date: Mon, 14 Dec 2009 12:30:53 +0200
Message-Id: <1260786654-13294-4-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
In-Reply-To: <20091212183410.GF3092@sirena.org.uk>
References: <20091212183410.GF3092@sirena.org.uk>
X-OriginalArrivalTime: 14 Dec 2009 10:31:36.0264 (UTC) FILETIME=[9CED7C80:01CA7CA8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move to request_threaded_irq() on twl4030 children.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/rtc/rtc-twl4030.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-twl4030.c b/drivers/rtc/rtc-twl4030.c
index 9c8c70c..46bc9c1 100644
--- a/drivers/rtc/rtc-twl4030.c
+++ b/drivers/rtc/rtc-twl4030.c
@@ -325,14 +325,6 @@ static irqreturn_t twl4030_rtc_interrupt(int irq, void *rtc)
 	int res;
 	u8 rd_reg;
 
-#ifdef CONFIG_LOCKDEP
-	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
-	 * we don't want and can't tolerate.  Although it might be
-	 * friendlier not to borrow this thread context...
-	 */
-	local_irq_enable();
-#endif
-
 	res = twl4030_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (res)
 		goto out;
@@ -424,7 +416,7 @@ static int __devinit twl4030_rtc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto out1;
 
-	ret = request_irq(irq, twl4030_rtc_interrupt,
+	ret = request_threaded_irq(irq, NULL, twl4030_rtc_interrupt,
 				IRQF_TRIGGER_RISING,
 				dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
-- 
1.6.6.rc0

