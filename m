Return-Path: <linux-kernel-owner+w=401wt.eu-S1762360AbZLPRGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762360AbZLPRGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762342AbZLPRGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:06:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:53826 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762285AbZLPRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:06:17 -0500
Message-Id: <20091216170517.577998058@chello.nl>
References: <20091216170430.073353839@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 18:04:33 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/12] sched: Fix task_hot() test order
Content-Disposition: inline; filename=foo10.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure not to access sched_fair fields before verifying it is
indeed a sched_fair task.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: stable@kernel.org
---
 kernel/sched.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2044,6 +2044,9 @@ task_hot(struct task_struct *p, u64 now,
 {
 	s64 delta;
 
+	if (p->sched_class != &fair_sched_class)
+		return 0;
+
 	/*
 	 * Buddy candidates are cache hot:
 	 */
@@ -2052,9 +2055,6 @@ task_hot(struct task_struct *p, u64 now,
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;
 
-	if (p->sched_class != &fair_sched_class)
-		return 0;
-
 	if (sysctl_sched_migration_cost == -1)
 		return 1;
 	if (sysctl_sched_migration_cost == 0)

-- 

