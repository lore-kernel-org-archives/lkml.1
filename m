Return-Path: <linux-kernel-owner+w=401wt.eu-S932839AbXAaD5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbXAaD5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932838AbXAaD5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:57:45 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2352 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932828AbXAaD5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:57:44 -0500
Message-Id: <20070131033759.798289135@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:11 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Subject: [PATCH 01/23] clocksource: drop clocksource-add-verification-watchdog-helper-fix.patch
Content-Disposition: inline; filename=drop-clocksource-add-verification-watchdog-helper-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Drop.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 kernel/time/clocksource.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

Index: linux-2.6.19/kernel/time/clocksource.c
===================================================================
--- linux-2.6.19.orig/kernel/time/clocksource.c
+++ linux-2.6.19/kernel/time/clocksource.c
@@ -28,7 +28,6 @@
 #include <linux/sysdev.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/tick.h>
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
@@ -107,16 +106,8 @@ static void clocksource_watchdog(unsigne
 		/* Initialized ? */
 		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG)) {
 			if ((cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
-			    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS)) {
+			    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS))
 				cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
-				/*
-				 * We just marked the clocksource as
-				 * highres-capable, notify the rest of the
-				 * system as well so that we transition
-				 * into high-res mode:
-				 */
-				tick_clock_notify();
-			}
 			cs->flags |= CLOCK_SOURCE_WATCHDOG;
 			cs->wd_last = csnow;
 		} else {

-- 
