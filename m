Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbYBYAJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbYBYAJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbYBYAIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:08:17 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46644 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbYBYAIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:08:16 -0500
Date: Mon, 25 Feb 2008 02:07:21 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make mm/memory.c:print_bad_pte() static
Message-ID: <20080225000721.GD2088@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global print_bad_pte() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/mm.h |    1 -
 mm/memory.c        |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

cf47cf1dae0fe5b04b95ede85cac61c74f75c1c2 diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3b3e134..33d5ebe 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -777,7 +777,6 @@ extern int access_process_vm(struct task_struct *tsk, unsigned long addr, void *
 
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm, unsigned long start,
 		int len, int write, int force, struct page **pages, struct vm_area_struct **vmas);
-void print_bad_pte(struct vm_area_struct *, pte_t, unsigned long);
 
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);
diff --git a/mm/memory.c b/mm/memory.c
index ce3c9e4..fe624e4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -355,7 +355,8 @@ static inline void add_mm_rss(struct mm_struct *mm, int file_rss, int anon_rss)
  *
  * The calling function must still handle the error.
  */
-void print_bad_pte(struct vm_area_struct *vma, pte_t pte, unsigned long vaddr)
+static void print_bad_pte(struct vm_area_struct *vma, pte_t pte,
+			  unsigned long vaddr)
 {
 	printk(KERN_ERR "Bad pte = %08llx, process = %s, "
 			"vm_flags = %lx, vaddr = %lx\n",

