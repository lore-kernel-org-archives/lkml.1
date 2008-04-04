Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYDDWep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYDDWep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 18:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYDDWbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 18:31:46 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52701 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752704AbYDDWbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 18:31:38 -0400
Message-Id: <20080404223132.734091146@sgi.com>
References: <20080404223048.374852899@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 15:30:55 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Dean Nelson <dcn@sgi.com>
Cc: kvm-devel@lists.sourceforge.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 07/10] xpmem: This patch exports zap_page_range as it is needed by XPMEM.
Content-Disposition: inline; filename=xpmem_v003_export-zap_page_range
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XPMEM would have used sys_madvise() except that madvise_dontneed()
returns an -EINVAL if VM_PFNMAP is set, which is always true for the pages
XPMEM imports from other partitions and is also true for uncached pages
allocated locally via the mspec allocator.  XPMEM needs zap_page_range()
functionality for these types of pages as well as 'normal' pages.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---
 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2008-04-01 13:02:43.902651345 -0700
+++ linux-2.6/mm/memory.c	2008-04-01 13:04:43.720691616 -0700
@@ -901,6 +901,7 @@ unsigned long zap_page_range(struct vm_a
 
 	return unmap_vmas(vma, address, end, &nr_accounted, details);
 }
+EXPORT_SYMBOL_GPL(zap_page_range);
 
 /*
  * Do a quick page-table lookup for a single page.

-- 
