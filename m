Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab0CCPrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:47:10 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45462 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab0CCPrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:47:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/4] rcu: revert 1883c79a: early boot now handled by lockdep-RCU
Date: Wed,  3 Mar 2010 07:46:58 -0800
Message-Id: <1267631219-8713-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100303154638.GA8576@linux.vnet.ibm.com>
References: <20100303154638.GA8576@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the check for !rcu_scheduler_active because this
check has been incorporated into rcu_dereference_check().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/cgroup.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a73e1ce..c9bbcb2 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -489,7 +489,6 @@ static inline struct cgroup_subsys_state *task_subsys_state(
 {
 	return rcu_dereference_check(task->cgroups->subsys[subsys_id],
 				     rcu_read_lock_held() ||
-				     !rcu_scheduler_active ||
 				     cgroup_lock_is_held());
 }
 
-- 
1.6.6

