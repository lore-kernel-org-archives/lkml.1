Return-Path: <linux-kernel-owner+w=401wt.eu-S938432AbXGSN5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938432AbXGSN5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762312AbXGSNsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761540AbXGSNst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:49 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [18/48] x86_64: flush_tlb_kernel_range() warning fix
Message-Id: <20070719134847.B12C814E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@linux-foundation.org>

mm/vmalloc.c: In function 'unmap_kernel_range':
mm/vmalloc.c:75: warning: unused variable 'start'

make it a C function so that the compiler thinks it used its arguments.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-x86_64/tlbflush.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/include/asm-x86_64/tlbflush.h
===================================================================
--- linux.orig/include/asm-x86_64/tlbflush.h
+++ linux/include/asm-x86_64/tlbflush.h
@@ -92,7 +92,11 @@ static inline void flush_tlb_range(struc
 
 #endif
 
-#define flush_tlb_kernel_range(start, end) flush_tlb_all()
+static inline void flush_tlb_kernel_range(unsigned long start,
+					unsigned long end)
+{
+	flush_tlb_all();
+}
 
 static inline void flush_tlb_pgtables(struct mm_struct *mm,
 				      unsigned long start, unsigned long end)
