Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbYIWNiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbYIWNiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYIWNgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:36:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50026 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYIWNgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:36:33 -0400
Message-Id: <20080923133500.664935788@programming.kicks-ass.net>
References: <20080923133340.929758093@programming.kicks-ass.net>
User-Agent: quilt/0.46-1
Date: Tue, 23 Sep 2008 15:33:45 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/6] sched: fixup buddy selection
Content-Disposition: inline; filename=sched-fix-buddy.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should set the buddy even though we might already have the TIF_RESCHED flag
set.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1350,6 +1350,8 @@ static void check_preempt_wakeup(struct 
 	if (unlikely(se == pse))
 		return;
 
+	cfs_rq_of(pse)->next = pse;
+
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
 	 * wake up path.
@@ -1357,8 +1359,6 @@ static void check_preempt_wakeup(struct 
 	if (test_tsk_need_resched(curr))
 		return;
 
-	cfs_rq_of(pse)->next = pse;
-
 	/*
 	 * Batch tasks do not preempt (their preemption is driven by
 	 * the tick):

-- 

