Return-Path: <linux-kernel-owner+w=401wt.eu-S934012AbXHORni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012AbXHORni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760750AbXHORna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:43:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50916 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751154AbXHORn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:43:29 -0400
Date: Wed, 15 Aug 2007 12:43:26 -0500
To: akpm@linux-foundation.org
Cc: npiggin@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] calculation of pgoff in do_linear_fault() uses mixed 
 units
Message-ID: <46C33B3E.mailxBSH11HDLW@aqua.americas.sgi.com>
User-Agent: nail 11.4 8/29/04
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: dcn@sgi.com (Dean Nelson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The calculation of pgoff in do_linear_fault() should use PAGE_SHIFT and not
PAGE_CACHE_SHIFT since vma->vm_pgoff is in units of PAGE_SIZE and not
PAGE_CACHE_SIZE. At the moment linux/pagemap.h has PAGE_CACHE_SHIFT defined
as PAGE_SHIFT, but should that ever change this calculation would break.

Signed-off-by: Dean Nelson <dcn@sgi.com>


Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2007-08-14 06:42:18.322378070 -0500
+++ linux-2.6/mm/memory.c	2007-08-15 12:30:51.621604739 -0500
@@ -2465,7 +2465,7 @@
 		int write_access, pte_t orig_pte)
 {
 	pgoff_t pgoff = (((address & PAGE_MASK)
-			- vma->vm_start) >> PAGE_CACHE_SHIFT) + vma->vm_pgoff;
+			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);
 
 	return __do_fault(mm, vma, address, page_table, pmd, pgoff,
