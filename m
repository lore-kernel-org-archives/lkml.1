Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbZBKV1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbZBKV1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757591AbZBKV0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:26:52 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:45218 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbZBKV0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:26:51 -0500
Date: Wed, 11 Feb 2009 13:15:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Subject: [PATCH 2/9] staging/android/binder: fix printk format warnings
Message-Id: <20090211131539.f391d6dd.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49934294.0062:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings in android binder:

drivers/staging/android/binder.c:2652: warning: format '%lx' expects type 'long unsigned int', but argument 7 has type 'pgprotval_t'
drivers/staging/android/binder.c:2659: warning: format '%lx' expects type 'long unsigned int', but argument 7 has type 'pgprotval_t'
drivers/staging/android/binder.c:2680: warning: format '%lx' expects type 'long unsigned int', but argument 7 has type 'pgprotval_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/android/binder.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- mmotm-2009-0210-1635.orig/drivers/staging/android/binder.c
+++ mmotm-2009-0210-1635/drivers/staging/android/binder.c
@@ -2649,14 +2649,22 @@ static void binder_vma_open(struct vm_ar
 {
 	struct binder_proc *proc = vma->vm_private_data;
 	if (binder_debug_mask & BINDER_DEBUG_OPEN_CLOSE)
-		printk(KERN_INFO "binder: %d open vm area %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags, pgprot_val(vma->vm_page_prot));
+		printk(KERN_INFO
+			"binder: %d open vm area %lx-%lx (%ld K) vma %lx pagep %lx\n",
+			proc->pid, vma->vm_start, vma->vm_end,
+			(vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags,
+			(unsigned long)pgprot_val(vma->vm_page_prot));
 	dump_stack();
 }
 static void binder_vma_close(struct vm_area_struct *vma)
 {
 	struct binder_proc *proc = vma->vm_private_data;
 	if (binder_debug_mask & BINDER_DEBUG_OPEN_CLOSE)
-		printk(KERN_INFO "binder: %d close vm area %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags, pgprot_val(vma->vm_page_prot));
+		printk(KERN_INFO
+			"binder: %d close vm area %lx-%lx (%ld K) vma %lx pagep %lx\n",
+			proc->pid, vma->vm_start, vma->vm_end,
+			(vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags,
+			(unsigned long)pgprot_val(vma->vm_page_prot));
 	proc->vma = NULL;
 }
 
@@ -2677,7 +2685,11 @@ static int binder_mmap(struct file *filp
 		vma->vm_end = vma->vm_start + SZ_4M;
 
 	if (binder_debug_mask & BINDER_DEBUG_OPEN_CLOSE)
-		printk(KERN_INFO "binder_mmap: %d %lx-%lx (%ld K) vma %lx pagep %lx\n", proc->pid, vma->vm_start, vma->vm_end, (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags, pgprot_val(vma->vm_page_prot));
+		printk(KERN_INFO
+			"binder_mmap: %d %lx-%lx (%ld K) vma %lx pagep %lx\n",
+			proc->pid, vma->vm_start, vma->vm_end,
+			(vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags,
+			(unsigned long)pgprot_val(vma->vm_page_prot));
 
 	if (vma->vm_flags & FORBIDDEN_MMAP_FLAGS) {
 		ret = -EPERM;
