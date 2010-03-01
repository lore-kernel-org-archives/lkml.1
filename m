Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab0CAKyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:54:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54452 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab0CAKxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:53:55 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Valentin Longchamp <valentin.longchamp@epfl.ch>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/6] rtc/mc13783: Don't use deprecated mc13783 API calls
Date: Mon,  1 Mar 2010 11:53:42 +0100
Message-Id: <1267440825-14694-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: rtc-linux@googlegroups.com
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mc13783_ackirq, mc13783_unmask and mc13783_mask are deprecated, use the
drop in replacements with the nicer names.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

note this obviously depends on patch 1/6.

Best regards
Uwe

 drivers/rtc/rtc-mc13783.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-mc13783.c b/drivers/rtc/rtc-mc13783.c
index 850f983..0a978a0 100644
--- a/drivers/rtc/rtc-mc13783.c
+++ b/drivers/rtc/rtc-mc13783.c
@@ -101,11 +101,11 @@ static int mc13783_rtc_set_mmss(struct device *dev, unsigned long secs)
 	if (unlikely(ret))
 		goto out;
 
-	ret = mc13783_ackirq(priv->mc13783, MC13783_IRQ_RTCRST);
+	ret = mc13783_irq_ack(priv->mc13783, MC13783_IRQ_RTCRST);
 	if (unlikely(ret))
 		goto out;
 
-	ret = mc13783_unmask(priv->mc13783, MC13783_IRQ_RTCRST);
+	ret = mc13783_irq_unmask(priv->mc13783, MC13783_IRQ_RTCRST);
 out:
 	priv->valid = !ret;
 
@@ -123,7 +123,7 @@ static irqreturn_t mc13783_rtc_update_handler(int irq, void *dev)
 
 	rtc_update_irq(priv->rtc, 1, RTC_IRQF | RTC_UF);
 
-	mc13783_ackirq(mc13783, irq);
+	mc13783_irq_ack(mc13783, irq);
 
 	return IRQ_HANDLED;
 }
@@ -138,7 +138,7 @@ static int mc13783_rtc_update_irq_enable(struct device *dev,
 	if (!priv->valid)
 		goto out;
 
-	ret = (enabled ? mc13783_unmask : mc13783_mask)(priv->mc13783,
+	ret = (enabled ? mc13783_irq_unmask : mc13783_irq_mask)(priv->mc13783,
 			MC13783_IRQ_1HZ);
 out:
 	mc13783_unlock(priv->mc13783);
@@ -160,7 +160,7 @@ static irqreturn_t mc13783_rtc_reset_handler(int irq, void *dev)
 	dev_dbg(&priv->rtc->dev, "RTCRST\n");
 	priv->valid = 0;
 
-	mc13783_mask(mc13783, irq);
+	mc13783_irq_mask(mc13783, irq);
 
 	return IRQ_HANDLED;
 }
-- 
1.7.0

