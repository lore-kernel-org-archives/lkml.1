Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab0BYKMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:12:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:40862 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758941Ab0BYKMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:12:42 -0500
Date: Thu, 25 Feb 2010 10:11:24 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1266887105-1528-7-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-7-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] sched: Better name for for_each_domain_rd
Message-ID: <tip-497f0ab39cd25bed317b29482c147c967f7ecd1f@git.kernel.org>
Git-Commit-ID: 497f0ab39cd25bed317b29482c147c967f7ecd1f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:11:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  497f0ab39cd25bed317b29482c147c967f7ecd1f
Gitweb:     http://git.kernel.org/tip/497f0ab39cd25bed317b29482c147c967f7ecd1f
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 22 Feb 2010 17:04:51 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 10:34:47 +0100

sched: Better name for for_each_domain_rd

As suggested by Peter Ziljstra, make better choice of name
for for_each_domain_rd(), containing "rcu_dereference", given
that it is but a wrapper for rcu_dereference_check().  The name
rcu_dereference_check_sched_domain() does that and provides a
separate per-subsystem name space.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1266887105-1528-7-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 70ae686..3218f52 100644
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
