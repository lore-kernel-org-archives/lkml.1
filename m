Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab0BDRaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:30:19 -0500
Received: from kroah.org ([198.145.64.141]:34808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933293Ab0BDRWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:06 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:13 2010
Message-Id: <20100204171512.656175088@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, gregkh@suse.de,
       tglx@linutronix.de
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [43/74] clocksource: fix compilation if no GENERIC_TIME
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit a362c638bdf052bf424bce7645d39b101090f6ba upstream

Commit a9238ce3bb0fda6e760780b702c6cbd3793087d3 broke compilation on
platforms that do not implement GENERIC_TIME (e.g. iop32x):

  kernel/time/clocksource.c: In function 'clocksource_register':
  kernel/time/clocksource.c:556: error: implicit declaration of function 'clocksource_max_deferment'

Provide the implementation of clocksource_max_deferment() also for
such platforms.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/clocksource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -413,8 +413,6 @@ void clocksource_touch_watchdog(void)
 	clocksource_resume_watchdog();
 }
 
-#ifdef CONFIG_GENERIC_TIME
-
 /**
  * clocksource_max_deferment - Returns max time the clocksource can be deferred
  * @cs:         Pointer to clocksource
@@ -456,6 +454,8 @@ static u64 clocksource_max_deferment(str
 	return max_nsecs - (max_nsecs >> 5);
 }
 
+#ifdef CONFIG_GENERIC_TIME
+
 /**
  * clocksource_select - Select the best clocksource available
  *


