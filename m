Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbZHYSWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbZHYSWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbZHYSWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:22:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:44918 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622AbZHYSWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:22:16 -0400
Date: Tue, 25 Aug 2009 18:21:42 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, lethal@linux-sh.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, lethal@linux-sh.org,
       mingo@elte.hu
In-Reply-To: <20090825154025.GD6616@linux.vnet.ibm.com>
References: <20090825154025.GD6616@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Add #ifdef to suppress __rcu_offline_cpu() warning in !HOTPLUG_CPU builds
Message-ID: <tip-c935a331c8f569c7903ed26a3994a70cbea1802e@git.kernel.org>
Git-Commit-ID: c935a331c8f569c7903ed26a3994a70cbea1802e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 25 Aug 2009 18:21:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c935a331c8f569c7903ed26a3994a70cbea1802e
Gitweb:     http://git.kernel.org/tip/c935a331c8f569c7903ed26a3994a70cbea1802e
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue, 25 Aug 2009 08:40:25 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 25 Aug 2009 20:20:03 +0200

rcu: Add #ifdef to suppress __rcu_offline_cpu() warning in !HOTPLUG_CPU builds

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josht@linux.vnet.ibm.com
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Paul Mundt <lethal@linux-sh.org>
LKML-Reference: <20090825154025.GD6616@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 000b076..fee6316 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -84,7 +84,9 @@ extern long rcu_batches_completed_sched(void);
 static void cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp,
 			  struct rcu_node *rnp, unsigned long flags);
 static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags);
+#ifdef CONFIG_HOTPLUG_CPU
 static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static void __rcu_process_callbacks(struct rcu_state *rsp,
 				    struct rcu_data *rdp);
 static void __call_rcu(struct rcu_head *head,
