Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbXCWHJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbXCWHJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 03:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933900AbXCWHJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 03:09:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54061 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933942AbXCWHJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 03:09:03 -0400
Date: Fri, 23 Mar 2007 09:09:00 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: akpm@osdl.org, linux-kernel@vger.kernel.org, apw@shadowen.org, hch@lst.de,
       manfred@colorfullife.com, christoph@lameter.com, pj@sgi.com
Subject: Re: [PATCH] slab: NUMA kmem_cache diet
In-Reply-To: <4603047C.4070904@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703230907010.17666@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0701021545290.21477@sbz-30.cs.Helsinki.FI>
 <4603047C.4070904@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Please inline patches to the mail, makes it easier to review.)

On Thu, 22 Mar 2007, Eric Dumazet wrote:
> Some NUMA machines have a big MAX_NUMNODES (possibly 1024), but fewer possible
> nodes. This patch dynamically sizes the 'struct kmem_cache' to allocate only
> needed space.
> 
> I moved nodelists[] field at the end of struct kmem_cache, and use the
> following computation in kmem_cache_init()

Hmm, what seems bit worrying is:

diff --git a/mm/slab.c b/mm/slab.c
index abf46ae..b187618 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -389,7 +389,6 @@ struct kmem_cache {
        unsigned int buffer_size;
        u32 reciprocal_buffer_size;
 /* 3) touched by every alloc & free from the backend */
-       struct kmem_list3 *nodelists[MAX_NUMNODES];

I think nodelists is placed at the beginning of the struct for a reason. 
But I have no idea if it actually makes any difference...

			Pekka
