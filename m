Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbYADN5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbYADN5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYADN4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:56:15 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:6155 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYADN4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:56:10 -0500
X-SourceIP: 80.56.237.116
Message-Id: <20080104135652.132113000@chello.nl>
References: <20080104135457.336761000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 04 Jan 2008 14:54:59 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/7] sched: load_balance_monitor rename
Content-Disposition: inline; filename=sched-group-fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

don't start the load_balance_monitor when there is only a single cpu.
rename the kthread because its currently longer than TASK_COMM_LEN

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7070,8 +7070,11 @@ void __init sched_init_smp(void)
 	sched_init_granularity();
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	if (nr_cpu_ids == 1)
+		return;
+
 	lb_monitor_task = kthread_create(load_balance_monitor, NULL,
-					 "load_balance_monitor");
+					 "group_balance");
 	if (!IS_ERR(lb_monitor_task)) {
 		lb_monitor_task->flags |= PF_NOFREEZE;
 		wake_up_process(lb_monitor_task);

--

