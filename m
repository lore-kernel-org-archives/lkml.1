Return-Path: <linux-kernel-owner+w=401wt.eu-S1762528AbZLPRKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762528AbZLPRKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762293AbZLPRGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:06:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36117 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbZLPRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:06:17 -0500
Message-Id: <20091216170518.269101883@chello.nl>
References: <20091216170430.073353839@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 18:04:42 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/12] sched: Simplify set_task_cpu()
Content-Disposition: inline; filename=foo2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange code a bit now that its a simpler function.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2034,11 +2034,8 @@ task_hot(struct task_struct *p, u64 now,
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
-
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
-	int old_cpu = task_cpu(p);
-
 #ifdef CONFIG_SCHED_DEBUG
 	/*
 	 * We should never call set_task_cpu() on a blocked task,
@@ -2049,11 +2046,11 @@ void set_task_cpu(struct task_struct *p,
 
 	trace_sched_migrate_task(p, new_cpu);
 
-	if (old_cpu != new_cpu) {
-		p->se.nr_migrations++;
-		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS,
-				     1, 1, NULL, 0);
-	}
+	if (task_cpu(p) == new_cpu)
+		return;
+
+	p->se.nr_migrations++;
+	perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
 
 	__set_task_cpu(p, new_cpu);
 }

-- 

