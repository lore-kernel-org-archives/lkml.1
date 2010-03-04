Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0CDQcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:32:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:48476 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738Ab0CDQcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:32:36 -0500
Date: Thu, 4 Mar 2010 16:32:19 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267631219-8713-4-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267631219-8713-4-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Add control variables to lockdep_rcu_dereference() diagnostics
Message-ID: <tip-cc5b83a9f884fe8722a275069a5a6fde39988455@git.kernel.org>
Git-Commit-ID: cc5b83a9f884fe8722a275069a5a6fde39988455
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 16:32:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc5b83a9f884fe8722a275069a5a6fde39988455
Gitweb:     http://git.kernel.org/tip/cc5b83a9f884fe8722a275069a5a6fde39988455
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 3 Mar 2010 07:46:59 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Mar 2010 12:07:32 +0100

rcu: Add control variables to lockdep_rcu_dereference() diagnostics

Add the values of rcu_scheduler_active() and debug_locks() to
the lockdep_rcu_dereference() output to help diagnose RCU
lockdep splats that occur shortly after the scheduler starts.

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
LKML-Reference: <1267631219-8713-4-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
