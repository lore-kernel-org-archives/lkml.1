Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZCFGa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZCFGa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZCFG30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:29:26 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:48468 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZCFG3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:29:24 -0500
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH V3 4/6] sched: Rename the variable
	sched_mc_preferred_wakeup_cpu
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>
Cc: "Dipankar Sarma" <dipankar@in.ibm.com>, efault@gmx.de, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>
Date: Fri, 06 Mar 2009 11:59:10 +0530
Message-ID: <20090306062910.9445.91189.stgit@sofia.in.ibm.com>
In-Reply-To: <20090306060513.9445.28732.stgit@sofia.in.ibm.com>
References: <20090306060513.9445.28732.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_mc_ preferred_wakeup_cpu is currently used when the user seeks
power savings through aggressive task consolidation.

This is applicable for both sched_mc_power_savings as well as
sched_smt_power_savings. So rename sched_mc_preferred_wakeup_cpu to
preferred_wakeup_cpu.

Also fix the comment for preferred_wakeup_cpu.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c      |   12 +++++++-----
 kernel/sched_fair.c |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8648eb0..d57a882 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -515,11 +515,13 @@ struct root_domain {
 #endif
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 	/*
-	 * Preferred wake up cpu nominated by sched_mc balance that will be
-	 * used when most cpus are idle in the system indicating overall very
-	 * low system utilisation. Triggered at POWERSAVINGS_BALANCE_WAKEUP(2)
+	 * Preferred wake up cpu which is nominated by load balancer,
+	 * is the CPU on which the tasks would be woken up, which
+	 * otherwise would have woken up on an idle CPU even on a system
+	 * with low-cpu-utilization.
+	 * This is triggered at POWERSAVINGS_BALANCE_WAKEUP(2).
 	 */
-	unsigned int sched_mc_preferred_wakeup_cpu;
+	unsigned int preferred_wakeup_cpu;
 #endif
 };
 
@@ -3416,7 +3418,7 @@ out_balanced:
 	if (this == group_leader && group_leader != group_min) {
 		*imbalance = min_load_per_task;
 		if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP) {
-			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
+			cpu_rq(this_cpu)->rd->preferred_wakeup_cpu =
 				cpumask_first(sched_group_cpus(group_leader));
 		}
 		return group_min;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a3583c6..03b1e3c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1052,7 +1052,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 
 	this_cpu = smp_processor_id();
 	chosen_wakeup_cpu =
-		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
+		cpu_rq(this_cpu)->rd->preferred_wakeup_cpu;
 
 	if (active_power_savings_level >= POWERSAVINGS_BALANCE_WAKEUP &&
 		idle_cpu(cpu) && idle_cpu(this_cpu) &&

