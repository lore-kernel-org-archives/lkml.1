Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab0CAKxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:53:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54446 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0CAKxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:53:53 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Sascha Hauer <s.hauer@pengutronix.de>, Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH 2/6] input/mc13783-ts: Don't use deprecated mc13783 API calls
Date: Mon,  1 Mar 2010 11:53:41 +0100
Message-Id: <1267440825-14694-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1267440825-14694-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-input@vger.kernel.org
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mc13783_ackirq is deprecated, use the drop in replacement mc13783_irq_ack.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

note this obviously depends on patch 1/6.

Best regards
Uwe

 drivers/input/touchscreen/mc13783_ts.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13783_ts.c
index be115b3..be54fd6 100644
--- a/drivers/input/touchscreen/mc13783_ts.c
+++ b/drivers/input/touchscreen/mc13783_ts.c
@@ -44,7 +44,7 @@ static irqreturn_t mc13783_ts_handler(int irq, void *data)
 {
 	struct mc13783_ts_priv *priv = data;
 
-	mc13783_ackirq(priv->mc13783, irq);
+	mc13783_irq_ack(priv->mc13783, irq);
 
 	/*
 	 * Kick off reading coordinates. Note that if work happens already
@@ -135,7 +135,7 @@ static int mc13783_ts_open(struct input_dev *dev)
 
 	mc13783_lock(priv->mc13783);
 
-	mc13783_ackirq(priv->mc13783, MC13783_IRQ_TS);
+	mc13783_irq_ack(priv->mc13783, MC13783_IRQ_TS);
 
 	ret = mc13783_irq_request(priv->mc13783, MC13783_IRQ_TS,
 		mc13783_ts_handler, MC13783_TS_NAME, priv);
-- 
1.7.0

