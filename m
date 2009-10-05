Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbZJETLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbZJETLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZJETLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:11:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:42778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZJETLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:11:06 -0400
Date: Mon, 5 Oct 2009 19:09:55 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12541491931164-git-send-email->
References: <12541491931164-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Clean up code based on review feedback from Josh Triplett, part 3
Message-ID: <tip-3d76c082907e8f83c5d5c4572f38d53ad8f00c4b@git.kernel.org>
Git-Commit-ID: 3d76c082907e8f83c5d5c4572f38d53ad8f00c4b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 05 Oct 2009 19:09:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d76c082907e8f83c5d5c4572f38d53ad8f00c4b
Gitweb:     http://git.kernel.org/tip/3d76c082907e8f83c5d5c4572f38d53ad8f00c4b
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 28 Sep 2009 07:46:32 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Oct 2009 21:02:02 +0200

rcu: Clean up code based on review feedback from Josh Triplett, part 3

Whitespace fixes, updated comments, and trivial code movement.

o	Fix whitespace error in RCU_HEAD_INIT()

o	Move "So where is rcu_write_lock()" comment so that it does
	not come between the rcu_read_unlock() header comment and
	the rcu_read_unlock() definition.

o	Move the module_param statements for blimit, qhimark, and
	qlowmark to immediately follow the corresponding
	definitions.

o	In __rcu_offline_cpu(), move the assignment to rdp_me
	inside the "if" statement, given that rdp_me is not used
	outside of that "if" statement.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12541491931164-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/rcupdate.h |   14 +++++++-------
 kernel/rcutree.c         |   10 +++++-----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 7033121..3ebd0b7 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -77,7 +77,7 @@ extern int rcu_scheduler_active;
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
 
-#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
+#define RCU_HEAD_INIT	{ .next = NULL, .func = NULL }
 #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
 #define INIT_RCU_HEAD(ptr) do { \
        (ptr)->next = NULL; (ptr)->func = NULL; \
@@ -129,12 +129,6 @@ static inline void rcu_read_lock(void)
 	rcu_read_acquire();
 }
 
-/**
- * rcu_read_unlock - marks the end of an RCU read-side critical section.
- *
- * See rcu_read_lock() for more information.
- */
-
 /*
  * So where is rcu_write_lock()?  It does not exist, as there is no
  * way for writers to lock out RCU readers.  This is a feature, not
@@ -144,6 +138,12 @@ static inline void rcu_read_lock(void)
  * used as well.  RCU does not care how the writers keep out of each
  * others' way, as long as they do so.
  */
+
+/**
+ * rcu_read_unlock - marks the end of an RCU read-side critical section.
+ *
+ * See rcu_read_lock() for more information.
+ */
 static inline void rcu_read_unlock(void)
 {
 	rcu_read_release();
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 81af59b..d559783 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -122,6 +122,10 @@ static int blimit = 10;		/* Maximum callbacks per softirq. */
 static int qhimark = 10000;	/* If this many pending, ignore blimit. */
 static int qlowmark = 100;	/* Once only this many pending, use blimit. */
 
+module_param(blimit, int, 0);
+module_param(qhimark, int, 0);
+module_param(qlowmark, int, 0);
+
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
 static int rcu_pending(int cpu);
 
@@ -878,8 +882,8 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	 * indefinitely delay callbacks, you have far worse things to
 	 * be worrying about.
 	 */
-	rdp_me = rsp->rda[smp_processor_id()];
 	if (rdp->nxtlist != NULL) {
+		rdp_me = rsp->rda[smp_processor_id()];
 		*rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
 		rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
 		rdp->nxtlist = NULL;
@@ -1575,7 +1579,3 @@ void __init __rcu_init(void)
 }
 
 #include "rcutree_plugin.h"
-
-module_param(blimit, int, 0);
-module_param(qhimark, int, 0);
-module_param(qlowmark, int, 0);
