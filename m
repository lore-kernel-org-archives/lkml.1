Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbZJUH4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbZJUH4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 03:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZJUH4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 03:56:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35667 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZJUH4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 03:56:12 -0400
Date: Mon, 19 Oct 2009 23:37:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, Andrew Morton <akpm@osdl.org>
Cc: lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: spitz backlight: fix brightness limiting
Message-ID: <20091019213751.GC1482@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On spitz (& similar) machines, if battery is running low, backlight
needs to be limited to lower step. Unfortunately, current code uses &=
for limiting, turning backlight off completely for some backlight
settings. Fix that.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- linux-rc/drivers/video/backlight/corgi_lcd.c	2009-10-18 18:11:36.000000000 +0200
+++ linux-rc/drivers/video/backlight/corgi_lcd.c	2009-10-16 02:10:13.000000000 +0200
@@ -433,8 +434,9 @@
 
 	if (corgibl_flags & CORGIBL_SUSPENDED)
 		intensity = 0;
-	if (corgibl_flags & CORGIBL_BATTLOW)
-		intensity &= lcd->limit_mask;
+
+	if ((corgibl_flags & CORGIBL_BATTLOW) && intensity > lcd->limit_mask)
+		intensity = lcd->limit_mask;
 
 	return corgi_bl_set_intensity(lcd, intensity);
 }


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
