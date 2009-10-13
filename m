Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbZJMS4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbZJMS4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbZJMS4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:56:35 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:53097 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754120AbZJMS4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:56:35 -0400
Date: Tue, 13 Oct 2009 14:48:34 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [FIX] patch "SLUB: Get rid of dynamic DMA kmalloc cache
 allocation"
In-Reply-To: <20091007211052.848982716@gentwo.org>
Message-ID: <alpine.DEB.1.10.0910131445400.32394@gentwo.org>
References: <20091007211024.442168959@gentwo.org> <20091007211052.848982716@gentwo.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slight bug when creating kmalloc dma caches on the fly. When searching for
an unused statically allocated kmem_cache structure we need to check for
size == 0 not the other way around.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2009-10-13 13:31:05.000000000 -0500
+++ linux-2.6/mm/slub.c	2009-10-13 13:31:36.000000000 -0500
@@ -2650,7 +2650,7 @@ static noinline struct kmem_cache *dma_k

 	s = NULL;
 	for (i = 0; i < KMALLOC_CACHES; i++)
-		if (kmalloc_caches[i].size)
+		if (!kmalloc_caches[i].size)
 			break;

 	BUG_ON(i >= KMALLOC_CACHES);

