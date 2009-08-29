Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbZH2N6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbZH2N6u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 09:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZH2N6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 09:58:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:36518 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbZH2N6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 09:58:48 -0400
Date: Sat, 29 Aug 2009 13:58:19 GMT
From: tip-bot for Anirban Sinha <ASinha@zeugmasystems.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       asinha@zeugmasystems.com, ASinha@zeugmasystems.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       asinha@zeugmasystems.com, tglx@linutronix.de, ASinha@zeugmasystems.com,
       mingo@elte.hu
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501EA98A6@exchange.ZeugmaSystems.local>
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA98A6@exchange.ZeugmaSystems.local>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Rename init_cfs_rq => init_tg_cfs_rq
Message-ID: <tip-84e9dabf6e6a78928c6a1a8ba235c9fb0908d0f8@git.kernel.org>
Git-Commit-ID: 84e9dabf6e6a78928c6a1a8ba235c9fb0908d0f8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 29 Aug 2009 13:58:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84e9dabf6e6a78928c6a1a8ba235c9fb0908d0f8
Gitweb:     http://git.kernel.org/tip/84e9dabf6e6a78928c6a1a8ba235c9fb0908d0f8
Author:     Anirban Sinha <ASinha@zeugmasystems.com>
AuthorDate: Fri, 28 Aug 2009 22:40:43 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 29 Aug 2009 15:51:16 +0200

sched: Rename init_cfs_rq => init_tg_cfs_rq

... so that it does not share a common name with a function
within the same scope.

Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
LKML-Reference: <DDFD17CC94A9BD49A82147DDF7D545C501EA98A6@exchange.ZeugmaSystems.local>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 523e20a..6244d24 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -309,8 +309,8 @@ void set_tg_uid(struct user_struct *user)
 
 /*
  * Root task group.
- * 	Every UID task group (including init_task_group aka UID-0) will
- * 	be a child to this group.
+ *	Every UID task group (including init_task_group aka UID-0) will
+ *	be a child to this group.
  */
 struct task_group root_task_group;
 
@@ -318,7 +318,7 @@ struct task_group root_task_group;
 /* Default task group's sched entity on each cpu */
 static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
 /* Default task group's cfs_rq on each cpu */
-static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU(struct cfs_rq, init_tg_cfs_rq) ____cacheline_aligned_in_smp;
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -9400,11 +9400,11 @@ void __init sched_init(void)
 		 * system cpu resource, based on the weight assigned to root
 		 * user's cpu share (INIT_TASK_GROUP_LOAD). This is accomplished
 		 * by letting tasks of init_task_group sit in a separate cfs_rq
-		 * (init_cfs_rq) and having one entity represent this group of
+		 * (init_tg_cfs_rq) and having one entity represent this group of
 		 * tasks in rq->cfs (i.e init_task_group->se[] != NULL).
 		 */
 		init_tg_cfs_entry(&init_task_group,
-				&per_cpu(init_cfs_rq, i),
+				&per_cpu(init_tg_cfs_rq, i),
 				&per_cpu(init_sched_entity, i), i, 1,
 				root_task_group.se[i]);
 
