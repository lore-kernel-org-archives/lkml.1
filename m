Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbXHGHUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbXHGHUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 03:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbXHGHTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 03:19:54 -0400
Received: from ozlabs.org ([203.10.76.45]:33986 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbXHGHTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 03:19:53 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 07 Aug 2007 17:19:46 +1000
Subject: [RFC/PATCH 1/12] remove frv usage of flush_tlb_pgtables()
In-Reply-To: <1186471185.826251.312410898174.qpush@grosgo>
Message-Id: <20070807071952.E421FDDE09@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

frv is the last user in the tree of that dubious hook, and it's my
understanding that it's not even needed. It's only called by memory.c
free_pgd_range() which is always called within an mmu_gather, and
tlb_flush() on frv will do a flush_tlb_mm(), which from my reading
of the code, seems to do what flush_tlb_ptables() does, which is
to clear the cached PGE.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 include/asm-frv/tlbflush.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-work/include/asm-frv/tlbflush.h
===================================================================
--- linux-work.orig/include/asm-frv/tlbflush.h	2007-07-27 09:40:38.000000000 +1000
+++ linux-work/include/asm-frv/tlbflush.h	2007-07-27 09:43:17.000000000 +1000
@@ -57,8 +57,7 @@ do {								\
 #define __flush_tlb_global()			flush_tlb_all()
 #define flush_tlb()				flush_tlb_all()
 #define flush_tlb_kernel_range(start, end)	flush_tlb_all()
-#define flush_tlb_pgtables(mm,start,end) \
-	asm volatile("movgs %0,scr0 ! movgs %0,scr1" :: "r"(ULONG_MAX) : "memory");
+#define flush_tlb_pgtables(mm,start,end)	do { } while(0)
 
 #else
 
