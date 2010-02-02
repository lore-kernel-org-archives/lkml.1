Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0BBIZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:25:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:36395 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab0BBIZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:25:49 -0500
Date: Tue, 2 Feb 2010 08:24:53 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, sfr@canb.auug.org.au,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <1265019219.24455.128.camel@laptop>
References: <1265019219.24455.128.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove unused update_shares_locked()
Message-ID: <tip-4a461c85b643258e305eb5a3aced34009db2f818@git.kernel.org>
Git-Commit-ID: 4a461c85b643258e305eb5a3aced34009db2f818
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Feb 2010 08:24:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a461c85b643258e305eb5a3aced34009db2f818
Gitweb:     http://git.kernel.org/tip/4a461c85b643258e305eb5a3aced34009db2f818
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 1 Feb 2010 11:13:39 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Feb 2010 06:58:27 +0100

sched: Remove unused update_shares_locked()

Commit f492e12ef050e02bf0185b6b57874992591b9be1 ("sched: Remove
load_balance_newidle()") removed the only user of this function,
so remove it too.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1265019219.24455.128.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a56ead4..2386f54 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1633,16 +1633,6 @@ static void update_shares(struct sched_domain *sd)
 	}
 }
 
-static void update_shares_locked(struct rq *rq, struct sched_domain *sd)
-{
-	if (root_task_group_empty())
-		return;
-
-	raw_spin_unlock(&rq->lock);
-	update_shares(sd);
-	raw_spin_lock(&rq->lock);
-}
-
 static void update_h_load(long cpu)
 {
 	if (root_task_group_empty())
@@ -1657,10 +1647,6 @@ static inline void update_shares(struct sched_domain *sd)
 {
 }
 
-static inline void update_shares_locked(struct rq *rq, struct sched_domain *sd)
-{
-}
-
 #endif
 
 #ifdef CONFIG_PREEMPT
