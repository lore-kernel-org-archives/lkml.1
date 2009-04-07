Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZDGN0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZDGN0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZDGN0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:26:21 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:58607 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZDGN0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:26:20 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] rtc-ds1553: Drop IRQF_SHARED
Date: Tue,  7 Apr 2009 22:26:25 +0900
Message-Id: <1239110785-7680-2-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQF_SHARED should not be used with IRQF_DISABLED.
There is no in-tree user of this driver and only out-of-tree user
I know uses a dedicated irq line for this RTC.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/rtc/rtc-ds1553.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index 38d472b..7172885 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -329,8 +329,7 @@ static int __devinit ds1553_rtc_probe(struct platform_device *pdev)
 	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (request_irq(pdata->irq, ds1553_rtc_interrupt,
-				IRQF_DISABLED | IRQF_SHARED,
-				pdev->name, pdev) < 0) {
+				IRQF_DISABLED, pdev->name, pdev) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
 			pdata->irq = 0;
 		}
-- 
1.5.6.3

