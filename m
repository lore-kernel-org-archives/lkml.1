Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0BWBIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:08:49 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58653 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab0BWBFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:05:14 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/21] sched: better name for for_each_domain_rd
Date: Mon, 22 Feb 2010 17:04:51 -0800
Message-Id: <1266887105-1528-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100223010435.GA666@linux.vnet.ibm.com>
References: <20100223010435.GA666@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Peter Ziljstra, make better choice of name
for for_each_domain_rd(), containing "rcu_dereference", given
that it is but a wrapper for rcu_dereference_check().  The name
rcu_dereference_check_sched_domain() does that and provides a separate
per-subsystem name space.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ad419d9..478fc7d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -645,7 +645,7 @@ static inline int cpu_of(struct rq *rq)
 #endif
 }
 
-#define for_each_domain_rd(p) \
+#define rcu_dereference_check_sched_domain(p) \
 	rcu_dereference_check((p), \
 			      rcu_read_lock_sched_held() || \
 			      lockdep_is_held(&sched_domains_mutex))
@@ -658,7 +658,7 @@ static inline int cpu_of(struct rq *rq)
  * preempt-disabled sections.
  */
 #define for_each_domain(cpu, __sd) \
-	for (__sd = for_each_domain_rd(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
+	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
 
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
 #define this_rq()		(&__get_cpu_var(runqueues))
-- 
1.6.6

