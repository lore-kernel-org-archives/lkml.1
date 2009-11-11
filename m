Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbZKKD20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbZKKD20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 22:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZKKD20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 22:28:26 -0500
Received: from mail.perches.com ([173.55.12.10]:1335 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbZKKD2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 22:28:25 -0500
Subject: Re: [tip:core/rcu] rcu: Remove inline from forward-referenced
 functions
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20091111014222.GE8424@linux.vnet.ibm.com>
References: <tip-dbe01350fa8ce0c11948ab7d6be71a4d901be151@git.kernel.org>
	 <1257892710.25443.9.camel@Joe-Laptop.home>
	 <20091110225926.GA8424@linux.vnet.ibm.com>
	 <1257894380.25443.16.camel@Joe-Laptop.home>
	 <20091110234101.GB8424@linux.vnet.ibm.com>
	 <1257901421.25443.34.camel@Joe-Laptop.home>
	 <20091111014222.GE8424@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 19:28:28 -0800
Message-ID: <1257910108.25443.40.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 17:42 -0800, Paul E. McKenney wrote:
> On Tue, Nov 10, 2009 at 05:03:41PM -0800, Joe Perches wrote:
> > So maybe rename rcutree_plugin.h to rcutree_plugin.c and
> > #include "rcutree_plugin.c" in rcutree.c instead.
> Hmmm...

Perhaps something like this:

cheers, Joe

rcu: rename rcutree_plugin.h to .c and use

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d802419..737dc72 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1783,6 +1783,8 @@ do { \
 	} \
 } while (0)
 
+#include "rcutree_plugin.c"
+
 void __init __rcu_init(void)
 {
 	rcu_bootup_announce();
@@ -1795,4 +1797,3 @@ void __init __rcu_init(void)
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
-#include "rcutree_plugin.h"
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 17a28a0..ed11d16 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -300,8 +300,7 @@ DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 
 #else /* #ifdef RCU_TREE_NONCORE */
 
-/* Forward declarations for rcutree_plugin.h */
-static void rcu_bootup_announce(void);
+/* Forward declarations for rcutree_plugin.c */
 long rcu_batches_completed(void);
 static void rcu_preempt_note_context_switch(int cpu);
 static int rcu_preempted_readers(struct rcu_node *rnp);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.c
similarity index 99%
rename from kernel/rcutree_plugin.h
rename to kernel/rcutree_plugin.c
index 52075da..5ca2d26 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.c
@@ -33,7 +33,7 @@ DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 /*
  * Tell them what RCU they are running.
  */
-static void rcu_bootup_announce(void)
+static void __init rcu_bootup_announce(void)
 {
 	printk(KERN_INFO
 	       "Experimental preemptable hierarchical RCU implementation.\n");
@@ -481,7 +481,7 @@ void exit_rcu(void)
 /*
  * Tell them what RCU they are running.
  */
-static void rcu_bootup_announce(void)
+static void __init rcu_bootup_announce(void)
 {
 	printk(KERN_INFO "Hierarchical RCU implementation.\n");
 }


