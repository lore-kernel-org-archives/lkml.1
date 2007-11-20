Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbXKTBTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbXKTBTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXKTBNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:53 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49852 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754297AbXKTBNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:36 -0500
Message-Id: <20071120011336.210236732@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:51 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 19/45] cpu alloc: NFS statistics
Content-Disposition: inline; filename=0027-cpu-alloc-NFS-statistics.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/nfs/iostat.h |    8 ++++----
 fs/nfs/super.c  |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/fs/nfs/iostat.h
===================================================================
--- linux-2.6.orig/fs/nfs/iostat.h	2007-11-15 21:17:24.391404458 -0800
+++ linux-2.6/fs/nfs/iostat.h	2007-11-15 21:25:33.167654066 -0800
@@ -123,7 +123,7 @@ static inline void nfs_inc_server_stats(
 	int cpu;
 
 	cpu = get_cpu();
-	iostats = per_cpu_ptr(server->io_stats, cpu);
+	iostats = CPU_PTR(server->io_stats, cpu);
 	iostats->events[stat] ++;
 	put_cpu_no_resched();
 }
@@ -139,7 +139,7 @@ static inline void nfs_add_server_stats(
 	int cpu;
 
 	cpu = get_cpu();
-	iostats = per_cpu_ptr(server->io_stats, cpu);
+	iostats = CPU_PTR(server->io_stats, cpu);
 	iostats->bytes[stat] += addend;
 	put_cpu_no_resched();
 }
@@ -151,13 +151,13 @@ static inline void nfs_add_stats(struct 
 
 static inline struct nfs_iostats *nfs_alloc_iostats(void)
 {
-	return alloc_percpu(struct nfs_iostats);
+	return CPU_ALLOC(struct nfs_iostats, GFP_KERNEL | __GFP_ZERO);
 }
 
 static inline void nfs_free_iostats(struct nfs_iostats *stats)
 {
 	if (stats != NULL)
-		free_percpu(stats);
+		CPU_FREE(stats);
 }
 
 #endif
Index: linux-2.6/fs/nfs/super.c
===================================================================
--- linux-2.6.orig/fs/nfs/super.c	2007-11-15 21:17:24.399404478 -0800
+++ linux-2.6/fs/nfs/super.c	2007-11-15 21:25:33.171654143 -0800
@@ -529,7 +529,7 @@ static int nfs_show_stats(struct seq_fil
 		struct nfs_iostats *stats;
 
 		preempt_disable();
-		stats = per_cpu_ptr(nfss->io_stats, cpu);
+		stats = CPU_PTR(nfss->io_stats, cpu);
 
 		for (i = 0; i < __NFSIOS_COUNTSMAX; i++)
 			totals.events[i] += stats->events[i];

-- 
