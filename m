Return-Path: <linux-kernel-owner+w=401wt.eu-S934642AbXG2PXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934642AbXG2PXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765732AbXG2PEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:04:04 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47966 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765723AbXG2PEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:04:02 -0400
Date: Sun, 29 Jul 2007 17:03:38 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/vmstat.c: cleanups
Message-ID: <20070729150338.GI16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the needlessly global setup_vmstat() static
- remove the unused refresh_vm_stats()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Christoph Lameter <clameter@sgi.com>

---

This patch has been sent on:
- 9 Jul 2007

 mm/vmstat.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- linux-2.6.22-rc6-mm1/mm/vmstat.c.old	2007-07-05 16:54:39.000000000 +0200
+++ linux-2.6.22-rc6-mm1/mm/vmstat.c	2007-07-08 22:27:26.000000000 +0200
@@ -353,23 +353,6 @@
 	}
 }
 
-static void __refresh_cpu_vm_stats(void *dummy)
-{
-	refresh_cpu_vm_stats(smp_processor_id());
-}
-
-/*
- * Consolidate all counters.
- *
- * Note that the result is less inaccurate but still inaccurate
- * if concurrent processes are allowed to run.
- */
-void refresh_vm_stats(void)
-{
-	on_each_cpu(__refresh_cpu_vm_stats, NULL, 0, 1);
-}
-EXPORT_SYMBOL(refresh_vm_stats);
-
 #endif
 
 #ifdef CONFIG_NUMA
@@ -957,7 +940,7 @@
 static struct notifier_block __cpuinitdata vmstat_notifier =
 	{ &vmstat_cpuup_callback, NULL, 0 };
 
-int __init setup_vmstat(void)
+static int __init setup_vmstat(void)
 {
 	int cpu;
 

