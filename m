Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbYHAUal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbYHAUal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755755AbYHAUae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:30:34 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:40127 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbYHAUae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:30:34 -0400
Date: Fri, 1 Aug 2008 22:30:09 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Richard Purdie <rpurdie@rpsys.net>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] leds: Avoid needless strlen() for attributes
Message-ID: <alpine.LNX.1.10.0808012226560.2294@titan.stealer.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.6
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Fri, 01 Aug 2008 20:30:32 +0000
	Bayes: 0.1323 Tokens: new, 189; hammy, 2; neutral, 2; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1323]
X-Spam-Signature: f0d40743b963f0535c951afaf9505143993ce27a
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for the additional call to strlen(), we can directly return the
value returned by sprintf(). We now return a length value that doesn't include
the final '\0', but user space shouldn't bother about it anyway.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/leds/led-class.c     |    5 +----
 drivers/leds/ledtrig-timer.c |    8 ++------
 2 files changed, 3 insertions(+), 10 deletions(-)

Patch is based on your current (024e8ac) leds git tree head.

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 559a408..1aa24d3 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -34,14 +34,11 @@ static ssize_t led_brightness_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	ssize_t ret = 0;
 
 	/* no lock needed for this */
 	led_update_brightness(led_cdev);
-	sprintf(buf, "%u\n", led_cdev->brightness);
-	ret = strlen(buf) + 1;
 
-	return ret;
+	return sprintf(buf, "%u\n", led_cdev->brightness);
 }
 
 static ssize_t led_brightness_store(struct device *dev,
diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index 5c99f4f..db68196 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -70,9 +70,7 @@ static ssize_t led_delay_on_show(struct device *dev,
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 
-	sprintf(buf, "%lu\n", timer_data->delay_on);
-
-	return strlen(buf) + 1;
+	return sprintf(buf, "%lu\n", timer_data->delay_on);
 }
 
 static ssize_t led_delay_on_store(struct device *dev,
@@ -116,9 +114,7 @@ static ssize_t led_delay_off_show(struct device *dev,
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 
-	sprintf(buf, "%lu\n", timer_data->delay_off);
-
-	return strlen(buf) + 1;
+	return sprintf(buf, "%lu\n", timer_data->delay_off);
 }
 
 static ssize_t led_delay_off_store(struct device *dev,
