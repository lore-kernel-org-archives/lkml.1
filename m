Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbXFWNXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbXFWNXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756427AbXFWNV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:21:58 -0400
Received: from www.osadl.org ([213.239.205.134]:59183 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756130AbXFWNV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:21:57 -0400
Message-Id: <20070623124030.306756083@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch -mm 04/28] Timekeeping: Fixup shadow variable argument
Content-Disposition: inline;
	filename=timekeeping-c-fixup-clock-shadow-global-variable.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

clocksource_adjust() has a clock argument, which shadows the file 
global clock variable. Fix this up.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>

---
 kernel/time/timekeeping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc4-mm/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/kernel/time/timekeeping.c	2007-06-23 14:38:57.000000000 +0200
+++ linux-2.6.22-rc4-mm/kernel/time/timekeeping.c	2007-06-23 14:38:57.000000000 +0200
@@ -401,7 +401,7 @@ static __always_inline int clocksource_b
  * this is optimized for the most common adjustments of -1,0,1,
  * for other values we can do a bit more work.
  */
-static void clocksource_adjust(struct clocksource *clock, s64 offset)
+static void clocksource_adjust(s64 offset)
 {
 	s64 error, interval = clock->cycle_interval;
 	int adj;
@@ -476,7 +476,7 @@ void update_wall_time(void)
 	}
 
 	/* correct the clock when NTP error is too big */
-	clocksource_adjust(clock, offset);
+	clocksource_adjust(offset);
 
 	/* store full nanoseconds into xtime */
 	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;

-- 

