Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbZKJW2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbZKJW2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbZKJW2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:28:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:34918 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758403AbZKJW2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:28:05 -0500
Date: Tue, 10 Nov 2009 22:27:42 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12578890422402-git-send-email->
References: <12578890422402-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Remove inline from forward-referenced functions
Message-ID: <tip-dbe01350fa8ce0c11948ab7d6be71a4d901be151@git.kernel.org>
Git-Commit-ID: dbe01350fa8ce0c11948ab7d6be71a4d901be151
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dbe01350fa8ce0c11948ab7d6be71a4d901be151
Gitweb:     http://git.kernel.org/tip/dbe01350fa8ce0c11948ab7d6be71a4d901be151
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue, 10 Nov 2009 13:37:19 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 22:48:49 +0100

rcu: Remove inline from forward-referenced functions

Some variants of gcc are reputed to dislike forward references
to functions declared "inline".  Remove the "inline" keyword
from such functions.

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
LKML-Reference: <12578890422402-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.h        |    2 +-
 kernel/rcutree_plugin.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index c1891c3..ddb79ec 100644
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
index ef2a58c..c03edf7 100644
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
@@ -481,7 +481,7 @@ void exit_rcu(void)
 /*
  * Tell them what RCU they are running.
  */
-static inline void rcu_bootup_announce(void)
+static void rcu_bootup_announce(void)
 {
 	printk(KERN_INFO "Hierarchical RCU implementation.\n");
 }
