Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbYLDWR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbYLDWR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYLDWRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:17:21 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:38746 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbYLDWRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:17:20 -0500
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Rodolfo Giometti <giometti@linux.it>
Date: Mon,  1 Dec 2008 15:28:17 +0100
Message-Id: <1228141697-20161-1-git-send-email-giometti@enneenne.com>
X-Mailer: git-send-email 1.5.4.3
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] leds ledtrig-timer: on deactivation hardware blinking should be disabled.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rodolfo Giometti <giometti@linux.it>

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/leds/ledtrig-timer.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index 5c99f4f..2f8d83f 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -203,6 +203,7 @@ err_out:
 static void timer_trig_deactivate(struct led_classdev *led_cdev)
 {
 	struct timer_trig_data *timer_data = led_cdev->trigger_data;
+	unsigned long on = 0, off = 0;
 
 	if (timer_data) {
 		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
@@ -210,6 +211,10 @@ static void timer_trig_deactivate(struct led_classdev *led_cdev)
 		del_timer_sync(&timer_data->timer);
 		kfree(timer_data);
 	}
+
+	/* If there is hardware support for blinking, stop it */
+	if (led_cdev->blink_set)
+		led_cdev->blink_set(led_cdev, &on, &off);
 }
 
 static struct led_trigger timer_led_trigger = {
-- 
1.5.4.3

