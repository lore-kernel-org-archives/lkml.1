Return-Path: <linux-kernel-owner+w=401wt.eu-S1763408AbYDVUoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763408AbYDVUoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbYDVUmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:42:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:38011 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755116AbYDVUmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:42:21 -0400
Message-Id: <20080422204220.732703000@polaris-admin.engr.sgi.com>
References: <20080422204219.994283000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 22 Apr 2008 13:42:24 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] sched: replace MAX_NUMNODES with nr_node_ids in kernel/sched.c
Content-Disposition: inline; filename=mod_kernel_sched
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Replace usages of MAX_NUMNODES with nr_node_ids in kernel/sched.c,
    where appropriate.  This saves some allocated space as well as many
    wasted cycles going through node entries that are non-existent.

For inclusion into sched-devel/latest tree.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git


Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/sched.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- linux-2.6.sched.orig/kernel/sched.c
+++ linux-2.6.sched/kernel/sched.c
@@ -7046,9 +7046,9 @@ static int find_next_best_node(int node,
 
 	min_val = INT_MAX;
 
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < nr_node_ids; i++) {
 		/* Start at @node */
-		n = (node + i) % MAX_NUMNODES;
+		n = (node + i) % nr_node_ids;
 
 		if (!nr_cpus_node(n))
 			continue;
@@ -7241,7 +7241,7 @@ static void free_sched_groups(const cpum
 		if (!sched_group_nodes)
 			continue;
 
-		for (i = 0; i < MAX_NUMNODES; i++) {
+		for (i = 0; i < nr_node_ids; i++) {
 			struct sched_group *oldsg, *sg = sched_group_nodes[i];
 
 			*nodemask = node_to_cpumask(i);
@@ -7429,7 +7429,7 @@ static int __build_sched_domains(const c
 	/*
 	 * Allocate the per-node list of sched groups
 	 */
-	sched_group_nodes = kcalloc(MAX_NUMNODES, sizeof(struct sched_group *),
+	sched_group_nodes = kcalloc(nr_node_ids, sizeof(struct sched_group *),
 				    GFP_KERNEL);
 	if (!sched_group_nodes) {
 		printk(KERN_WARNING "Can not alloc sched group node list\n");
@@ -7573,7 +7573,7 @@ static int __build_sched_domains(const c
 #endif
 
 	/* Set up physical groups */
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < nr_node_ids; i++) {
 		SCHED_CPUMASK_VAR(nodemask, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7597,7 +7597,7 @@ static int __build_sched_domains(const c
 					send_covered, tmpmask);
 	}
 
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < nr_node_ids; i++) {
 		/* Set up node groups */
 		struct sched_group *sg, *prev;
 		SCHED_CPUMASK_VAR(nodemask, allmasks);
@@ -7636,9 +7636,9 @@ static int __build_sched_domains(const c
 		cpus_or(*covered, *covered, *nodemask);
 		prev = sg;
 
-		for (j = 0; j < MAX_NUMNODES; j++) {
+		for (j = 0; j < nr_node_ids; j++) {
 			SCHED_CPUMASK_VAR(notcovered, allmasks);
-			int n = (i + j) % MAX_NUMNODES;
+			int n = (i + j) % nr_node_ids;
 			node_to_cpumask_ptr(pnodemask, n);
 
 			cpus_complement(*notcovered, *covered);
@@ -7691,7 +7691,7 @@ static int __build_sched_domains(const c
 	}
 
 #ifdef CONFIG_NUMA
-	for (i = 0; i < MAX_NUMNODES; i++)
+	for (i = 0; i < nr_node_ids; i++)
 		init_numa_sched_groups_power(sched_group_nodes[i]);
 
 	if (sd_allnodes) {

-- 
