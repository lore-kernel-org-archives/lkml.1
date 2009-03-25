Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbZCYAej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbZCYAej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbZCYA3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:48 -0400
Received: from kroah.org ([198.145.64.141]:54072 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754323AbZCYA3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, a.zummo@towertech.it,
       rtc-linux@googlegroups.com, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/61] rtc: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:18 -0700
Message-Id: <1237940825-22904-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/rtc/rtc-at91sam9.c |    4 ++--
 drivers/rtc/rtc-omap.c     |    4 ++--
 drivers/rtc/rtc-twl4030.c  |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index d5e4e63..86c61f1 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -351,7 +351,7 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	/* register irq handler after we know what name we'll use */
 	ret = request_irq(AT91_ID_SYS, at91_rtc_interrupt,
 				IRQF_DISABLED | IRQF_SHARED,
-				rtc->rtcdev->dev.bus_id, rtc);
+				dev_name(&rtc->rtcdev->dev), rtc);
 	if (ret) {
 		dev_dbg(&pdev->dev, "can't share IRQ %d?\n", AT91_ID_SYS);
 		rtc_device_unregister(rtc->rtcdev);
@@ -366,7 +366,7 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 
 	if (gpbr_readl(rtc) == 0)
 		dev_warn(&pdev->dev, "%s: SET TIME!\n",
-				rtc->rtcdev->dev.bus_id);
+				dev_name(&rtc->rtcdev->dev));
 
 	return 0;
 
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 2cbeb07..bd1ce8e 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -377,13 +377,13 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 
 	/* handle periodic and alarm irqs */
 	if (request_irq(omap_rtc_timer, rtc_irq, IRQF_DISABLED,
-			rtc->dev.bus_id, rtc)) {
+			dev_name(&rtc->dev), rtc)) {
 		pr_debug("%s: RTC timer interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_timer);
 		goto fail0;
 	}
 	if (request_irq(omap_rtc_alarm, rtc_irq, IRQF_DISABLED,
-			rtc->dev.bus_id, rtc)) {
+			dev_name(&rtc->dev), rtc)) {
 		pr_debug("%s: RTC alarm interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_alarm);
 		goto fail1;
diff --git a/drivers/rtc/rtc-twl4030.c b/drivers/rtc/rtc-twl4030.c
index ad35f76..a6341e4 100644
--- a/drivers/rtc/rtc-twl4030.c
+++ b/drivers/rtc/rtc-twl4030.c
@@ -426,7 +426,7 @@ static int __devinit twl4030_rtc_probe(struct platform_device *pdev)
 
 	ret = request_irq(irq, twl4030_rtc_interrupt,
 				IRQF_TRIGGER_RISING,
-				rtc->dev.bus_id, rtc);
+				dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
 		goto out1;
-- 
1.6.2

