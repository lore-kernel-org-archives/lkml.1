Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbZEEQhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbZEEQhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbZEEQgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:36:42 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:62874 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbZEEQgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:36:40 -0400
Date: Wed, 06 May 2009 01:36:29 +0900 (JST)
Message-Id: <20090506.013629.205313126.anemo@mba.ocn.ne.jp>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH resend] rtc-ds1553: Drop IRQF_SHARED
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



