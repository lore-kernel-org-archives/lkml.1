Return-Path: <linux-kernel-owner+w=401wt.eu-S1763968AbZLQEu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763968AbZLQEu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762283AbZLQEDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:03:39 -0500
Received: from kroah.org ([198.145.64.141]:55225 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761781AbZLQEDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:34 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:44 2009
Message-Id: <20091217035643.889583556@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, Benjamin Gilbert <bgilbert@cs.cmu.edu>,
       Ingo Molnar <mingo@elte.hu>
Subject: [007/151] rcu: Remove inline from forward-referenced functions
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

commit dbe01350fa8ce0c11948ab7d6be71a4d901be151 upstream.

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
Cc: Benjamin Gilbert <bgilbert@cs.cmu.edu>
LKML-Reference: <12578890422402-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/rcutree.h        |    2 +-
 kernel/rcutree_plugin.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -301,7 +301,7 @@ DECLARE_PER_CPU(struct rcu_data, rcu_pre
 #else /* #ifdef RCU_TREE_NONCORE */
 
 /* Forward declarations for rcutree_plugin.h */
-static inline void rcu_bootup_announce(void);
+static void rcu_bootup_announce(void);
 long rcu_batches_completed(void);
 static void rcu_preempt_note_context_switch(int cpu);
 static int rcu_preempted_readers(struct rcu_node *rnp);
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -33,7 +33,7 @@ DEFINE_PER_CPU(struct rcu_data, rcu_pree
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


