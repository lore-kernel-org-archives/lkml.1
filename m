Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbZDGN0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbZDGN0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZDGN0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:26:21 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:58592 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbZDGN0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:26:20 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] rtc-tx4939: Drop IRQF_SHARED
Date: Tue,  7 Apr 2009 22:26:24 +0900
Message-Id: <1239110785-7680-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQF_SHARED should not be used with IRQF_DISABLED.  This RTC have a
dedicated irq line to SoC's internal interrupt controller so there is
no reason to use IRQF_SHARED.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/rtc/rtc-tx4939.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index 4ee4857..4a6ed11 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -261,10 +261,8 @@ static int __init tx4939_rtc_probe(struct platform_device *pdev)
 
 	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
 	if (devm_request_irq(&pdev->dev, irq, tx4939_rtc_interrupt,
-			     IRQF_DISABLED | IRQF_SHARED,
-			     pdev->name, &pdev->dev) < 0) {
+			     IRQF_DISABLED, pdev->name, &pdev->dev) < 0)
 		return -EBUSY;
-	}
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 				  &tx4939_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
-- 
1.5.6.3

