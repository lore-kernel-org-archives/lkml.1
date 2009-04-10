Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZDJJ73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZDJJ73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZDJJ7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:59:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:46275 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZDJJ7S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:59:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=gjBZBZkJ0sWtlQAGB5TIpoEiJ/ZQNocT6z6EYrD4+urU5g+w8tN0M9IZ0V5aHJ8SMg
         aAgcdAwTtgwyO0DKfwVTyseRv7Rv/1rKSzkYQsj6azQdSGVED4MQLt7DaiBxzgPGhfKL
         Yyrsj2VXcimlyO1/3eih4EOM93agwRbjBtLtM=
MIME-Version: 1.0
From: Kim Kyuwon <chammoru@gmail.com>
Date: Fri, 10 Apr 2009 18:59:02 +0900
Message-ID: <4d34a0a70904100259w3a21e45ex1bf51c3faa05477@mail.gmail.com>
Subject: [PATCH 1/3] leds: fix led-bd2802 errors while resuming
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       =?EUC-KR?B?udqw5rnO?= <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LED_CORE_SUSPENDRESUME flag is not needed in the bd2802 driver,
because all works for suspend/resume is done in bd2802_suspend and
bd2802_suspend functions.
And this patch allows bd2802 to be configured again when it resumes
from suspend.

Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
---
 drivers/leds/leds-bd2802.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 4149ecb..6832b9f 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -538,7 +538,6 @@ static int bd2802_register_led_classdev(struct
bd2802_led *led)
 	led->cdev_led1r.brightness = LED_OFF;
 	led->cdev_led1r.brightness_set = bd2802_set_led1r_brightness;
 	led->cdev_led1r.blink_set = bd2802_set_led1r_blink;
-	led->cdev_led1r.flags |= LED_CORE_SUSPENDRESUME;

 	ret = led_classdev_register(&led->client->dev, &led->cdev_led1r);
 	if (ret < 0) {
@@ -551,7 +550,6 @@ static int bd2802_register_led_classdev(struct
bd2802_led *led)
 	led->cdev_led1g.brightness = LED_OFF;
 	led->cdev_led1g.brightness_set = bd2802_set_led1g_brightness;
 	led->cdev_led1g.blink_set = bd2802_set_led1g_blink;
-	led->cdev_led1g.flags |= LED_CORE_SUSPENDRESUME;

 	ret = led_classdev_register(&led->client->dev, &led->cdev_led1g);
 	if (ret < 0) {
@@ -564,7 +562,6 @@ static int bd2802_register_led_classdev(struct
bd2802_led *led)
 	led->cdev_led1b.brightness = LED_OFF;
 	led->cdev_led1b.brightness_set = bd2802_set_led1b_brightness;
 	led->cdev_led1b.blink_set = bd2802_set_led1b_blink;
-	led->cdev_led1b.flags |= LED_CORE_SUSPENDRESUME;

 	ret = led_classdev_register(&led->client->dev, &led->cdev_led1b);
 	if (ret < 0) {
@@ -577,7 +574,6 @@ static int bd2802_register_led_classdev(struct
bd2802_led *led)
 	led->cdev_led2r.brightness = LED_OFF;
 	led->cdev_led2r.brightness_set = bd2802_set_led2r_brightness;
 	led->cdev_led2r.blink_set = bd2802_set_led2r_blink;
-	led->cdev_led2r.flags |= LED_CORE_SUSPENDRESUME;

 	ret = led_classdev_register(&led->client->dev, &led->cdev_led2r);
 	if (ret < 0) {
@@ -590,7 +586,6 @@ static int bd2802_register_led_classdev(struct
bd2802_led *led)
 	led->cdev_led2g.brightness = LED_OFF;
 	led->cdev_led2g.brightness_set = bd2802_set_led2g_brightness;
 	led->cdev_led2g.blink_set = bd2802_set_led2g_blink;
-	led->cdev_led2g.flags |= LED_CORE_SUSPENDRESUME;

 	ret = led_classdev_register(&led->client->dev, &led->cdev_led2g);
 	if (ret < 0) {
@@ -723,8 +718,7 @@ static int bd2802_resume(struct i2c_client *client)
 	struct bd2802_led *led = i2c_get_clientdata(client);

 	if (!bd2802_is_all_off(led) || led->adf_on) {
-		gpio_set_value(led->pdata->reset_gpio, 1);
-		udelay(100);
+		bd2802_reset_cancel(led);
 		bd2802_restore_state(led);
 	}

-- 
1.5.2.5


-- 
Kyuwon (±Ô¿ø)
