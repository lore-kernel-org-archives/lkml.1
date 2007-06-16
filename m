Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbXFPKZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbXFPKZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbXFPKYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:24:13 -0400
Received: from www.osadl.org ([213.239.205.134]:37148 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753266AbXFPKYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:24:09 -0400
Message-Id: <20070616101636.675115029@inhelltoy.tec.linutronix.de>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 16 Jun 2007 10:36:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>
Subject: [patch-mm 04/25] Timekeeping: Fixup shadow variable argument
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
--- linux-2.6.22-rc4-mm.orig/kernel/time/timekeeping.c	2007-06-16 12:10:22.000000000 +0200
+++ linux-2.6.22-rc4-mm/kernel/time/timekeeping.c	2007-06-16 12:10:23.000000000 +0200
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

