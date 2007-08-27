Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbXH0QKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbXH0QKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759072AbXH0QBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:01:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47596 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758835AbXH0QBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:01:33 -0400
Date: Mon, 27 Aug 2007 11:01:32 -0500
From: Dean Nelson <dcn@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, tony.luck@intel.com, jes@sgi.com
Subject: [PATCH 2/4] export zap_page_range for XPMEM
Message-ID: <20070827160132.GC25589@sgi.com>
References: <20070827155622.GA25589@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827155622.GA25589@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
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
