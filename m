Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbXGZXu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbXGZXu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbXGZXut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:50:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:44430 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579AbXGZXus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:50:48 -0400
Subject: [PATCH/RFC] remove frv usage of flush_tlb_pgtables()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: dhowells@redhat.com
Cc: linux-mm <linux-mm@kvack.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 09:50:38 +1000
Message-Id: <1185493838.5495.144.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
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

Hi David ! I want to get rid of flush_tlb_pgtables() as part of my
work on the mmu_gather and frv seems to be the only one to still use it.
I don't think it needs it though, can you double check ?

Thanks !
Ben.

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
 


