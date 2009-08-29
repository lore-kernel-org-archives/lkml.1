Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbZH2Fkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbZH2Fkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 01:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZH2Fkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 01:40:47 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:12715 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751528AbZH2Fkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 01:40:46 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: sched: rename per cpu variable init_cfs_rq so that it does not share a common name with a function within the same scope.
Date: Fri, 28 Aug 2009 22:40:43 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501EA98A6@exchange.ZeugmaSystems.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: sched: rename per cpu variable init_cfs_rq so that it does not share a common name with a function within the same scope.
Thread-Index: Acooaq6EyVK0uqiTQNO4R2Okn1Y2tgAAElUA
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending the same patch since the previous patch might have had some
whitespace issues.

Ani


Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
---
 kernel/sched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1b59e26..e1e97b3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -318,7 +318,7 @@ struct task_group root_task_group;
 /* Default task group's sched entity on each cpu */
 static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
 /* Default task group's cfs_rq on each cpu */
-static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq)
____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU(struct cfs_rq, init_tg_cfs_rq)
____cacheline_aligned_in_smp;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -9304,11 +9304,11 @@ void __init sched_init(void)
 		 * system cpu resource, based on the weight assigned to
root
 		 * user's cpu share (INIT_TASK_GROUP_LOAD). This is
accomplished
 		 * by letting tasks of init_task_group sit in a separate
cfs_rq
-		 * (init_cfs_rq) and having one entity represent this
group of
+		 * (init_tg_cfs_rq) and having one entity represent this
group of
 		 * tasks in rq->cfs (i.e init_task_group->se[] != NULL).
 		 */
 		init_tg_cfs_entry(&init_task_group,
-				&per_cpu(init_cfs_rq, i),
+				&per_cpu(init_tg_cfs_rq, i),
 				&per_cpu(init_sched_entity, i), i, 1,
 				root_task_group.se[i]);
 
-- 
1.6.4

