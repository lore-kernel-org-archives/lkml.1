Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbZDFQu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbZDFQu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZDFQub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:50:31 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:51835 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbZDFQua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:50:30 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] rtc-tx4939: Drop IRQF_SHARED
Date: Tue,  7 Apr 2009 01:50:33 +0900
Message-Id: <1239036633-10032-3-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQF_SHARED should be used with IRQF_DISABLED.  This RTC have dedicated
irq line so there is no reason to use IRQF_SHARED.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/rtc/rtc-tx4939.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index 4ee4857..69085d9 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -261,7 +261,7 @@ static int __init tx4939_rtc_probe(struct platform_device *pdev)
 
 	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
 	if (devm_request_irq(&pdev->dev, irq, tx4939_rtc_interrupt,
-			     IRQF_DISABLED | IRQF_SHARED,
+			     IRQF_DISABLED,
 			     pdev->name, &pdev->dev) < 0) {
 		return -EBUSY;
 	}
-- 
1.5.6.3

