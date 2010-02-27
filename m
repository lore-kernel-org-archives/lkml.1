Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966737Ab0B0AjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 19:39:07 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40676 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966700Ab0B0AjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 19:39:02 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] rcu: Make non-RCU_PROVE_LOCKING rcu_read_lock_sched_held() understand boot
Date: Fri, 26 Feb 2010 16:38:57 -0800
Message-Id: <1267231138-27856-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100227003831.GA27703@linux.vnet.ibm.com>
References: <20100227003831.GA27703@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the scheduler starts, all tasks are non-preemptible by
definition. So, during that time, rcu_read_lock_sched_held()
needs to always return "true".  This patch makes that be so
for RCU_PROVE_LOCKING=n.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index fcea332..c843736 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -166,7 +166,7 @@ static inline int rcu_read_lock_bh_held(void)
 
 static inline int rcu_read_lock_sched_held(void)
 {
-	return preempt_count() != 0;
+	return preempt_count() != 0 || !rcu_scheduler_active;
 }
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
-- 
1.6.6

