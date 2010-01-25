Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022Ab0AYPhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0AYPhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 10:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589Ab0AYPhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 10:37:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53587 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab0AYPhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:37:38 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: trivial@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] imxfb: correct location of callbacks in suspend and resume
Date: Mon, 25 Jan 2010 16:37:34 +0100
Message-Id: <1264433854-878-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263226881-28008-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1263226881-28008-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe function passes a pointer to a struct fb_info to
platform_set_drvdata, so don't interpret the return value of
platform_get_drvdata as a pointer to struct imxfb_info.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/video/imxfb.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
index 66358fa..b4b6dec 100644
--- a/drivers/video/imxfb.c
+++ b/drivers/video/imxfb.c
@@ -593,7 +593,8 @@ static int imxfb_activate_var(struct fb_var_screeninfo *var, struct fb_info *inf
  */
 static int imxfb_suspend(struct platform_device *dev, pm_message_t state)
 {
-	struct imxfb_info *fbi = platform_get_drvdata(dev);
+	struct fb_info *info = platform_get_drvdata(dev);
+	struct imxfb_info *fbi = info->par;
 
 	pr_debug("%s\n", __func__);
 
@@ -603,7 +604,8 @@ static int imxfb_suspend(struct platform_device *dev, pm_message_t state)
 
 static int imxfb_resume(struct platform_device *dev)
 {
-	struct imxfb_info *fbi = platform_get_drvdata(dev);
+	struct fb_info *info = platform_get_drvdata(dev);
+	struct imxfb_info *fbi = info->par;
 
 	pr_debug("%s\n", __func__);
 
-- 
1.6.6

