Return-Path: <linux-kernel-owner+w=401wt.eu-S1760945AbZEGBNC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945AbZEGBNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 21:13:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZEGBMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 21:12:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59463 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbZEGBMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 21:12:51 -0400
Date: Thu, 07 May 2009 10:12:40 +0900
From: Kim Kyuwon <q1.kim@samsung.com>
Subject: [PATCH] rtc: rtc-twl4030 don't mask alarm interrupts on suspend
To: LKML <linux-kernel@vger.kernel.org>
Cc: rtc-linux@googlegroups.com, OMAP <linux-omap@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Kyungmin Park <kyungmin.park@samsung.com>, p_gortmaker@yahoo.com,
       a.zummo@towertech.it
Message-id: <4A023588.8080308@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
X-OriginalArrivalTime: 07 May 2009 01:12:42.0012 (UTC)
 FILETIME=[EBA9F5C0:01C9CEB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This patch was originally sent to linux-omap mailing list.
(Please refer to http://markmail.org/thread/o643d7w224zo3i7n)

David Brownell said, if I've tested this:

 Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Of course, I've tested.

Regards,
Kyuwon
--
From: Kim Kyuwon <q1.kim@samsung.com>
Subject: [PATCH] rtc: rtc-twl4030 don't mask alarm interrupts on suspend

This patch enables the alarm interrupt of TWL4030 RTC to wake up the
system from suspend. You can test this patch with following command.

# echo +10 > /sys/class/rtc/rtc0/wakealarm; echo mem > /sys/power/state;

Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
---
 drivers/rtc/rtc-twl4030.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-twl4030.c b/drivers/rtc/rtc-twl4030.c
index ad35f76..c185939 100644
--- a/drivers/rtc/rtc-twl4030.c
+++ b/drivers/rtc/rtc-twl4030.c
@@ -495,9 +495,7 @@ static int twl4030_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	irqstat = rtc_irq_bits;
 
-	/* REVISIT alarm may need to wake us from sleep */
-	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M |
-			 BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
 	return 0;
 }
 
-- 
1.5.2.5
