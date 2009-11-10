Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbZKJVhh (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 10 Nov 2009 16:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758318AbZKJVhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:37:34 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53391 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758299AbZKJVhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:37:20 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/4] rcu: remove inline from forward-referenced functions
Date: Tue, 10 Nov 2009 13:37:19 -0800
Message-Id: <12578890422402-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091110213651.GA21411@linux.vnet.ibm.com>
References: <20091110213651.GA21411@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some variants of gcc are reputed to dislike forward references to
functions declared "inline".  Remove the "inline" keyword from such
functions.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.h        |    2 +-
 kernel/rcutree_plugin.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 5de1fe8..e2f07a2 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -301,7 +301,7 @@ DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 #else /* #ifdef RCU_TREE_NONCORE */
 
 /* Forward declarations for rcutree_plugin.h */
-static inline void rcu_bootup_announce(void);
+static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
 static void rcu_preempt_note_context_switch(int cpu);
 static int rcu_preempted_readers(struct rcu_node *rnp);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ebd20ee..9744dfc 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -33,7 +33,7 @@ DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 /*
  * Tell them what RCU they are running.
  */
-static inline void rcu_bootup_announce(void)
+static void rcu_bootup_announce(void)
 {
 	printk(KERN_INFO
 	       "Experimental preemptable hierarchical RCU implementation.\n");
@@ -475,7 +475,7 @@ void exit_rcu(void)
 /*
  * Tell them what RCU they are running.
  */
-static inline void rcu_bootup_announce(void)
+static void rcu_bootup_announce(void)
 {
 	printk(KERN_INFO "Hierarchical RCU implementation.\n");
 }
-- 
1.5.2.5

