Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbXJDEF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbXJDEF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 00:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbXJDEA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 00:00:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37872 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751033AbXJDEAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 00:00:06 -0400
Message-Id: <20071004040005.850376534@sgi.com>
References: <20071004035935.042951211@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 03 Oct 2007 20:59:53 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [18/18] SLUB: Use fallback for table of callers/freers of a slab cache
Content-Disposition: inline; filename=vcompound_slub_safe
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The caller table can get quite large if there are many call sites for a
particular slab. Add GFP_FALLBACK allows falling back to vmalloc in case
the caller table gets too big and memory is fragmented. Currently we
would fail the operation.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-10-03 20:00:23.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-10-03 20:01:12.000000000 -0700
@@ -3003,7 +3003,8 @@ static int alloc_loc_track(struct loc_tr
 
 	order = get_order(sizeof(struct location) * max);
 
-	l = (void *)__get_free_pages(flags, order);
+	l = (void *)__get_free_pages(flags | __GFP_COMP | __GFP_VFALLBACK,
+								order);
 	if (!l)
 		return 0;
 

-- 
