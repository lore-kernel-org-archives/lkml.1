Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbYKVReE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbYKVReE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759075AbYKVRdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:33:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55292 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759065AbYKVRdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:33:45 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 3/32] powerpc set_huge_psize() false positive
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wMa-0006Hj-I9@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:33:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


called only from __init, calls __init.  Incidentally, it ought to be static
in file.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/include/asm/mmu-hash64.h |    1 -
 arch/powerpc/mm/hugetlbpage.c         |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu-hash64.h b/arch/powerpc/include/asm/mmu-hash64.h
--- a/arch/powerpc/include/asm/mmu-hash64.h
+++ b/arch/powerpc/include/asm/mmu-hash64.h
@@ -280,7 +280,6 @@ extern int hash_huge_page(struct mm_struct *mm, unsigned long access,
 extern int htab_bolt_mapping(unsigned long vstart, unsigned long vend,
 			     unsigned long pstart, unsigned long prot,
 			     int psize, int ssize);
-extern void set_huge_psize(int psize);
 extern void add_gpage(unsigned long addr, unsigned long page_size,
 			  unsigned long number_of_pages);
 extern void demote_segment_4k(struct mm_struct *mm, unsigned long addr);
diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -677,7 +677,7 @@ repeat:
 	return err;
 }
 
-void set_huge_psize(int psize)
+static void __init set_huge_psize(int psize)
 {
 	/* Check that it is a page size supported by the hardware and
 	 * that it fits within pagetable limits. */
