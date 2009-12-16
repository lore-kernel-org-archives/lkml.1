Return-Path: <linux-kernel-owner+w=401wt.eu-S935243AbZLPSkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935243AbZLPSkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935233AbZLPSkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:40:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:53540 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935209AbZLPSj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:39:58 -0500
Date: Wed, 16 Dec 2009 18:39:25 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091216170518.269101883@chello.nl>
References: <20091216170518.269101883@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Simplify set_task_cpu()
Message-ID: <tip-738d2be4301007f054541c5c4bf7fb6a361c9b3a@git.kernel.org>
Git-Commit-ID: 738d2be4301007f054541c5c4bf7fb6a361c9b3a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  738d2be4301007f054541c5c4bf7fb6a361c9b3a
Gitweb:     http://git.kernel.org/tip/738d2be4301007f054541c5c4bf7fb6a361c9b3a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Dec 2009 18:04:42 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 19:01:59 +0100

sched: Simplify set_task_cpu()

Rearrange code a bit now that its a simpler function.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170518.269101883@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f92ce63..8a2bfd3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2034,11 +2034,8 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
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
@@ -2049,11 +2046,11 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 
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
