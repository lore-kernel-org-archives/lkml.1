Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbZCBOMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbZCBOMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 09:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZCBOMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 09:12:15 -0500
Received: from cathcart.site5.com ([74.54.107.137]:57545 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZCBOMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 09:12:14 -0500
Message-ID: <49ABE938.8040502@compulab.co.il>
Date: Mon, 02 Mar 2009 16:12:08 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: dmitry.torokhov@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-input <linux-input@vger.kernel.org>
Subject: [PATCH RESEND] Input: wm97xx: add BTN_TOUCH event to wm97xx to use
 it with Android
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Android expects BTN_TOUCH events when pen state changes. Add BTN_TOUCH
event reporting to allow use of wm97xx touchscreen controller with
Android devices.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

---
 drivers/input/touchscreen/wm97xx-core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index d15aa11..4551f88 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -409,6 +409,7 @@ static int wm97xx_read_samples(struct wm97xx *wm)
 			wm->pen_is_down = 0;
 			dev_dbg(wm->dev, "pen up\n");
 			input_report_abs(wm->input_dev, ABS_PRESSURE, 0);
+			input_report_key(wm->input_dev, BTN_TOUCH, 0);
 			input_sync(wm->input_dev);
 		} else if (!(rc & RC_AGAIN)) {
 			/* We need high frequency updates only while
@@ -433,6 +434,7 @@ static int wm97xx_read_samples(struct wm97xx *wm)
 		input_report_abs(wm->input_dev, ABS_X, data.x & 0xfff);
 		input_report_abs(wm->input_dev, ABS_Y, data.y & 0xfff);
 		input_report_abs(wm->input_dev, ABS_PRESSURE, data.p & 0xfff);
+		input_report_key(wm->input_dev, BTN_TOUCH, 1);
 		input_sync(wm->input_dev);
 		wm->pen_is_down = 1;
 		wm->ts_reader_interval = wm->ts_reader_min_interval;
@@ -629,9 +631,11 @@ static int wm97xx_probe(struct device *dev)
 	wm->input_dev->open = wm97xx_ts_input_open;
 	wm->input_dev->close = wm97xx_ts_input_close;
 	set_bit(EV_ABS, wm->input_dev->evbit);
+	set_bit(EV_KEY, wm->input_dev->evbit);
 	set_bit(ABS_X, wm->input_dev->absbit);
 	set_bit(ABS_Y, wm->input_dev->absbit);
 	set_bit(ABS_PRESSURE, wm->input_dev->absbit);
+	set_bit(BTN_TOUCH, wm->input_dev->keybit);
 	input_set_abs_params(wm->input_dev, ABS_X, abs_x[0], abs_x[1],
 			     abs_x[2], 0);
 	input_set_abs_params(wm->input_dev, ABS_Y, abs_y[0], abs_y[1],
-- 
1.5.6.4


-- 
Sincerely yours,
Mike.

