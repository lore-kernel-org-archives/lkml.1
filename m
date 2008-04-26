Return-Path: <linux-kernel-owner+w=401wt.eu-S933441AbYDZARp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441AbYDZARp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759909AbYDZAPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:15:54 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50633 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757420AbYDZAPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:15:50 -0400
Message-Id: <20080426001549.769321000@polaris-admin.engr.sgi.com>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 17:15:53 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] sched: replace MAX_NUMNODES with nr_node_ids in kernel/sched.c
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
@@ -7056,9 +7056,9 @@ static int find_next_best_node(int node,
 
 	min_val = INT_MAX;
 
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < nr_node_ids; i++) {
 		/* Start at @node */
-		n = (node + i) % MAX_NUMNODES;
+		n = (node + i) % nr_node_ids;
 
 		if (!nr_cpus_node(n))
 			continue;
@@ -7252,7 +7252,7 @@ static void free_sched_groups(const cpum
 		if (!sched_group_nodes)
 			continue;
 
-		for (i = 0; i < MAX_NUMNODES; i++) {
+		for (i = 0; i < nr_node_ids; i++) {
 			struct sched_group *oldsg, *sg = sched_group_nodes[i];
 
 			*nodemask = node_to_cpumask(i);
@@ -7440,7 +7440,7 @@ static int __build_sched_domains(const c
 	/*
 	 * Allocate the per-node list of sched groups
 	 */
-	sched_group_nodes = kcalloc(MAX_NUMNODES, sizeof(struct sched_group *),
+	sched_group_nodes = kcalloc(nr_node_ids, sizeof(struct sched_group *),
 				    GFP_KERNEL);
 	if (!sched_group_nodes) {
 		printk(KERN_WARNING "Can not alloc sched group node list\n");
@@ -7584,7 +7584,7 @@ static int __build_sched_domains(const c
 #endif
 
 	/* Set up physical groups */
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < nr_node_ids; i++) {
 		SCHED_CPUMASK_VAR(nodemask, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7608,7 +7608,7 @@ static int __build_sched_domains(const c
 					send_covered, tmpmask);
 	}
 
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < nr_node_ids; i++) {
 		/* Set up node groups */
 		struct sched_group *sg, *prev;
 		SCHED_CPUMASK_VAR(nodemask, allmasks);
@@ -7647,9 +7647,9 @@ static int __build_sched_domains(const c
 		cpus_or(*covered, *covered, *nodemask);
 		prev = sg;
 
-		for (j = 0; j < MAX_NUMNODES; j++) {
+		for (j = 0; j < nr_node_ids; j++) {
 			SCHED_CPUMASK_VAR(notcovered, allmasks);
-			int n = (i + j) % MAX_NUMNODES;
+			int n = (i + j) % nr_node_ids;
 			node_to_cpumask_ptr(pnodemask, n);
 
 			cpus_complement(*notcovered, *covered);
@@ -7702,7 +7702,7 @@ static int __build_sched_domains(const c
 	}
 
 #ifdef CONFIG_NUMA
-	for (i = 0; i < MAX_NUMNODES; i++)
+	for (i = 0; i < nr_node_ids; i++)
 		init_numa_sched_groups_power(sched_group_nodes[i]);
 
 	if (sd_allnodes) {

-- 
