Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbZJBJ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbZJBJ2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbZJBJ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:28:17 -0400
Received: from bamako.nerim.net ([62.4.17.28]:55416 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298AbZJBJ2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:28:17 -0400
Date: Fri, 2 Oct 2009 11:28:18 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: [PATCH] lcd: Fix wrong sizeof
Message-ID: <20091002112818.54428c49@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which is why I have always preferred sizeof(struct foo) over
sizeof(var).

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
Stable team, this one applies to 2.6.31, 2.6.30 and 2.6.27.

 drivers/video/backlight/lcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.32-rc1.orig/drivers/video/backlight/lcd.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.32-rc1/drivers/video/backlight/lcd.c	2009-10-02 10:18:49.000000000 +0200
@@ -56,7 +56,7 @@ static int fb_notifier_callback(struct n
 
 static int lcd_register_fb(struct lcd_device *ld)
 {
-	memset(&ld->fb_notif, 0, sizeof(&ld->fb_notif));
+	memset(&ld->fb_notif, 0, sizeof(ld->fb_notif));
 	ld->fb_notif.notifier_call = fb_notifier_callback;
 	return fb_register_client(&ld->fb_notif);
 }


-- 
Jean Delvare
