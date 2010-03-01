Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab0CAIeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:34:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:59400 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab0CAIeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:34:13 -0500
Date: Mon, 1 Mar 2010 08:33:39 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100228163218.GD6846@linux.vnet.ibm.com>
References: <20100228163218.GD6846@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] sched, rcu: Fix rcu_dereference() for RCU-lockdep
Message-ID: <tip-90a6501f94aedd7fb40f5556334843194fb598be@git.kernel.org>
Git-Commit-ID: 90a6501f94aedd7fb40f5556334843194fb598be
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 08:33:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90a6501f94aedd7fb40f5556334843194fb598be
Gitweb:     http://git.kernel.org/tip/90a6501f94aedd7fb40f5556334843194fb598be
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sun, 28 Feb 2010 08:32:18 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 1 Mar 2010 09:29:58 +0100

sched, rcu: Fix rcu_dereference() for RCU-lockdep

Make rcu_dereference() of runqueue data structures be
rcu_dereference_sched().

Located-by: Ingo Molnar <mingo@elte.hu>
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
LKML-Reference: <20100228163218.GD6846@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3e1fd96..5a5ea2c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3476,7 +3476,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 
 static inline int on_null_domain(int cpu)
 {
-	return !rcu_dereference(cpu_rq(cpu)->sd);
+	return !rcu_dereference_sched(cpu_rq(cpu)->sd);
 }
 
 /*
