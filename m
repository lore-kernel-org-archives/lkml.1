Return-Path: <linux-kernel-owner+w=401wt.eu-S1763376AbXGTGES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763376AbXGTGES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 02:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXGTGEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 02:04:07 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:33552 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbXGTGEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 02:04:05 -0400
Date: Fri, 20 Jul 2007 15:03:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Fix memory hotplug oops from ZONE_MOVABLE changes.
Message-ID: <20070720060342.GA24765@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mel Gorman <mel@csn.ul.ie>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

zone_movable_pfn is presently marked as __initdata and referenced
from adjust_zone_range_for_zone_movable(), which in turn is
referenced by zone_spanned_pages_in_node(). Both of these are
__meminit annotated. When memory hotplug is enabled, this will oops
on a hot-add, due to zone_movable_pfn having been freed.

__meminitdata annotation gives the desired behaviour.

This will only impact platforms that enable both memory hotplug
and ARCH_POPULATES_NODE_MAP.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 43cb3b3..40954fb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -138,7 +138,7 @@ static unsigned long __meminitdata dma_reserve;
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
   unsigned long __initdata required_kernelcore;
   unsigned long __initdata required_movablecore;
-  unsigned long __initdata zone_movable_pfn[MAX_NUMNODES];
+  unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
 
   /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
   int movable_zone;
