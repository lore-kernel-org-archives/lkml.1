Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbXEVXYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbXEVXYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbXEVXYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:24:42 -0400
Received: from deeprooted.net ([216.254.16.51]:40436 "EHLO paris.hilman.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756173AbXEVXYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:24:42 -0400
X-Greylist: delayed 1269 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 19:24:41 EDT
Message-Id: <20070522230128.891568116@mvista.com>
User-Agent: quilt/0.45-1
Date: Tue, 22 May 2007 16:01:28 -0700
From: Kevin Hilman <khilman@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -rt] ARM TLB flush fix: don't forget to re-enable preemption
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a preempt_enable() to flush_tlb_kernel_page() since -rt4 patch
adds a preempt_disable but no preempt_enable().

Signed-off-by: Kevin Hilman <khilman@mvista.com>


---
 include/asm-arm/tlbflush.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.21/include/asm-arm/tlbflush.h
===================================================================
--- linux-2.6.21.orig/include/asm-arm/tlbflush.h
+++ linux-2.6.21/include/asm-arm/tlbflush.h
@@ -378,6 +378,7 @@ static inline void local_flush_tlb_kerne
 		asm("mcr p15, 0, %0, c8, c6, 1" : : "r" (kaddr) : "cc");
 	if (tlb_flag(TLB_V6_I_PAGE))
 		asm("mcr p15, 0, %0, c8, c5, 1" : : "r" (kaddr) : "cc");
+	preempt_enable();
 
 	if (tlb_flag(TLB_V6_I_FULL | TLB_V6_D_FULL |
 		     TLB_V6_I_PAGE | TLB_V6_D_PAGE |
--
