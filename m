Return-Path: <linux-kernel-owner+w=401wt.eu-S1761113AbYBYALg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761113AbYBYALg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbYBYAJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:09:29 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33663 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759919AbYBYAJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:09:26 -0500
Date: Mon, 25 Feb 2008 02:08:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper prototype for show_numa_map()
Message-ID: <20080225000830.GK2088@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper prototype for show_numa_map()
in include/linux/mempolicy.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/proc/task_mmu.c        |    2 --
 include/linux/mempolicy.h |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

75c93e5637cf3337f8dcd2713bac390dec1cc987 diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 6dc0334..624faf1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -721,8 +721,6 @@ const struct file_operations proc_pagemap_operations = {
 #endif /* CONFIG_PROC_PAGE_MONITOR */
 
 #ifdef CONFIG_NUMA
-extern int show_numa_map(struct seq_file *m, void *v);
-
 static int show_numa_map_checked(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 59c4865..914fa6e 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -37,6 +37,7 @@
 
 struct vm_area_struct;
 struct mm_struct;
+struct seq_file;
 
 #ifdef CONFIG_NUMA
 
@@ -165,6 +166,8 @@ static inline void check_highest_zone(enum zone_type k)
 int do_migrate_pages(struct mm_struct *mm,
 	const nodemask_t *from_nodes, const nodemask_t *to_nodes, int flags);
 
+int show_numa_map(struct seq_file *m, void *v);
+
 #else
 
 struct mempolicy {};

