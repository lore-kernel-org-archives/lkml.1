Return-Path: <linux-kernel-owner+w=401wt.eu-S933747AbXHJBM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747AbXHJBM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbXHJBMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:12:48 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48148 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754825AbXHJBMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:12:47 -0400
Date: Thu, 9 Aug 2007 20:12:45 -0500
From: Dean Nelson <dcn@sgi.com>
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, tony.luck@intel.com, jes@sgi.com
Subject: [RFC 2/3] SGI Altix cross partition memory (XPMEM)
Message-ID: <20070810011245.GC25427@sgi.com>
References: <20070810010659.GA25427@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810010659.GA25427@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports zap_page_range as it is needed by XPMEM.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

XPMEM would have used sys_madvise() except that madvise_dontneed()
madvise_dontneed() returns an -EINVAL if VM_PFNMAP is set, which is
always true for the pages XPMEM imports from other partitions and is
also true for uncached pages allocated locally via the mspec allocator.
XPMEM needs zap_page_range() functionality for these types of pages as
well as 'normal' pages.

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2007-08-09 07:07:55.762651612 -0500
+++ linux-2.6/mm/memory.c	2007-08-09 07:15:43.226389312 -0500
@@ -894,6 +894,7 @@
 		tlb_finish_mmu(tlb, address, end);
 	return end;
 }
+EXPORT_SYMBOL_GPL(zap_page_range);
 
 /*
  * Do a quick page-table lookup for a single page.
