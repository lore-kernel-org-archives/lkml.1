Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbXGIO5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbXGIO5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 10:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbXGIO4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 10:56:50 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:55599 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754038AbXGIO4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 10:56:48 -0400
Date: Mon, 9 Jul 2007 16:57:20 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/vmstat.c: cleanups
Message-ID: <20070709145720.GB3492@stusta.de>
References: <20070705232345.GG3492@stusta.de> <Pine.LNX.4.64.0707061048310.30575@schroedinger.engr.sgi.com> <20070706181350.GO3492@stusta.de> <Pine.LNX.4.64.0707061221330.24163@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707061221330.24163@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 12:21:52PM -0700, Christoph Lameter wrote:
> On Fri, 6 Jul 2007, Adrian Bunk wrote:
> 
> > > Hmmm... This may be needed by the cpu idle code to update the vm stats 
> > > before going idle.
> > 
> > Since 1 year it's making the kernel image larger without having a single 
> > user.
> > 
> > And if it will one day get a user, removing the #if 0 will be trivial.
> 
> Then just remove the whole function. the #if 0 is ugly.

Updated patch below.

cu
Adrian


<--  snip  -->


This patch contains the following cleanups:
- make the needlessly global setup_vmstat() static
- remove the unused refresh_vm_stats()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

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
 

