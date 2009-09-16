Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbZIPKTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbZIPKTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZIPKTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:19:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:46297 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbZIPKTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:19:33 -0400
Date: Wed, 16 Sep 2009 10:19:04 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix double_rq_lock() compile warning
Message-ID: <tip-b78bb868c54bebbf8d8786a3f8320700d6d2b864@git.kernel.org>
Git-Commit-ID: b78bb868c54bebbf8d8786a3f8320700d6d2b864
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:19:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b78bb868c54bebbf8d8786a3f8320700d6d2b864
Gitweb:     http://git.kernel.org/tip/b78bb868c54bebbf8d8786a3f8320700d6d2b864
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 15 Sep 2009 14:23:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:01:01 +0200

sched: Fix double_rq_lock() compile warning

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e27a536..17e4391 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -119,8 +119,6 @@
  */
 #define RUNTIME_INF	((u64)~0ULL)
 
-static void double_rq_lock(struct rq *rq1, struct rq *rq2);
-
 static inline int rt_policy(int policy)
 {
 	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
@@ -1695,6 +1693,8 @@ static inline void update_shares_locked(struct rq *rq, struct sched_domain *sd)
 
 #ifdef CONFIG_PREEMPT
 
+static void double_rq_lock(struct rq *rq1, struct rq *rq2);
+
 /*
  * fair double_lock_balance: Safely acquires both rq->locks in a fair
  * way at the expense of forcing extra atomic operations in all
