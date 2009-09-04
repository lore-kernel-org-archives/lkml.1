Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbZIDIzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbZIDIzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932675AbZIDIzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:55:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:36591 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725AbZIDIzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:55:43 -0400
Date: Fri, 4 Sep 2009 08:55:11 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, andreas.herrmann3@amd.com, a.p.zijlstra@chello.nl,
       balbir@in.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: balbir@in.ibm.com, mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090901083825.897028974@chello.nl>
References: <20090901083825.897028974@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: Add SD_PREFER_SIBLING
Message-ID: <tip-b5d978e0c7e79a7ff842e895c85a86b38c71f1cd@git.kernel.org>
Git-Commit-ID: b5d978e0c7e79a7ff842e895c85a86b38c71f1cd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 08:55:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5d978e0c7e79a7ff842e895c85a86b38c71f1cd
Gitweb:     http://git.kernel.org/tip/b5d978e0c7e79a7ff842e895c85a86b38c71f1cd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 1 Sep 2009 10:34:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 10:09:53 +0200

sched: Add SD_PREFER_SIBLING

Do the placement thing using SD flags.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
LKML-Reference: <20090901083825.897028974@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |   29 +++++++++++++++--------------
 kernel/sched.c        |   14 +++++++++++++-
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9c96ef2..651dded 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -798,18 +798,19 @@ enum cpu_idle_type {
 #define SCHED_LOAD_SCALE_FUZZ	SCHED_LOAD_SCALE
 
 #ifdef CONFIG_SMP
-#define SD_LOAD_BALANCE		1	/* Do load balancing on this domain. */
-#define SD_BALANCE_NEWIDLE	2	/* Balance when about to become idle */
-#define SD_BALANCE_EXEC		4	/* Balance on exec */
-#define SD_BALANCE_FORK		8	/* Balance on fork, clone */
-#define SD_WAKE_IDLE		16	/* Wake to idle CPU on task wakeup */
-#define SD_WAKE_AFFINE		32	/* Wake task to waking CPU */
-#define SD_WAKE_BALANCE		64	/* Perform balancing at task wakeup */
-#define SD_SHARE_CPUPOWER	128	/* Domain members share cpu power */
-#define SD_POWERSAVINGS_BALANCE	256	/* Balance for power savings */
-#define SD_SHARE_PKG_RESOURCES	512	/* Domain members share cpu pkg resources */
-#define SD_SERIALIZE		1024	/* Only a single load balancing instance */
-#define SD_WAKE_IDLE_FAR	2048	/* Gain latency sacrificing cache hit */
+#define SD_LOAD_BALANCE		0x0001	/* Do load balancing on this domain. */
+#define SD_BALANCE_NEWIDLE	0x0002	/* Balance when about to become idle */
+#define SD_BALANCE_EXEC		0x0004	/* Balance on exec */
+#define SD_BALANCE_FORK		0x0008	/* Balance on fork, clone */
+#define SD_WAKE_IDLE		0x0010	/* Wake to idle CPU on task wakeup */
+#define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
+#define SD_WAKE_BALANCE		0x0040	/* Perform balancing at task wakeup */
+#define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
+#define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
+#define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
+#define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
+#define SD_WAKE_IDLE_FAR	0x0800	/* Gain latency sacrificing cache hit */
+#define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 
 enum powersavings_balance_level {
 	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
@@ -829,7 +830,7 @@ static inline int sd_balance_for_mc_power(void)
 	if (sched_smt_power_savings)
 		return SD_POWERSAVINGS_BALANCE;
 
-	return 0;
+	return SD_PREFER_SIBLING;
 }
 
 static inline int sd_balance_for_package_power(void)
@@ -837,7 +838,7 @@ static inline int sd_balance_for_package_power(void)
 	if (sched_mc_power_savings | sched_smt_power_savings)
 		return SD_POWERSAVINGS_BALANCE;
 
-	return 0;
+	return SD_PREFER_SIBLING;
 }
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index 584a122..9d64cec 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3811,9 +3811,13 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			const struct cpumask *cpus, int *balance,
 			struct sd_lb_stats *sds)
 {
+	struct sched_domain *child = sd->child;
 	struct sched_group *group = sd->groups;
 	struct sg_lb_stats sgs;
-	int load_idx;
+	int load_idx, prefer_sibling = 0;
+
+	if (child && child->flags & SD_PREFER_SIBLING)
+		prefer_sibling = 1;
 
 	init_sd_power_savings_stats(sd, sds, idle);
 	load_idx = get_sd_load_idx(sd, idle);
@@ -3833,6 +3837,14 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		sds->total_load += sgs.group_load;
 		sds->total_pwr += group->__cpu_power;
 
+		/*
+		 * In case the child domain prefers tasks go to siblings
+		 * first, lower the group capacity to one so that we'll try
+		 * and move all the excess tasks away.
+		 */
+		if (prefer_sibling)
+			sgs.group_capacity = 1;
+
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
 			sds->this = group;
