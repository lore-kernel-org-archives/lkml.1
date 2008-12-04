Return-Path: <linux-kernel-owner+w=401wt.eu-S1757810AbYLDVS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810AbYLDVS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 16:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYLDVSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 16:18:50 -0500
Received: from waste.org ([66.93.16.53]:42198 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbYLDVSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 16:18:49 -0500
Subject: [PATCH] shmem: remove unused shmem_get_unmapped_area
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       dhowells <dhowells@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 15:18:10 -0600
Message-Id: <1228425490.3255.119.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r b4d73844205b -r 8a9f1e9c46e8 include/linux/mm.h
--- a/include/linux/mm.h	Wed Dec 03 16:45:56 2008 -0800
+++ b/include/linux/mm.h	Mon Oct 27 17:33:21 2008 -0500
@@ -717,14 +717,6 @@
 
 int shmem_zero_setup(struct vm_area_struct *);
 
-#ifndef CONFIG_MMU
-extern unsigned long shmem_get_unmapped_area(struct file *file,
-					     unsigned long addr,
-					     unsigned long len,
-					     unsigned long pgoff,
-					     unsigned long flags);
-#endif
-
 extern int can_do_mlock(void);
 extern int user_shm_lock(size_t, struct user_struct *);
 extern void user_shm_unlock(size_t, struct user_struct *);
diff -r b4d73844205b -r 8a9f1e9c46e8 mm/tiny-shmem.c
--- a/mm/tiny-shmem.c	Wed Dec 03 16:45:56 2008 -0800
+++ b/mm/tiny-shmem.c	Mon Oct 27 17:33:21 2008 -0500
@@ -121,14 +121,3 @@
 {
 	return 0;
 }
-
-#ifndef CONFIG_MMU
-unsigned long shmem_get_unmapped_area(struct file *file,
-				      unsigned long addr,
-				      unsigned long len,
-				      unsigned long pgoff,
-				      unsigned long flags)
-{
-	return ramfs_nommu_get_unmapped_area(file, addr, len, pgoff, flags);
-}
-#endif

-- 
Mathematics is the supreme nostalgia of our time.

