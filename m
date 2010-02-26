Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935748Ab0BZJ36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:29:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:39821 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935716Ab0BZJ3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:29:40 -0500
Date: Fri, 26 Feb 2010 09:29:23 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267135607-7056-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267135607-7056-1-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Make lockdep_rcu_dereference() message less alarmist
Message-ID: <tip-056ba4a9bea5f32781a36b797c562fb731e5eaa6@git.kernel.org>
Git-Commit-ID: 056ba4a9bea5f32781a36b797c562fb731e5eaa6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 09:29:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  056ba4a9bea5f32781a36b797c562fb731e5eaa6
Gitweb:     http://git.kernel.org/tip/056ba4a9bea5f32781a36b797c562fb731e5eaa6
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Thu, 25 Feb 2010 14:06:46 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Feb 2010 08:20:46 +0100

rcu: Make lockdep_rcu_dereference() message less alarmist

Change from "unsafe" to "suspicious", given that there will be
false alarms.

Suggested-by: Ingo Molnar <mingo@elte.hu>
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
LKML-Reference: <1267135607-7056-1-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
