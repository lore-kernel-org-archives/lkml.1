Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYKMRUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYKMRUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYKMRTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:19:50 -0500
Received: from gw.goop.org ([64.81.55.164]:41660 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbYKMRTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:19:49 -0500
Message-ID: <491C61B5.7020004@goop.org>
Date: Thu, 13 Nov 2008 09:19:49 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: [PATCH 2/2] mm/apply_to_range: call pte function with lazy updates
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the pte-level function in apply_to_range be called in lazy mmu
mode, so that any pagetable modifications can be batched.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 mm/memory.c |    4 ++++
 1 file changed, 4 insertions(+)

===================================================================
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1545,6 +1545,8 @@
 
 	BUG_ON(pmd_huge(*pmd));
 
+	arch_enter_lazy_mmu_mode();
+
 	token = pmd_pgtable(*pmd);
 
 	do {
@@ -1552,6 +1554,8 @@
 		if (err)
 			break;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
+
+	arch_leave_lazy_mmu_mode();
 
 	if (mm != &init_mm)
 		pte_unmap_unlock(pte-1, ptl);


