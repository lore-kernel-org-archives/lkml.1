Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZCFGal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZCFGal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZCFG3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:29:19 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:56290 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbZCFG3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:29:18 -0500
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH V3 3/6] sched: Add Comments at the beginning of
	find_busiest_group.
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>
Cc: "Dipankar Sarma" <dipankar@in.ibm.com>, efault@gmx.de, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 06 Mar 2009 11:59:05 +0530
Message-ID: <20090306062905.9445.40438.stgit@sofia.in.ibm.com>
In-Reply-To: <20090306060513.9445.28732.stgit@sofia.in.ibm.com>
References: <20090306060513.9445.28732.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there are no comments pertaining to power-savings balance in
the function find_busiest_group. Add appropriate comments.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---

 kernel/sched.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4629bb1..8648eb0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3090,6 +3090,23 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
  * find_busiest_group finds and returns the busiest CPU group within the
  * domain. It calculates and returns the amount of weighted load which
  * should be moved to restore balance via the imbalance parameter.
+ *
+ * Power-savings-balance: Through the sysfs tunables sched_mc/smt_power_savings
+ * he user can opt for aggressive task consolidation as a means to save power.
+ * When this is activated, we would have the SD_POWERSAVINGS_BALANCE flag
+ * set for appropriate sched_domains,
+ *
+ * Within such sched_domains, find_busiest_group would try to identify
+ * a sched_group which can be freed-up and whose tasks can be migrated to
+ * a sibling group which has the capacity to accomodate the former's tasks.
+ * If such a "can-go-idle" sched_group does exist, then the sibling group
+ * which can accomodate it's tasks is returned as the busiest group.
+ *
+ * Furthermore, if the user opts for more aggressive power-aware load
+ * balancing through sched_smt/mc_power_savings = 2, i.e when the
+ * active_power_savings_level greater or equal to POWERSAVINGS_BALANCE_WAKEUP,
+ * find_busiest_group will also nominate the preferred CPU, on which the tasks
+ * should hence forth be woken up on, instead of bothering an idle-cpu.
  */
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,

