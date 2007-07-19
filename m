Return-Path: <linux-kernel-owner+w=401wt.eu-S938447AbXGSK0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938447AbXGSK0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758956AbXGSJ4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:56:14 -0400
Received: from mx1.suse.de ([195.135.220.2]:35459 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758691AbXGSJzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:51 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: akpm@linux-foundation.org, ak@suse.de, benh@kernel.crashing.org,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [55/58] i386: add reference to the arguments
Message-Id: <20070719095542.6A05714E05@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@linux-foundation.org>

Prevent stuff like this:

mm/vmalloc.c: In function 'unmap_kernel_range':
mm/vmalloc.c:75: warning: unused variable 'start'

Cc: Andi Kleen <ak@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-i386/tlbflush.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/include/asm-i386/tlbflush.h
===================================================================
--- linux.orig/include/asm-i386/tlbflush.h
+++ linux/include/asm-i386/tlbflush.h
@@ -160,7 +160,11 @@ DECLARE_PER_CPU(struct tlb_state, cpu_tl
 	native_flush_tlb_others(&mask, mm, va)
 #endif
 
-#define flush_tlb_kernel_range(start, end) flush_tlb_all()
+static inline void flush_tlb_kernel_range(unsigned long start,
+					unsigned long end)
+{
+	flush_tlb_all();
+}
 
 static inline void flush_tlb_pgtables(struct mm_struct *mm,
 				      unsigned long start, unsigned long end)
