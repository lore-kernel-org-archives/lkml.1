Return-Path: <linux-kernel-owner+w=401wt.eu-S1760511AbYDAU75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbYDAU75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759646AbYDAU7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:59:11 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50983 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758344AbYDAU7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:59:07 -0400
Message-Id: <20080401205637.025425911@sgi.com>
References: <20080401205531.986291575@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 13:55:37 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Dean Nelson <dcn@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Kanoj Sarcar <kanojsarcar@yahoo.com>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com
Subject: [patch 6/9] This patch exports zap_page_range as it is needed by XPMEM.
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
