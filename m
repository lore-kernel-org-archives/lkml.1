Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbZL1LGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbZL1LGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZL1LF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:05:58 -0500
Received: from smtp.nokia.com ([192.100.122.233]:61226 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZL1LFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:05:48 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 3/4] rtc: twl4030: move to request_threaded_irq
Date: Mon, 28 Dec 2009 13:02:51 +0200
Message-Id: <1261998172-29760-4-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
In-Reply-To: <1261998172-29760-1-git-send-email-felipe.balbi@nokia.com>
References: <1261998172-29760-1-git-send-email-felipe.balbi@nokia.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Patchwork-Id: 67253
X-OriginalArrivalTime: 28 Dec 2009 11:04:35.0240 (UTC) FILETIME=[8A45C280:01CA87AD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move to request_threaded_irq() on twl4030 children.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>

---

resending because it wasn't applied before

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
