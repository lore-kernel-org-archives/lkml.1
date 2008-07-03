Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYGCVk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYGCVk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbYGCVgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:36:47 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50780 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754863AbYGCVgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:36:37 -0400
Message-Id: <20080703213633.890647632@attica.americas.sgi.com>
References: <20080703213348.489120321@attica.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jul 2008 16:34:00 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: [patch 12/13] GRU Driver V3 -  export is_uv_system(), zap_page_range() & follow_page()
Content-Disposition: inline; filename=grup_mm_exports
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exports needed by the GRU driver.


Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 mm/memory.c               |    2 ++

---
 arch/x86/kernel/genapic_64.c |    1 +
 mm/memory.c                  |    2 ++
 2 files changed, 3 insertions(+)

Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c	2008-07-03 15:57:13.000000000 -0500
+++ linux/mm/memory.c	2008-07-03 16:19:09.000000000 -0500
@@ -995,6 +995,7 @@ unsigned long zap_page_range(struct vm_a
 		tlb_finish_mmu(tlb, address, end);
 	return end;
 }
+EXPORT_SYMBOL_GPL(zap_page_range);
 
 /*
  * Do a quick page-table lookup for a single page.
@@ -1089,6 +1090,7 @@ no_page_table:
 	}
 	return page;
 }
+EXPORT_SYMBOL_GPL(follow_page);
 
 /* Can we do the FOLL_ANON optimization? */
 static inline int use_zero_page(struct vm_area_struct *vma)
Index: linux/arch/x86/kernel/genapic_64.c
===================================================================
--- linux.orig/arch/x86/kernel/genapic_64.c	2008-07-03 15:59:07.000000000 -0500
+++ linux/arch/x86/kernel/genapic_64.c	2008-07-03 16:19:09.000000000 -0500
@@ -102,3 +102,4 @@ int is_uv_system(void)
 {
 	return uv_system_type != UV_NONE;
 }
+EXPORT_SYMBOL_GPL(is_uv_system);

-- 
