Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab0CCPr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:47:58 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48873 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab0CCPrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:47:09 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/4] rcu: add control variables to lockdep_rcu_dereference() diagnostics
Date: Wed,  3 Mar 2010 07:46:59 -0800
Message-Id: <1267631219-8713-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100303154638.GA8576@linux.vnet.ibm.com>
References: <20100303154638.GA8576@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the values of rcu_scheduler_active() and debug_locks() to the
lockdep_rcu_dereference() output to help diagnose RCU lockdep splats
that occur shortly after the scheduler starts.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/lockdep.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 0c30d04..681bc2e 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3822,6 +3822,7 @@ void lockdep_rcu_dereference(const char *file, const int line)
 	printk("%s:%d invoked rcu_dereference_check() without protection!\n",
 			file, line);
 	printk("\nother info that might help us debug this:\n\n");
+	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
 	lockdep_print_held_locks(curr);
 	printk("\nstack backtrace:\n");
 	dump_stack();
-- 
1.6.6

