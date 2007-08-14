Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbXHNLgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbXHNLgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 07:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbXHNLgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 07:36:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52869 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754588AbXHNLgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 07:36:36 -0400
Date: Tue, 14 Aug 2007 06:36:31 -0500
To: npiggin@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] calculation of pgoff in do_linear_fault() uses mixed 
 units
Message-ID: <46C193BF.mailxDHL111USQ@aqua.americas.sgi.com>
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
--- linux-2.6.orig/mm/memory.c	2007-08-10 09:11:32.000000000 -0500
+++ linux-2.6/mm/memory.c	2007-08-14 06:26:11.731319983 -0500
@@ -2466,7 +2466,7 @@
 		int write_access, pte_t orig_pte)
 {
 	pgoff_t pgoff = (((address & PAGE_MASK)
-			- vma->vm_start) >> PAGE_CACHE_SHIFT) + vma->vm_pgoff;
+			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);
 
 	return __do_fault(mm, vma, address, page_table, pmd, pgoff,
