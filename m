Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbYFSMie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbYFSMie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbYFSMfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:35:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44133 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501AbYFSMfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:35:36 -0400
Message-Id: <20080619123313.872287289@chello.nl>
References: <20080619122218.971447669@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Jun 2008 14:22:20 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Daniel K." <dk@uw.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/10] sched: rt-group: fix hierarchy
Content-Disposition: inline; filename=sched-rt-hierarchy-fix.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't re-set the entity's runqueue to the wrong rq after we've set it
to the right one.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Daniel K. <dk@uw.no>
---
 kernel/sched.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7626,7 +7626,6 @@ static void init_tg_rt_entry(struct task
 	else
 		rt_se->rt_rq = parent->my_q;
 
-	rt_se->rt_rq = &rq->rt;
 	rt_se->my_q = rt_rq;
 	rt_se->parent = parent;
 	INIT_LIST_HEAD(&rt_se->run_list);

-- 

