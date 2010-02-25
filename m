Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230Ab0BYWGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:06:55 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51869 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933895Ab0BYWGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:06:53 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/2] rcu: make lockdep_rcu_dereference() message less alarmist
Date: Thu, 25 Feb 2010 14:06:46 -0800
Message-Id: <1267135607-7056-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100225220624.GA7013@linux.vnet.ibm.com>
References: <20100225220624.GA7013@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change from "unsafe" to "suspicious", given that there will be false
alarms.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/lockdep.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 672c436..0c30d04 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3816,9 +3816,9 @@ void lockdep_rcu_dereference(const char *file, const int line)
 
 	if (!debug_locks_off())
 		return;
-	printk("\n==============================================\n");
-	printk(  "[ BUG: Unsafe rcu_dereference_check() usage! ]\n");
-	printk(  "----------------------------------------------\n");
+	printk("\n===================================================\n");
+	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
+	printk(  "---------------------------------------------------\n");
 	printk("%s:%d invoked rcu_dereference_check() without protection!\n",
 			file, line);
 	printk("\nother info that might help us debug this:\n\n");
-- 
1.6.6

