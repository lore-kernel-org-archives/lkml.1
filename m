Return-Path: <linux-kernel-owner+w=401wt.eu-S1763671AbXGEX0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763671AbXGEX0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762956AbXGEXXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:23:22 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52155 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762320AbXGEXXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:23:20 -0400
Date: Fri, 6 Jul 2007 01:23:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/shmem.c: make 3 functions static
Message-ID: <20070705232350.GH3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes three needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/linux/mm.h |   15 ---------------
 mm/shmem.c         |   10 +++++-----
 2 files changed, 5 insertions(+), 20 deletions(-)

--- linux-2.6.22-rc6-mm1/include/linux/mm.h.old	2007-07-05 17:03:26.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/linux/mm.h	2007-07-05 17:03:45.000000000 +0200
@@ -707,9 +707,6 @@
 extern void show_free_areas(void);
 
 #ifdef CONFIG_SHMEM
-int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *new);
-struct mempolicy *shmem_get_policy(struct vm_area_struct *vma,
-					unsigned long addr);
 int shmem_lock(struct file *file, int lock, struct user_struct *user);
 #else
 static inline int shmem_lock(struct file *file, int lock,
@@ -717,18 +714,6 @@
 {
 	return 0;
 }
-
-static inline int shmem_set_policy(struct vm_area_struct *vma,
-				   struct mempolicy *new)
-{
-	return 0;
-}
-
-static inline struct mempolicy *shmem_get_policy(struct vm_area_struct *vma,
-						 unsigned long addr)
-{
-	return NULL;
-}
 #endif
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags);
 
--- linux-2.6.22-rc6-mm1/mm/shmem.c.old	2007-07-05 17:04:00.000000000 +0200
+++ linux-2.6.22-rc6-mm1/mm/shmem.c	2007-07-05 17:06:27.000000000 +0200
@@ -1025,8 +1025,8 @@
 	return page;
 }
 
-struct page *shmem_swapin(struct shmem_inode_info *info, swp_entry_t entry,
-			  unsigned long idx)
+static struct page *shmem_swapin(struct shmem_inode_info *info,
+				 swp_entry_t entry, unsigned long idx)
 {
 	struct shared_policy *p = &info->policy;
 	int i, num;
@@ -1335,14 +1335,14 @@
 }
 
 #ifdef CONFIG_NUMA
-int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
+static int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
 {
 	struct inode *i = vma->vm_file->f_path.dentry->d_inode;
 	return mpol_set_shared_policy(&SHMEM_I(i)->policy, vma, new);
 }
 
-struct mempolicy *
-shmem_get_policy(struct vm_area_struct *vma, unsigned long addr)
+static struct mempolicy *shmem_get_policy(struct vm_area_struct *vma,
+					  unsigned long addr)
 {
 	struct inode *i = vma->vm_file->f_path.dentry->d_inode;
 	unsigned long idx;

