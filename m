Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734AbYKMO6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbYKMO6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYKMO5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:57:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39984 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752291AbYKMO5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:57:52 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Richard Purdie <rpurdie@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] leds: Fix locking for WM8350
Date: Thu, 13 Nov 2008 14:57:49 +0000
Message-Id: <1226588269-17642-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LED API functions aren't allowed to sleep so we can't take a lock when
setting the brightness of the LED.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Sorry, I managed to drop this fix when moving the driver over to
mainline for submission.  I'll roll it into the original patch in any
future submissions.

 drivers/leds/leds-wm8350.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-wm8350.c b/drivers/leds/leds-wm8350.c
index f3e5af3..283625c 100644
--- a/drivers/leds/leds-wm8350.c
+++ b/drivers/leds/leds-wm8350.c
@@ -170,10 +170,7 @@ static void wm8350_led_set(struct led_classdev *led_cdev,
 {
 	struct wm8350_led *led = to_wm8350_led(led_cdev);
 
-	mutex_lock(&led->mutex);
 	led->value = value;
-	mutex_unlock(&led->mutex);
-
 	schedule_work(&led->work);
 }
 
-- 
1.5.6.5

