Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbZKKT14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbZKKT14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758710AbZKKT1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:27:54 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38130 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758713AbZKKT1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:27:53 -0500
Date: Wed, 11 Nov 2009 11:28:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu] rcu: mark init-time-only
	rcu_bootup_announce() as __init
Message-ID: <20091111192806.GA10073@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because rcu_bootup_announce() is used only at boot time, mark it as
__init, presumably so that its memory can be reclaimed.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index b7dc0c2..a1cf16d 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -33,7 +33,7 @@ DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 /*
  * Tell them what RCU they are running.
  */
-static void rcu_bootup_announce(void)
+static void __init rcu_bootup_announce(void)
 {
 	printk(KERN_INFO
 	       "Experimental preemptable hierarchical RCU implementation.\n");
@@ -475,7 +475,7 @@ void exit_rcu(void)
 /*
  * Tell them what RCU they are running.
  */
-static void rcu_bootup_announce(void)
+static void __init rcu_bootup_announce(void)
 {
 	printk(KERN_INFO "Hierarchical RCU implementation.\n");
 }
-- 
1.5.2.5

