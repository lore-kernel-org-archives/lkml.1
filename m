Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbZHTNjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbZHTNjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbZHTNjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:39:13 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:12383
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754169AbZHTNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:39:12 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh203h65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KOOGE9-02-88W-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:34:56 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 3/15] sched: Add cpumask to be used when building MN domain
Message-ID: <20090820133456.GR29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:34:56.0865 (UTC) FILETIME=[01E0FD10:01CA219B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c780eed..9990c3a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8207,6 +8207,7 @@ struct s_data {
 	cpumask_var_t		nodemask;
 	cpumask_var_t		this_sibling_map;
 	cpumask_var_t		this_core_map;
+	cpumask_var_t		this_cpu_node_map;
 	cpumask_var_t		send_covered;
 	cpumask_var_t		tmpmask;
 	struct sched_group	**sched_group_nodes;
@@ -8218,6 +8219,7 @@ enum s_alloc {
 	sa_rootdomain,
 	sa_tmpmask,
 	sa_send_covered,
+	sa_this_cpu_node_map,
 	sa_this_core_map,
 	sa_this_sibling_map,
 	sa_nodemask,
@@ -8594,6 +8596,8 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 		free_cpumask_var(d->tmpmask); /* fall through */
 	case sa_send_covered:
 		free_cpumask_var(d->send_covered); /* fall through */
+	case sa_this_cpu_node_map:
+		free_cpumask_var(d->this_cpu_node_map); /* fall through */
 	case sa_this_core_map:
 		free_cpumask_var(d->this_core_map); /* fall through */
 	case sa_this_sibling_map:
@@ -8640,8 +8644,10 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 		return sa_nodemask;
 	if (!alloc_cpumask_var(&d->this_core_map, GFP_KERNEL))
 		return sa_this_sibling_map;
-	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
+	if (!alloc_cpumask_var(&d->this_cpu_node_map, GFP_KERNEL))
 		return sa_this_core_map;
+	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
+		return sa_this_cpu_node_map;
 	if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
 		return sa_send_covered;
 	d->rd = alloc_rootdomain();
-- 
1.6.0.4



