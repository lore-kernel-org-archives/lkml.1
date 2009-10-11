Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZJKJFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZJKJFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZJKJFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:05:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56582 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbZJKJFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:05:34 -0400
Date: Sun, 11 Oct 2009 11:04:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: zaurus suspend saga: 2.6.32-rc3
Message-ID: <20091011090423.GB1414@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm using patch similar to this for debugging:

...and good news is that it blinks after pressing of power button.

...core > pm_test also works.

I also verified that end of pxa_pm_enter() is reached (with similar
blinking patch). End of corgi_pxa_pm_enter() seems to be reached, too.

Any ideas what to try next?
								Pavel

--- arm.ofic//mach-pxa/pm.c	2009-09-10 00:13:59.000000000 +0200
+++ arm/mach-pxa/pm.c	2009-10-07 14:21:21.000000000 +0200
@@ -14,7 +14,10 @@
 #include <linux/module.h>
 #include <linux/suspend.h>
 #include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
 
+#include <mach/spitz.h>
 #include <mach/pm.h>
 
 struct pxa_cpu_pm_fns *pxa_cpu_pm_fns;
@@ -41,6 +44,24 @@
 
 	/* *** go zzz *** */
 	pxa_cpu_pm_fns->enter(state);
+
+	gpio_set_value(SPITZ_GPIO_LED_GREEN, 0);
+	mdelay(100);
+	gpio_set_value(SPITZ_GPIO_LED_GREEN, 1);
+	mdelay(100);
+	gpio_set_value(SPITZ_GPIO_LED_GREEN, 0);
+	mdelay(100);
+	gpio_set_value(SPITZ_GPIO_LED_GREEN, 1);
+	mdelay(100);
+	gpio_set_value(SPITZ_GPIO_LED_GREEN, 0);
+	mdelay(100);
+	gpio_set_value(SPITZ_GPIO_LED_GREEN, 1);
+	mdelay(100);
+	gpio_set_value(SPITZ_GPIO_LED_GREEN, 0);
+	mdelay(100);
+	gpio_set_value(SPITZ_GPIO_LED_GREEN, 1);
+	mdelay(100);
+
 	cpu_init();
 
 	if (state != PM_SUSPEND_STANDBY) {

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
