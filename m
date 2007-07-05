Return-Path: <linux-kernel-owner+w=401wt.eu-S1763703AbXGEX0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763703AbXGEX0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763158AbXGEXXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:23:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52153 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762948AbXGEXXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:23:16 -0400
Date: Fri, 6 Jul 2007 01:23:45 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/vmstat.c: possible cleanups
Message-ID: <20070705232345.GG3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- make the needlessly global setup_vmstat() static
- #if 0 the unused refresh_vm_stats()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 mm/vmstat.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- linux-2.6.22-rc6-mm1/mm/vmstat.c.old	2007-07-05 16:54:39.000000000 +0200
+++ linux-2.6.22-rc6-mm1/mm/vmstat.c	2007-07-05 16:55:42.000000000 +0200
@@ -353,6 +353,8 @@
 	}
 }
 
+#if 0
+
 static void __refresh_cpu_vm_stats(void *dummy)
 {
 	refresh_cpu_vm_stats(smp_processor_id());
@@ -370,6 +372,8 @@
 }
 EXPORT_SYMBOL(refresh_vm_stats);
 
+#endif  /*  0  */
+
 #endif
 
 #ifdef CONFIG_NUMA
@@ -957,7 +961,7 @@
 static struct notifier_block __cpuinitdata vmstat_notifier =
 	{ &vmstat_cpuup_callback, NULL, 0 };
 
-int __init setup_vmstat(void)
+static int __init setup_vmstat(void)
 {
 	int cpu;
 

