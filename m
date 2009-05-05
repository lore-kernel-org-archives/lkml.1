Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbZEEQgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbZEEQgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZEEQgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:36:19 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:61334 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019AbZEEQgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:36:18 -0400
Date: Wed, 06 May 2009 01:36:06 +0900 (JST)
Message-Id: <20090506.013606.92578713.anemo@mba.ocn.ne.jp>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH resend] rtc-tx4939: Drop IRQF_SHARED
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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



