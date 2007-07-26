Return-Path: <linux-kernel-owner+w=401wt.eu-S1765993AbXGZSzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765993AbXGZSzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765480AbXGZSyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:54:54 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55201 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765052AbXGZSyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:54:53 -0400
Subject: [PATCH] slub: fix bug in slub debug support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1185473872.15205.10.camel@lappy>
References: <46A47940.7030801@googlemail.com>
	 <20070726091048.GA7366@elte.hu> <1185441963.8197.67.camel@twins>
	 <1185473077.15205.7.camel@lappy>
	 <Pine.LNX.4.64.0707261108070.2374@schroedinger.engr.sgi.com>
	 <1185473872.15205.10.camel@lappy>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 20:54:34 +0200
Message-Id: <1185476074.15205.21.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems to properly boot

---
We ClearSlabDebug() before the last SlabDebug() check. Clear it later.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Christoph Lameter <clameter@sgi.com>
---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -1131,6 +1131,7 @@ static void __free_slab(struct kmem_cach
 		slab_pad_check(s, page);
 		for_each_object(p, s, page_address(page))
 			check_object(s, page, p, 0);
+		ClearSlabDebug(page);
 	}
 
 	mod_zone_page_state(page_zone(page),
@@ -1169,7 +1170,6 @@ static void discard_slab(struct kmem_cac
 
 	atomic_long_dec(&n->nr_slabs);
 	reset_page_mapcount(page);
-	ClearSlabDebug(page);
 	__ClearPageSlab(page);
 	free_slab(s, page);
 }


