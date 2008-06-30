Return-Path: <linux-kernel-owner+w=401wt.eu-S1759924AbYF3JV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924AbYF3JV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYF3JVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:21:35 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62526 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330AbYF3JVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:21:33 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 4/8] rtc-at32ap700x: Enable wakeup
Date: Mon, 30 Jun 2008 11:21:12 +0200
Message-Id: <1214817676-30378-5-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214817676-30378-4-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214817676-30378-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-4-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 30 Jun 2008 09:21:07.0789 (UTC) FILETIME=[A0CC67D0:01C8DA92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call device_init_wakeup() to signal that the RTC is capable of waking
the system. This is needed for rtcwake to work.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
---
 drivers/rtc/rtc-at32ap700x.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index 2ef8cdf..90b9a65 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -265,6 +265,7 @@ static int __init at32_rtc_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, rtc);
+	device_init_wakeup(&pdev->dev, 1);
 
 	dev_info(&pdev->dev, "Atmel RTC for AT32AP700x at %08lx irq %ld\n",
 			(unsigned long)rtc->regs, rtc->irq);
@@ -284,6 +285,8 @@ static int __exit at32_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_at32ap700x *rtc = platform_get_drvdata(pdev);
 
+	device_init_wakeup(&pdev->dev, 0);
+
 	free_irq(rtc->irq, rtc);
 	iounmap(rtc->regs);
 	rtc_device_unregister(rtc->rtc);
-- 
1.5.5.4

