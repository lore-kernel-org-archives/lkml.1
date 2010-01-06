Return-Path: <linux-kernel-owner+w=401wt.eu-S932422Ab0AFWeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab0AFWeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932327Ab0AFWea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:34:30 -0500
Received: from [206.15.93.42] ([206.15.93.42]:14606 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932264Ab0AFWe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:34:29 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] led-class.c: quiet boot messages
Date: Wed, 6 Jan 2010 15:34:55 -0700
Cc: rpurdie@rpsys.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001061534.55707.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

led-class.c: quiet boot messages

As each led device gets registered a kernel message gets printed. In
an embedded system with a number of leds this can produce a lot
of output that just looks like noise.

Change the message type to KERN_DEBUG since it might be useful
in the dmesg output "after" booting.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>

---

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 782f958..349e073 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -164,7 +164,7 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 	led_trigger_set_default(led_cdev);
 #endif
 
-	printk(KERN_INFO "Registered led device: %s\n",
+	printk(KERN_DEBUG "Registered led device: %s\n",
 			led_cdev->name);
 
 	return 0;
