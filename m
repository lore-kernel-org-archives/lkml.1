Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbZHRLCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbZHRLCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758434AbZHRLCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:02:38 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:16538 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbZHRLCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:02:38 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMzz1202hzzz32i6bh203h43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KOKK05-02-6GP-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 13:02:29 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] sched: Consolidate definition of variable sd in
	__build_sched_domains
Message-ID: <20090818110229.GM29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090818104944.GA29515@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 11:02:30.0310 (UTC) FILETIME=[6147F460:01CA1FF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1933641..1c574ff 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8784,6 +8784,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 {
 	enum s_alloc alloc_state = sa_none;
 	struct s_data d;
+	struct sched_domain *sd;
 	int i;
 #ifdef CONFIG_NUMA
 	d.sd_allnodes = 0;
@@ -8798,8 +8799,6 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
 	for_each_cpu(i, cpu_map) {
-		struct sched_domain *sd;
-
 		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
 			    cpu_map);
 
@@ -8831,22 +8830,19 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
 	for_each_cpu(i, cpu_map) {
-		struct sched_domain *sd = &per_cpu(cpu_domains, i).sd;
-
+		sd = &per_cpu(cpu_domains, i).sd;
 		init_sched_groups_power(i, sd);
 	}
 #endif
 #ifdef CONFIG_SCHED_MC
 	for_each_cpu(i, cpu_map) {
-		struct sched_domain *sd = &per_cpu(core_domains, i).sd;
-
+		sd = &per_cpu(core_domains, i).sd;
 		init_sched_groups_power(i, sd);
 	}
 #endif
 
 	for_each_cpu(i, cpu_map) {
-		struct sched_domain *sd = &per_cpu(phys_domains, i).sd;
-
+		sd = &per_cpu(phys_domains, i).sd;
 		init_sched_groups_power(i, sd);
 	}
 
@@ -8865,7 +8861,6 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 	/* Attach the domains */
 	for_each_cpu(i, cpu_map) {
-		struct sched_domain *sd;
 #ifdef CONFIG_SCHED_SMT
 		sd = &per_cpu(cpu_domains, i).sd;
 #elif defined(CONFIG_SCHED_MC)
-- 
1.6.4



