Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbXISKv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbXISKv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 06:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbXISKvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 06:51:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849AbXISKvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 06:51:05 -0400
Message-Id: <20070919105055.343945000@chello.nl>
References: <20070919104125.286538000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 19 Sep 2007 12:41:31 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [RFC][PATCH 6/6] fixup early boot
Content-Disposition: inline; filename=preempt-fixup-rest_init.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 init/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -452,7 +452,8 @@ static void noinline __init_refok rest_i
 	 * at least once to get things moving:
 	 */
 	init_idle_bootup_task(current);
-	preempt_enable_no_resched();
+	_preempt_enable_no_resched();
+
 	schedule();
 	preempt_disable();
 
@@ -556,7 +557,7 @@ asmlinkage void __init start_kernel(void
 	 * Disable preemption - early bootup scheduling is extremely
 	 * fragile until we cpu_idle() for the first time.
 	 */
-	preempt_disable();
+	_preempt_disable();
 	build_all_zonelists();
 	page_alloc_init();
 	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);

--

