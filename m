Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbXHXGzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbXHXGzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 02:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758843AbXHXGzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 02:55:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42502 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174AbXHXGzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 02:55:01 -0400
Date: Fri, 24 Aug 2007 15:53:25 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Mel Gorman" <mel@skynet.ie>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
Subject: [PATCH] Fix find_next_best_node (Re: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted)
Cc: "Luck, Tony" <tony.luck@intel.com>, "Jeremy Higdon" <jeremy@sgi.com>,
       "Andi Kleen" <ak@suse.de>, <linux-kernel@vger.kernel.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       <linux-ia64@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       linux-mm@kvack.org
In-Reply-To: <20070823142133.9359a1ce.akpm@linux-foundation.org>
References: <617E1C2C70743745A92448908E030B2A023EB020@scsmsx411.amr.corp.intel.com> <20070823142133.9359a1ce.akpm@linux-foundation.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070824153945.3C75.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I found find_next_best_node() was wrong.
I confirmed boot up by the following patch.
Mel-san, Kamalesh-san, could you try this?

Bye.
---

Fix decision of memoryless node in find_next_best_node().
This can be cause of SW-IOMMU's allocation failure.

This patch is for 2.6.23-rc3-mm1.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: current/mm/page_alloc.c
===================================================================
--- current.orig/mm/page_alloc.c	2007-08-24 16:03:17.000000000 +0900
+++ current/mm/page_alloc.c	2007-08-24 16:04:06.000000000 +0900
@@ -2136,7 +2136,7 @@ static int find_next_best_node(int node,
 		 * Note:  N_HIGH_MEMORY state not guaranteed to be
 		 *        populated yet.
 		 */
-		if (pgdat->node_present_pages)
+		if (!pgdat->node_present_pages)
 			continue;
 
 		/* Don't want a node to appear more than once */

-- 
Yasunori Goto 


