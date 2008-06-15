Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbYFOOFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYFOOFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 10:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758684AbYFOOBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 10:01:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47039 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757820AbYFOOAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 10:00:18 -0400
Message-Id: <20080615140014.265436014@attica.americas.sgi.com>
References: <20080615135906.091354918@attica.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jun 2008 08:59:18 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: [patch 12/13] GRU Driver V2 - Export is_uv_system(), zap_page_range() & follow_page()
Content-Disposition: inline; filename=grup_mm_exports
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exports for the GRU driver


Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 mm/memory.c               |    2 ++

---
 arch/x86/kernel/genapic_64.c |    1 +
 mm/memory.c                  |    2 ++
 2 files changed, 3 insertions(+)

Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c	2008-06-14 10:14:18.529134316 -0500
+++ linux/mm/memory.c	2008-06-14 19:02:34.635257646 -0500
@@ -955,6 +955,7 @@ unsigned long zap_page_range(struct vm_a
 		tlb_finish_mmu(tlb, address, end);
 	return end;
 }
+EXPORT_SYMBOL_GPL(zap_page_range);
 
 /*
  * Do a quick page-table lookup for a single page.
@@ -1037,6 +1038,7 @@ no_page_table:
 	}
 	return page;
 }
+EXPORT_SYMBOL_GPL(follow_page);
 
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned long start, int len, int write, int force,
Index: linux/arch/x86/kernel/genapic_64.c
===================================================================
--- linux.orig/arch/x86/kernel/genapic_64.c	2008-06-14 19:02:31.000000000 -0500
+++ linux/arch/x86/kernel/genapic_64.c	2008-06-14 19:03:37.863114445 -0500
@@ -99,3 +99,4 @@ int is_uv_system(void)
 {
 	return uv_system_type != UV_NONE;
 }
+EXPORT_SYMBOL_GPL(is_uv_system);

-- 
