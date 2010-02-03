Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab0BCVj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 16:39:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42230 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826Ab0BCVjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 16:39:17 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201002031039.710275915@firstfloor.org>
In-Reply-To: <201002031039.710275915@firstfloor.org>
To: submit@firstfloor.org, linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       penberg@cs.helsinki.fi, linux-mm@kvack.org
Subject: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
Message-Id: <20100203213915.DB0EBB1620@basil.firstfloor.org>
Date: Wed,  3 Feb 2010 22:39:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cache_reap can run before the node is set up and then reference a NULL 
l3 list. Check for this explicitely and just continue. The node
will be eventually set up.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/slab.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.33-rc3-ak/mm/slab.c
===================================================================
--- linux-2.6.33-rc3-ak.orig/mm/slab.c
+++ linux-2.6.33-rc3-ak/mm/slab.c
@@ -4112,6 +4112,9 @@ static void cache_reap(struct work_struc
 		 * we can do some work if the lock was obtained.
 		 */
 		l3 = searchp->nodelists[node];
+		/* Note node yet set up */
+		if (!l3)
+			break;
 
 		reap_alien(searchp, l3);
 
