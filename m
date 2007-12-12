Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbXLLPVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbXLLPVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbXLLPUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:20:42 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:20196
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659AbXLLPUj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:20:39 -0500
Message-Id: <47600A8A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 12 Dec 2007 15:21:30 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tony.luck@intel.com>
Cc: <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ia64: make flush_tlb_kernel_range() an inline function
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes an unused variable warning in mm/vmalloc.c.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 include/asm-ia64/tlbflush.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- linux-2.6.24-rc5/include/asm-ia64/tlbflush.h	2007-12-12 12:27:38.000000000 +0100
+++ 2.6.24-rc5-ia64-flush-tlb-kernel-range/include/asm-ia64/tlbflush.h	2007-12-12 15:24:27.000000000 +0100
@@ -92,6 +92,10 @@ void smp_local_flush_tlb(void);
 #define smp_local_flush_tlb()
 #endif
 
-#define flush_tlb_kernel_range(start, end)	flush_tlb_all()	/* XXX fix me */
+static inline void flush_tlb_kernel_range(unsigned long start,
+					  unsigned long end)
+{
+	flush_tlb_all();	/* XXX fix me */
+}
 
 #endif /* _ASM_IA64_TLBFLUSH_H */



