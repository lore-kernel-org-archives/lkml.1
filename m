Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbZA1XaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbZA1XaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZA1X2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:28:13 -0500
Received: from kroah.org ([198.145.64.141]:56980 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756861AbZA1X2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:28:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/10] Staging: android: binder: fix arm build errors
Date: Wed, 28 Jan 2009 15:26:43 -0800
Message-Id: <1233185210-23098-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128232319.GA23009@kroah.com>
References: <20090128232319.GA23009@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/android/binder.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 6a4ceac..ab014bc 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2649,14 +2649,14 @@ static void binder_vma_open(struct vm_area_struct *vma)
 {
 	struct binder_proc *proc = vma->vm_private_data;
 	if (binder_debug_mask & BINDER_DEBUG_OPEN_CLOSE)
-		printk(KERN_INFO "binder: %d open vm area %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags, vma->vm_page_prot.pgprot);
+		printk(KERN_INFO "binder: %d open vm area %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags, pgprot_val(vma->vm_page_prot));
 	dump_stack();
 }
 static void binder_vma_close(struct vm_area_struct *vma)
 {
 	struct binder_proc *proc = vma->vm_private_data;
 	if (binder_debug_mask & BINDER_DEBUG_OPEN_CLOSE)
-		printk(KERN_INFO "binder: %d close vm area %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags, vma->vm_page_prot.pgprot);
+		printk(KERN_INFO "binder: %d close vm area %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags, pgprot_val(vma->vm_page_prot));
 	proc->vma = NULL;
 }
 
@@ -2677,7 +2677,7 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 		vma->vm_end = vma->vm_start + SZ_4M;
 
 	if (binder_debug_mask & BINDER_DEBUG_OPEN_CLOSE)
-		printk(KERN_INFO "binder_mmap: %d %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags, vma->vm_page_prot.pgprot);
+		printk(KERN_INFO "binder_mmap: %d %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags, pgprot_val(vma->vm_page_prot));
 
 	if (vma->vm_flags & FORBIDDEN_MMAP_FLAGS) {
 		ret = -EPERM;
-- 
1.6.0.2

