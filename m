Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbYKULHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbYKULHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 06:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYKULHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 06:07:25 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47018 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbYKULHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 06:07:25 -0500
Subject: Re: [PATCH 2.6.28-rc5 03/11] kmemleak: Add the memory
	allocation/freeing hooks
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <84144f020811201130y2de91d03q7e6557e4086147ad@mail.gmail.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
	 <20081120113045.16607.7462.stgit@pc1117.cambridge.arm.com>
	 <84144f020811201130y2de91d03q7e6557e4086147ad@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 21 Nov 2008 11:07:07 +0000
Message-Id: <1227265627.7015.7.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2008 11:07:08.0739 (UTC) FILETIME=[4BB45930:01C94BC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Thu, 2008-11-20 at 21:30 +0200, Pekka Enberg wrote:
> > @@ -2610,6 +2611,9 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
> >                /* Slab management obj is off-slab. */
> >                slabp = kmem_cache_alloc_node(cachep->slabp_cache,
> >                                              local_flags & ~GFP_THISNODE, nodeid);
> > +               /* only scan the list member to avoid false negatives */
> > +               memleak_scan_area(slabp, offsetof(struct slab, list),
> > +                                 sizeof(struct list_head));
> 
> I find this comment somewhat confusing. Does it mean we _must_ scan
> the list members to avoid false negatives (i.e. leaks that happened
> but were not reported) or that if we scan the whole of struct slab, we
> get false negatives?

It's been some time since I first added this and I may not remember the
full details but it's the latter case - it should avoid scanning
slabp->s_mem because (my understanding) is that it may contain a pointer
to an allocated block. Kmemleak only allows adding what sections to
scan, so in this case only the list_head is relevant.

Let me know if my understanding is correct and I'll make the comment
more clear.

Thanks.

-- 
Catalin

