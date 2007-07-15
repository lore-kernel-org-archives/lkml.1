Return-Path: <linux-kernel-owner+w=401wt.eu-S1765621AbXGOQQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765621AbXGOQQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762570AbXGOQFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:36 -0400
Received: from www.osadl.org ([213.239.205.134]:42625 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762440AbXGOQFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:19 -0400
Message-Id: <20070715155542.035275443@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:11:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 30/33] jiffies: remove unused macros
Content-Disposition: inline; filename=jiffies-remove-unused-macros.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

The x86 hpet cleanups allow removal of some unused macros.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

 include/linux/jiffies.h |    6 ------
 1 file changed, 6 deletions(-)

Index: linux-2.6.22-rc6-mm/include/linux/jiffies.h
===================================================================
--- linux-2.6.22-rc6-mm.orig/include/linux/jiffies.h	2007-07-15 17:48:13.000000000 +0200
+++ linux-2.6.22-rc6-mm/include/linux/jiffies.h	2007-07-15 17:48:22.000000000 +0200
@@ -36,8 +36,6 @@
 /* LATCH is used in the interval timer and ftape setup. */
 #define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
 
-#define LATCH_HPET ((HPET_TICK_RATE + HZ/2) / HZ)
-
 /* Suppose we want to devide two numbers NOM and DEN: NOM/DEN, the we can
  * improve accuracy by shifting LSH bits, hence calculating:
  *     (NOM << LSH) / DEN
@@ -53,13 +51,9 @@
 /* HZ is the requested value. ACTHZ is actual HZ ("<< 8" is for accuracy) */
 #define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
 
-#define ACTHZ_HPET (SH_DIV (HPET_TICK_RATE, LATCH_HPET, 8))
-
 /* TICK_NSEC is the time between ticks in nsec assuming real ACTHZ */
 #define TICK_NSEC (SH_DIV (1000000UL * 1000, ACTHZ, 8))
 
-#define TICK_NSEC_HPET (SH_DIV(1000000UL * 1000, ACTHZ_HPET, 8))
-
 /* TICK_USEC is the time between ticks in usec assuming fake USER_HZ */
 #define TICK_USEC ((1000000UL + USER_HZ/2) / USER_HZ)
 

-- 

