Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbZCCQRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbZCCQRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZCCQRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:17:13 -0500
Received: from mx1.emlix.com ([193.175.82.87]:49935 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbZCCQRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:17:13 -0500
References: <E1LeXCe-0006wA-5k@mailer.emlix.com>
User-Agent: quilt/0.46-1
Date: Tue, 03 Mar 2009 16:30:44 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 1/3] xtensa: use generic sched_clock()
Content-Disposition: inline; filename=xtensa-generic-sched_clock.patch
Message-Id: <E1LeXIs-00071p-UP@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

Current xtensa implementation of sched_clock() is the same as the
generic one.  Just remove it, the weak symbol in kernel/sched_clock.c
will be used instead.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/xtensa/kernel/time.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -37,15 +37,6 @@ unsigned long nsec_per_ccount;		/* nsec 
 
 static long last_rtc_update = 0;
 
-/*
- * Scheduler clock - returns current tim in nanosec units.
- */
-
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-}
-
 static irqreturn_t timer_interrupt(int irq, void *dev_id);
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,

-- 

