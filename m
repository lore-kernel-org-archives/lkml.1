Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab0BKUyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:54:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36933 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132Ab0BKUyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:54:06 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20100211953.850854588@firstfloor.org>
In-Reply-To: <20100211953.850854588@firstfloor.org>
To: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       haicheng.li@intel.com, rientjes@google.com
Subject: [PATCH] [4/4] SLAB: Fix node add timer race in cache_reap
Message-Id: <20100211205404.085FEB1978@basil.firstfloor.org>
Date: Thu, 11 Feb 2010 21:54:04 +0100 (CET)
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

Index: linux-2.6.32-memhotadd/mm/slab.c
===================================================================
--- linux-2.6.32-memhotadd.orig/mm/slab.c
+++ linux-2.6.32-memhotadd/mm/slab.c
@@ -4093,6 +4093,9 @@ static void cache_reap(struct work_struc
 		 * we can do some work if the lock was obtained.
 		 */
 		l3 = searchp->nodelists[node];
+		/* Note node yet set up */
+		if (!l3)
+			break;
 
 		reap_alien(searchp, l3);
 
