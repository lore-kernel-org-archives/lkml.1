Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbYFSLt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbYFSLt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 07:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbYFSLtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 07:49:16 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:58329 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbYFSLtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 07:49:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=rEdI/tj6K8x1ldoWI4lA+7J/XqOlYHHIyVkpFehJVyGj34EX1bqfktQCngZ9c0CW5A
         3uYDTwt78aGM3dzxweruP8JnSFqYO8fHozBgt21Sz0wRq8e6Ou6nRdThzK7veOadQVQ1
         f2IcNxlJJeWkI8M6l+1u5aO6q15omlYmb2aiI=
Date: Thu, 19 Jun 2008 15:48:47 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net
Subject: [PATCH] leds: make sure led->trigger is valid before calling
	trigger->activate
Message-ID: <20080619114847.GA13752@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/leds/led-triggers.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 0f242b3..f910eaf 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -111,16 +111,17 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
 			flags);
 		if (led_cdev->trigger->deactivate)
 			led_cdev->trigger->deactivate(led_cdev);
+		led_cdev->trigger = NULL;
 		led_set_brightness(led_cdev, LED_OFF);
 	}
 	if (trigger) {
 		write_lock_irqsave(&trigger->leddev_list_lock, flags);
 		list_add_tail(&led_cdev->trig_list, &trigger->led_cdevs);
 		write_unlock_irqrestore(&trigger->leddev_list_lock, flags);
+		led_cdev->trigger = trigger;
 		if (trigger->activate)
 			trigger->activate(led_cdev);
 	}
-	led_cdev->trigger = trigger;
 }
 EXPORT_SYMBOL_GPL(led_trigger_set);
 
-- 
1.5.5.3


-- 
With best wishes
Dmitry

