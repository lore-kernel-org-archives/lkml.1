Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYF3Mfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYF3Mfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 08:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYF3Mfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 08:35:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47983 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752004AbYF3Mf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 08:35:29 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] WM9712: Warn if user attempts to use pressure measurement with 5 wire mode
Date: Mon, 30 Jun 2008 13:35:25 +0100
Message-Id: <1214829325-5414-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not supported by the hardware.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/input/touchscreen/wm9712.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/wm9712.c b/drivers/input/touchscreen/wm9712.c
index 0b6e4cf..4c5d85a 100644
--- a/drivers/input/touchscreen/wm9712.c
+++ b/drivers/input/touchscreen/wm9712.c
@@ -168,6 +168,18 @@ static void wm9712_phy_init(struct wm97xx *wm)
 			64000 / rpu);
 	}
 
+	/* WM9712 five wire */
+	if (five_wire) {
+		dig2 |= WM9712_45W;
+		dev_dbg(wm->dev, "setting 5-wire touchscreen mode.");
+
+		if (pil) {
+			dev_warn(wm->dev, "pressure measurement is not "
+				 "supported in 5-wire mode\n");
+			pil = 0;
+		}
+	}
+
 	/* touchpanel pressure current*/
 	if (pil == 2) {
 		dig2 |= WM9712_PIL;
@@ -179,12 +191,6 @@ static void wm9712_phy_init(struct wm97xx *wm)
 	if (!pil)
 		pressure = 0;
 
-	/* WM9712 five wire */
-	if (five_wire) {
-		dig2 |= WM9712_45W;
-		dev_dbg(wm->dev, "setting 5-wire touchscreen mode.");
-	}
-
 	/* polling mode sample settling delay */
 	if (delay < 0 || delay > 15) {
 		dev_dbg(wm->dev, "supplied delay out of range.");
-- 
1.5.6

