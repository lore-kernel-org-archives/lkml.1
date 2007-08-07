Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbXHGHXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbXHGHXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 03:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757825AbXHGHUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 03:20:09 -0400
Received: from ozlabs.org ([203.10.76.45]:33990 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434AbXHGHUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 03:20:00 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 07 Aug 2007 17:19:53 +1000
Subject: [RFC/PATCH 10/12] remove call to flush_tlb_page() from handle_pte_fault()
In-Reply-To: <1186471185.826251.312410898174.qpush@grosgo>
Message-Id: <20070807071959.80DE9DDE05@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've asked several times what archs need that, got not reply, so
let's remove it. If an arch needs it, it should be done by that
arch implementation of ptep_set_access_flags() anyway.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 mm/memory.c |    9 ---------
 1 file changed, 9 deletions(-)

Index: linux-work/mm/memory.c
===================================================================
--- linux-work.orig/mm/memory.c	2007-08-07 16:23:53.000000000 +1000
+++ linux-work/mm/memory.c	2007-08-07 16:27:30.000000000 +1000
@@ -2605,15 +2605,6 @@ static inline int handle_pte_fault(struc
 	if (ptep_set_access_flags(vma, address, pte, entry, write_access)) {
 		update_mmu_cache(vma, address, entry);
 		lazy_mmu_prot_update(entry);
-	} else {
-		/*
-		 * This is needed only for protection faults but the arch code
-		 * is not yet telling us if this is a protection fault or not.
-		 * This still avoids useless tlb flushes for .text page faults
-		 * with threads.
-		 */
-		if (write_access)
-			flush_tlb_page(vma, address);
 	}
 unlock:
 	pte_unmap_unlock(pte, ptl);
