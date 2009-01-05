Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZAELna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZAELna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZAELm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:42:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48339 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbZAELmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:42:55 -0500
Message-Id: <20090105103136.564276999@chello.nl>
References: <20090105102818.829119334@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 05 Jan 2009 11:28:23 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/5] hrtimer: fixup comments
Content-Disposition: inline; filename=hrtimers-comments.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Clean up the comments

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/hrtimer.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1141,9 +1141,9 @@ static void __run_hrtimer(struct hrtimer
 	spin_lock(&cpu_base->lock);
 
 	/*
-	 * Note: We clear the CALLBACK bit after enqueue_hrtimer to avoid
-	 * reprogramming of the event hardware. This happens at the end of this
-	 * function anyway.
+	 * Note: We clear the CALLBACK bit after enqueue_hrtimer and
+	 * we do not reprogramm the event hardware. Happens either in
+	 * hrtimer_start_range_ns() or in hrtimer_interrupt()
 	 */
 	if (restart != HRTIMER_NORESTART) {
 		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
@@ -1540,14 +1540,12 @@ static void migrate_hrtimer_list(struct 
 		__remove_hrtimer(timer, old_base, HRTIMER_STATE_MIGRATE, 0);
 		timer->base = new_base;
 		/*
-		 * Enqueue the timers on the new cpu, but do not reprogram 
-		 * the timer as that would enable a deadlock between
-		 * hrtimer_enqueue_reprogramm() running the timer and us still
-		 * holding a nested base lock.
-		 *
-		 * Instead we tickle the hrtimer interrupt after the migration
-		 * is done, which will run all expired timers and re-programm
-		 * the timer device.
+		 * Enqueue the timers on the new cpu. This does not
+		 * reprogram the event device in case the timer
+		 * expires before the earliest on this CPU, but we run
+		 * hrtimer_interrupt after we migrated everything to
+		 * sort out already expired timers and reprogram the
+		 * event device.
 		 */
 		enqueue_hrtimer(timer, new_base);
 

-- 

