Return-Path: <linux-kernel-owner+w=401wt.eu-S1760409AbXGRF4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409AbXGRF4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbXGRF4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:56:38 -0400
Received: from havoc.gtf.org ([69.61.125.42]:38589 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXGRF4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:56:37 -0400
Date: Wed, 18 Jul 2007 01:56:35 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, ak@suse.de
Subject: [PATCH 3/3] x86-64: make flush_tlb_kernel_range() a static inline
	function
Message-ID: <20070718055635.GB5748@havoc.gtf.org>
References: <20070718055348.GA5734@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070718055348.GA5734@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following change was checked into 'warnings' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

commit b1c9131343597967d8fcc042f59e4ed36ea2855f
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed Jul 18 01:47:39 2007 -0400

    [X86-64] make flush_tlb_kernel_range() a static inline function
    
    On x86-64, without this change, the following warning is emitted
    
    mm/vmalloc.c: In function ‘unmap_kernel_range’:
    mm/vmalloc.c:75: warning: unused variable ‘start’
    
    because, x86-64, flush_tlb_kernel_range(start,end) evaluates down to
    flush_tlb_all(void) in a macro.
    
    Avoid this warning by implementing x86-64's flush_tlb_kernel_range() as
    a type-safe static inline, rather than a macro.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 include/asm-x86_64/tlbflush.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

b1c9131343597967d8fcc042f59e4ed36ea2855f
diff --git a/include/asm-x86_64/tlbflush.h b/include/asm-x86_64/tlbflush.h
index 8516225..a82464c 100644
--- a/include/asm-x86_64/tlbflush.h
+++ b/include/asm-x86_64/tlbflush.h
@@ -92,7 +92,11 @@ static inline void flush_tlb_range(struct vm_area_struct * vma, unsigned long st
 
 #endif
 
-#define flush_tlb_kernel_range(start, end) flush_tlb_all()
+static inline void flush_tlb_kernel_range(unsigned long start,
+					  unsigned long end)
+{
+	flush_tlb_all();
+}
 
 static inline void flush_tlb_pgtables(struct mm_struct *mm,
 				      unsigned long start, unsigned long end)
