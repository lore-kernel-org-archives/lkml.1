Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYAGL05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYAGL05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbYAGL0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:26:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58661 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbYAGL0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:26:49 -0500
Subject: Re: [PATCH 00/11] another rt group sched update
From: Peter Zijlstra <peterz@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1199703080.7143.24.camel@twins>
References: <20080106161128.152634000@chello.nl>
	 <1199703080.7143.24.camel@twins>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 12:24:20 +0100
Message-Id: <1199705060.7143.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-07 at 11:51 +0100, Peter Zijlstra wrote:

>  - I occasionally see a weird lockup on iterating the task_groups list
>    on smp machines. - I failed to see anything wrong, but hey, this
>    stack of used brown paper bags is steadily growing.

D'oh

---

Don't add a task_group to the task_groups list for each cpu, there is
only a single task_group.


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7175,6 +7175,10 @@ void __init sched_init(void)
 	init_defrootdomain();
 #endif
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	list_add(&init_task_group.list, &task_groups);
+#endif
+
 	for_each_possible_cpu(i) {
 		struct rq *rq;
 
@@ -7201,8 +7205,6 @@ void __init sched_init(void)
 		init_tg_rt_entry(rq, &init_task_group,
 				&per_cpu(init_rt_rq, i),
 				&per_cpu(init_sched_rt_entity, i), i, 1);
-
-		list_add(&init_task_group.list, &task_groups);
 #endif
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)



