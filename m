Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbZKUStw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbZKUStw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 13:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbZKUStv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 13:49:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42291 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZKUStt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 13:49:49 -0500
Date: Sat, 21 Nov 2009 19:49:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: Fix backlight limiting
Message-ID: <20091121184947.GA2349@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have my trees quite modified in that area, testers welcome.

---

This should fix backlight limiting on 2.6.32-rc... 

Signed-off-by: Pavel Machek <pavel@ucw.cz>

Binary files arm.middle/mach-pxa/built-in.o and arm/mach-pxa/built-in.o differ
diff -ur arm.middle/mach-pxa/sharpsl_pm.c arm/mach-pxa/sharpsl_pm.c
--- a/arch/arm/mach-pxa/sharpsl_pm.c	2009-11-21 11:06:45.000000000 +0100
+++ b/arch/arm/mach-pxa/sharpsl_pm.c	2009-11-21 11:09:57.000000000 +0100
@@ -179,7 +179,6 @@
 	dev_dbg(sharpsl_pm.dev, "Battery: voltage: %d, status: %d, percentage: %d, time: %ld\n", voltage,
 			sharpsl_pm.battstat.mainbat_status, sharpsl_pm.battstat.mainbat_percent, jiffies);
 
-#ifdef CONFIG_BACKLIGHT_CORGI
 	/* If battery is low. limit backlight intensity to save power. */
 	if ((sharpsl_pm.battstat.ac_status != APM_AC_ONLINE)
 	    && ((sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_LOW)
@@ -192,7 +191,6 @@
 		sharpsl_pm.machinfo->backlight_limit(0);
 		sharpsl_pm.flags &= ~SHARPSL_BL_LIMIT;
 	}
-#endif
 
 	/* Suspend if critical battery level */
 	if ((sharpsl_pm.battstat.ac_status != APM_AC_ONLINE)


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
