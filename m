Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbZKKUbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbZKKUbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbZKKUbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:31:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:48538 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZKKUbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:31:42 -0500
Date: Wed, 11 Nov 2009 20:31:14 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, joe@perches.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, joe@perches.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091111192806.GA10073@linux.vnet.ibm.com>
References: <20091111192806.GA10073@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Mark init-time-only rcu_bootup_announce() as __init
Message-ID: <tip-0e0fc1c23e04c15e814763f2b366e92d87d8b95d@git.kernel.org>
Git-Commit-ID: 0e0fc1c23e04c15e814763f2b366e92d87d8b95d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e0fc1c23e04c15e814763f2b366e92d87d8b95d
Gitweb:     http://git.kernel.org/tip/0e0fc1c23e04c15e814763f2b366e92d87d8b95d
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 11 Nov 2009 11:28:06 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Nov 2009 21:27:42 +0100

rcu: Mark init-time-only rcu_bootup_announce() as __init

Because rcu_bootup_announce() is used only at boot time, mark it
as __init, presumably so that its memory can be reclaimed.

Suggested-by: Joe Perches <joe@perches.com>
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
LKML-Reference: <20091111192806.GA10073@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree_plugin.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 52075da..5ca2d26 100644
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
@@ -481,7 +481,7 @@ void exit_rcu(void)
 /*
  * Tell them what RCU they are running.
  */
-static void rcu_bootup_announce(void)
+static void __init rcu_bootup_announce(void)
 {
 	printk(KERN_INFO "Hierarchical RCU implementation.\n");
 }
