Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYAPNFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYAPNFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 08:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYAPNE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 08:04:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39345 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbYAPNE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:04:59 -0500
Subject: [PATCH] hrtimer: remove hrtimer_clock_base::get_softirq_time
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 14:04:56 +0100
Message-Id: <1200488696.7161.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: hrtimer: remove hrtimer_clock_base::get_softirq_time()

When looking over the hrtimer code I noticed that 
hrtimer_clock_base::get_softirq_time() is currently unused in the entire
tree, remove it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/hrtimer.h |    2 --
 kernel/hrtimer.c        |    3 ---
 2 files changed, 5 deletions(-)

Index: linux-2.6/include/linux/hrtimer.h
===================================================================
--- linux-2.6.orig/include/linux/hrtimer.h
+++ linux-2.6/include/linux/hrtimer.h
@@ -147,7 +147,6 @@ struct hrtimer_sleeper {
  * @first:		pointer to the timer node which expires first
  * @resolution:		the resolution of the clock, in nanoseconds
  * @get_time:		function to retrieve the current time of the clock
- * @get_softirq_time:	function to retrieve the current time from the softirq
  * @softirq_time:	the time when running the hrtimer queue in the softirq
  * @offset:		offset of this clock to the monotonic base
  * @reprogram:		function to reprogram the timer event
@@ -159,7 +158,6 @@ struct hrtimer_clock_base {
 	struct rb_node		*first;
 	ktime_t			resolution;
 	ktime_t			(*get_time)(void);
-	ktime_t			(*get_softirq_time)(void);
 	ktime_t			softirq_time;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t			offset;
Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1177,9 +1177,6 @@ static inline void run_hrtimer_queue(str
 	if (!base->first)
 		return;
 
-	if (base->get_softirq_time)
-		base->softirq_time = base->get_softirq_time();
-
 	spin_lock_irq(&cpu_base->lock);
 
 	while ((node = base->first)) {


