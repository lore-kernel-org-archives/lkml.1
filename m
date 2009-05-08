Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZEHPmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZEHPmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZEHPmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:42:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60199 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbZEHPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:42:21 -0400
Subject: Re: [PATCH 2/2] SLUB: Use GFP_PANIC for early-boot allocations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: akpm@linux-foundation.org, gorcunov@openvz.org,
       kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, rientjes@google.com
In-Reply-To: <alpine.DEB.1.10.0905081127240.26361@qirst.com>
References: <1241795429.28600.61.camel@penberg-laptop>
	 <alpine.DEB.1.10.0905081127240.26361@qirst.com>
Date: Fri, 08 May 2009 18:42:21 +0300
Message-Id: <1241797341.28600.66.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 11:28 -0400, Christoph Lameter wrote:
> On Fri, 8 May 2009, Pekka Enberg wrote:
> 
> > This patch converts SLUB early-boot code to use GFP_PANIC instead of explicit
> > BUG_ON() calls.
> 
> Yirks this is not only early boot code. create_unique_id may be executed
> whenever a slab is created.

Updated patch here:

Subject: [PATCH 2/2] SLUB: Use GFP_PANIC for early-boot allocations
From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch converts SLUB early-boot code to use GFP_PANIC instead of BUG_ON().

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7ab54ec..2cdf731 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2109,9 +2109,8 @@ static void early_kmem_cache_node_alloc(gfp_t gfpflags, int node)
 
 	BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
 
-	page = new_slab(kmalloc_caches, gfpflags, node);
+	page = new_slab(kmalloc_caches, gfpflags | GFP_PANIC, node);
 
-	BUG_ON(!page);
 	if (page_to_nid(page) != node) {
 		printk(KERN_ERR "SLUB: Unable to allocate memory from "
 				"node %d\n", node);
-- 
1.5.6.3



