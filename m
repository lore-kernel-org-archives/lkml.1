Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbZJGVIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbZJGVIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbZJGVI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:08:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35982 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZJGVI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:08:28 -0400
Date: Tue, 6 Oct 2009 21:54:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: dtor@mail.ru, dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: ads7846 touchscreen: fix pressure
Message-ID: <20091006195413.GA1469@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Zaurus, pressure is reported inverted -- the lighter the pressure,
the bigger numerical value. This should fix it.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- linux-rc/drivers/input.ofic/touchscreen/ads7846.c	2009-10-06 13:49:56.000000000 +0200
+++ linux-rc/drivers/input/touchscreen/ads7846.c	2009-10-06 21:18:25.000000000 +0200
@@ -608,12 +609,12 @@
 
 		input_report_abs(input, ABS_X, x);
 		input_report_abs(input, ABS_Y, y);
-		input_report_abs(input, ABS_PRESSURE, Rt);
+		input_report_abs(input, ABS_PRESSURE, ts->pressure_max-Rt);
 
 		input_sync(input);
 #ifdef VERBOSE
 		dev_dbg(&ts->spi->dev, "%4d/%4d/%4d\n", x, y, Rt);
 #endif
 	}
 
 	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
