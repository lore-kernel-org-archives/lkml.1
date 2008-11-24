Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbYKXXcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbYKXXcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYKXXch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:32:37 -0500
Received: from ozlabs.org ([203.10.76.45]:52708 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbYKXXch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:32:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/3] Fix commit 0e3900e6 for UP build.
Date: Tue, 25 Nov 2008 09:58:41 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
References: <200811250238.53883.rusty@rustcorp.com.au> <20081124172343.GB11971@elte.hu> <200811250957.52031.rusty@rustcorp.com.au>
In-Reply-To: <200811250957.52031.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811250958.41573.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My recent patches were not tested against CONFIG_SMP=n.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index fb39645..94aab72 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1381,6 +1381,14 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p,
 	if (!rq->rt.rt_nr_running)
 		pull_rt_task(rq);
 }
+
+static inline void init_sched_rt_class(void)
+{
+	unsigned int i;
+
+	for_each_possible_cpu(i)
+		alloc_cpumask_var(&per_cpu(local_cpu_mask, i), GFP_KERNEL);
+}
 #endif /* CONFIG_SMP */
 
 /*
@@ -1552,11 +1560,3 @@ static void print_rt_stats(struct seq_file *m, int cpu)
 }
 #endif /* CONFIG_SCHED_DEBUG */
 
-/* Note that this is never called for !SMP, but that's OK. */
-static inline void init_sched_rt_class(void)
-{
-	unsigned int i;
-
-	for_each_possible_cpu(i)
-		alloc_cpumask_var(&per_cpu(local_cpu_mask, i), GFP_KERNEL);
-}

