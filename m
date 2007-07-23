Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbXGWMDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbXGWMDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbXGWMDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:03:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbXGWMDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:03:42 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Richard Purdie <rpurdie@rpsys.net>
Subject: [FIX] struct led_classdev conversion compile fallout
Date: Mon, 23 Jul 2007 14:03:05 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231403.06015.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f8a7c6fe switched from a struct class_device to a struct device in 
struct led_classdev. Need to adjust drivers/misc/asus-laptop.c as well.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

diff --git a/drivers/misc/asus-laptop.c b/drivers/misc/asus-laptop.c
index f753060..2fdee5b 100644
--- a/drivers/misc/asus-laptop.c
+++ b/drivers/misc/asus-laptop.c
@@ -1067,8 +1067,8 @@ static void asus_backlight_exit(void)
 }
 
 #define  ASUS_LED_UNREGISTER(object)				\
-	if(object##_led.class_dev				\
-	   && !IS_ERR(object##_led.class_dev))			\
+	if(object##_led.dev					\
+	   && !IS_ERR(object##_led.dev))			\
 		led_classdev_unregister(&object##_led)
 
 static void asus_led_exit(void)
