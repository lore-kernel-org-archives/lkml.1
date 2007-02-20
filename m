Return-Path: <linux-kernel-owner+w=401wt.eu-S965609AbXBTALJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965609AbXBTALJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbXBTAIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:08:15 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36137 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965583AbXBTAHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:07:55 -0500
Date: Tue, 20 Feb 2007 01:07:54 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] mm/{,tiny-}shmem.c cleanups
Message-ID: <20070220000754.GG13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm3:
>...
> +shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
>...
>  Misc
>...


shmem_{nopage,mmap} are no longer used in ipc/shm.c

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/linux/mm.h |    5 -----
 mm/shmem.c         |    5 +++--
 mm/tiny-shmem.c    |    2 ++
 3 files changed, 5 insertions(+), 7 deletions(-)

--- linux-2.6.20-mm2/include/linux/mm.h.old	2007-02-18 23:32:54.000000000 +0100
+++ linux-2.6.20-mm2/include/linux/mm.h	2007-02-18 23:34:02.000000000 +0100
@@ -662,15 +662,11 @@
 extern void show_free_areas(void);
 
 #ifdef CONFIG_SHMEM
-struct page *shmem_nopage(struct vm_area_struct *vma,
-			unsigned long address, int *type);
 int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *new);
 struct mempolicy *shmem_get_policy(struct vm_area_struct *vma,
 					unsigned long addr);
 int shmem_lock(struct file *file, int lock, struct user_struct *user);
 #else
-#define shmem_nopage filemap_nopage
-
 static inline int shmem_lock(struct file *file, int lock,
 			     struct user_struct *user)
 {
@@ -690,7 +686,6 @@
 }
 #endif
 struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags);
-extern int shmem_mmap(struct file *file, struct vm_area_struct *vma);
 
 int shmem_zero_setup(struct vm_area_struct *);
 
--- linux-2.6.20-mm2/mm/shmem.c.old	2007-02-18 23:33:38.000000000 +0100
+++ linux-2.6.20-mm2/mm/shmem.c	2007-02-18 23:34:14.000000000 +0100
@@ -1227,7 +1227,8 @@
 	return error;
 }
 
-struct page *shmem_nopage(struct vm_area_struct *vma, unsigned long address, int *type)
+static struct page *shmem_nopage(struct vm_area_struct *vma,
+				 unsigned long address, int *type)
 {
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	struct page *page = NULL;
@@ -1334,7 +1335,7 @@
 	return retval;
 }
 
-int shmem_mmap(struct file *file, struct vm_area_struct *vma)
+static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	file_accessed(file);
 	vma->vm_ops = &shmem_vm_ops;
--- linux-2.6.20-mm2/mm/tiny-shmem.c.old	2007-02-18 23:34:21.000000000 +0100
+++ linux-2.6.20-mm2/mm/tiny-shmem.c	2007-02-18 23:34:57.000000000 +0100
@@ -126,6 +126,7 @@
 	return 0;
 }
 
+#if 0
 int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	file_accessed(file);
@@ -135,6 +136,7 @@
 	return 0;
 #endif
 }
+#endif  /*  0  */
 
 #ifndef CONFIG_MMU
 unsigned long shmem_get_unmapped_area(struct file *file,

