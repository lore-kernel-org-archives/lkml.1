Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbZHRQyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbZHRQyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759439AbZHRQyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:54:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:42373 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759510AbZHRQyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:54:39 -0400
Date: Tue, 18 Aug 2009 16:54:06 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090818110229.GM29515@alberich.amd.com>
References: <20090818110229.GM29515@alberich.amd.com>
Subject: [tip:sched/domains] sched: Consolidate definition of variable sd in __build_sched_domains
Message-ID: <tip-294b0c9619a0469a3b385b6fc47e79f64222a692@git.kernel.org>
Git-Commit-ID: 294b0c9619a0469a3b385b6fc47e79f64222a692
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 16:54:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  294b0c9619a0469a3b385b6fc47e79f64222a692
Gitweb:     http://git.kernel.org/tip/294b0c9619a0469a3b385b6fc47e79f64222a692
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 18 Aug 2009 13:02:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 18:35:45 +0200

sched: Consolidate definition of variable sd in __build_sched_domains

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090818110229.GM29515@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c1ce884..cf4c953 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8678,6 +8678,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 {
 	enum s_alloc alloc_state = sa_none;
 	struct s_data d;
+	struct sched_domain *sd;
 	int i;
 #ifdef CONFIG_NUMA
 	d.sd_allnodes = 0;
@@ -8692,8 +8693,6 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
 	for_each_cpu(i, cpu_map) {
-		struct sched_domain *sd;
-
 		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
 			    cpu_map);
 
@@ -8725,22 +8724,19 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
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
 
@@ -8759,7 +8755,6 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 	/* Attach the domains */
 	for_each_cpu(i, cpu_map) {
-		struct sched_domain *sd;
 #ifdef CONFIG_SCHED_SMT
 		sd = &per_cpu(cpu_domains, i).sd;
 #elif defined(CONFIG_SCHED_MC)
