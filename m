Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485Ab0AUNyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab0AUNyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125Ab0AUNyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:54:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:46366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab0AUNyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:54:43 -0500
Date: Thu, 21 Jan 2010 13:54:11 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Assume *balance is valid
Message-ID: <tip-8f190fb3f7a405682666d3723f6ec370b5afe4da@git.kernel.org>
Git-Commit-ID: 8f190fb3f7a405682666d3723f6ec370b5afe4da
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jan 2010 13:54:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f190fb3f7a405682666d3723f6ec370b5afe4da
Gitweb:     http://git.kernel.org/tip/8f190fb3f7a405682666d3723f6ec370b5afe4da
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 24 Dec 2009 14:18:21 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jan 2010 13:40:15 +0100

sched: Assume *balance is valid

Since all load_balance() callers will have !NULL balance parameters we
can now assume so and remove a few checks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index de5ab12..0b482f5 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2465,7 +2465,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	 * to do the newly idle load balance.
 	 */
 	if (idle != CPU_NEWLY_IDLE && local_group &&
-	    balance_cpu != this_cpu && balance) {
+	    balance_cpu != this_cpu) {
 		*balance = 0;
 		return;
 	}
@@ -2528,7 +2528,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		update_sg_lb_stats(sd, group, this_cpu, idle, load_idx, sd_idle,
 				local_group, cpus, balance, &sgs);
 
-		if (local_group && balance && !(*balance))
+		if (local_group && !(*balance))
 			return;
 
 		sds->total_load += sgs.group_load;
@@ -2720,7 +2720,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * 5) The imbalance is within the specified limit.
 	 * 6) Any rebalance would lead to ping-pong
 	 */
-	if (balance && !(*balance))
+	if (!(*balance))
 		goto ret;
 
 	if (!sds.busiest || sds.busiest_nr_running == 0)
