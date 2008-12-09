Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbYLITGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbYLITGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 14:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbYLITGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 14:06:37 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:41456 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbYLITGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 14:06:36 -0500
Date: Tue, 9 Dec 2008 19:06:30 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: "Helight.Xu" <zhwenxu@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       ZhenwenXu <helight.xu@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] fix coding style of mm/mmap.c
In-Reply-To: <20081209075652.GA3515@helight>
Message-ID: <Pine.LNX.4.64.0812091837380.28534@blonde.anvils>
References: <20081209075652.GA3515@helight>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, thanks for this.

Though, to be honest, we're not all that keen on random cleanups of
this kind: they can cause more trouble than they're worth, when real
development is going on in the area - better leave them to those who
are working on bigger changes nearby.

But mm/mmap.c is currently the same in mmotm as in Linus's git
(though slightly different from the 2.6.27 version in your patch -
I've rediffed it below), so it shouldn't cause anyone much trouble:
Andrew, please add to mmotm.  (scripts/checkpatch.pl does warn on
the long acct_stack_growth line, but Zhenwen has made it a little
shorter, and people disagree about long function declaration lines.)

Please inline your patches in future, so all can see them at a glance:
ah, you're using gmail, yes, that does mess them up - I believe there's
advice on how to configure it for sending Linux patches somewhere in
the archives, but I didn't find it in Documentation/SubmittingPatches
just now, sorry.

Hugh


[PATCH] fix coding style of mm/mmap.c

From: ZhenwenXu <helight.xu@gmail.com>

Fix a little of the coding style in mm/mmap.c 

Signed-off-by: ZhenwenXu <helight.xu@gmail.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/mmap.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -413,7 +413,7 @@ void __vma_link_rb(struct mm_struct *mm,
 
 static void __vma_link_file(struct vm_area_struct *vma)
 {
-	struct file * file;
+	struct file *file;
 
 	file = vma->vm_file;
 	if (file) {
@@ -475,10 +475,10 @@ static void vma_link(struct mm_struct *m
  * but it has already been inserted into prio_tree earlier.
  */
 static void
-__insert_vm_struct(struct mm_struct * mm, struct vm_area_struct * vma)
+__insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	struct vm_area_struct * __vma, * prev;
-	struct rb_node ** rb_link, * rb_parent;
+	struct vm_area_struct *__vma, *prev;
+	struct rb_node **rb_link, *rb_parent;
 
 	__vma = find_vma_prepare(mm, vma->vm_start,&prev, &rb_link, &rb_parent);
 	BUG_ON(__vma && __vma->vm_start < vma->vm_end);
@@ -908,7 +908,7 @@ void vm_stat_account(struct mm_struct *m
  * The caller must hold down_write(current->mm->mmap_sem).
  */
 
-unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
+unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 			unsigned long len, unsigned long prot,
 			unsigned long flags, unsigned long pgoff)
 {
@@ -1464,7 +1464,7 @@ get_unmapped_area(struct file *file, uns
 EXPORT_SYMBOL(get_unmapped_area);
 
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
-struct vm_area_struct * find_vma(struct mm_struct * mm, unsigned long addr)
+struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
 	struct vm_area_struct *vma = NULL;
 
@@ -1507,7 +1507,7 @@ find_vma_prev(struct mm_struct *mm, unsi
 			struct vm_area_struct **pprev)
 {
 	struct vm_area_struct *vma = NULL, *prev = NULL;
-	struct rb_node * rb_node;
+	struct rb_node *rb_node;
 	if (!mm)
 		goto out;
 
@@ -1541,7 +1541,7 @@ out:
  * update accounting. This is shared with both the
  * grow-up and grow-down cases.
  */
-static int acct_stack_growth(struct vm_area_struct * vma, unsigned long size, unsigned long grow)
+static int acct_stack_growth(struct vm_area_struct *vma, unsigned long size, unsigned long grow)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct rlimit *rlim = current->signal->rlim;
