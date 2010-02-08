Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab0BHRmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 12:42:11 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:47698 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab0BHRmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 12:42:09 -0500
Date: Mon, 8 Feb 2010 11:40:38 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Nick Piggin <npiggin@suse.de>
cc: Dave Chinner <david@fromorbit.com>, tytso@mit.edu,
       Andi Kleen <andi@firstfloor.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
In-Reply-To: <20100208073753.GC9781@laptop>
Message-ID: <alpine.DEB.2.00.1002081136350.9133@router.home>
References: <20100129205004.405949705@quilx.com> <20100130192623.GE788@thunk.org> <20100131083409.GF29555@one.firstfloor.org> <20100131135933.GM15853@discord.disaster> <alpine.DEB.2.00.1002030920500.5671@router.home> <20100204003410.GD5332@discord.disaster>
 <20100204030736.GB25885@thunk.org> <20100204033911.GE5332@discord.disaster> <20100204093350.GE13318@laptop> <alpine.DEB.2.00.1002041109500.28165@router.home> <20100208073753.GC9781@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010, Nick Piggin wrote:

> > > After that, LRU on slabs should be fairly easy. Slab could provide a
> > > private per-slab pointer for example that is managed by the caller.
> > > Subsystem can then call into slab to find the objects.
> >
> > Sure with some minor changes we could have a call that is giving you the
> > list of neighboring objects in a slab, while locking it? Then you can look
> > at the objects and decide which ones can be tossed and then do another
> > call to release the objects and unlock the slab.
>
> Yep. Well... you may not even need to ask slab layer to lock the
> slab. Provided that the subsystem is locking out changes. It could
> possibly be helpful to have a call to lock and unlock the slab,
> although usage of such an API would have to be very careful.

True, if you are holding a reference to an object in a slab page and
there is a guarantee that the object is not going away then the slab is already
effectively pinned.

So we just need a call that returns

1. The number of allocated objects in a slab page
2. The total possible number of objects
3. A list of pointers to the objects

?

Then reclaim could make a decision if you want these objects to be
reclaimed.

Such a function could actually be a much less code than the current
patchset and would also be easy to do for SLAB/SLOB.




