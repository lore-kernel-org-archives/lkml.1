Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbXIQWWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbXIQWWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbXIQWV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:21:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36604 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756222AbXIQWV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:21:57 -0400
Date: Mon, 17 Sep 2007 15:21:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@skynet.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <200709161853.12050.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709140720.06537.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709141053110.15813@schroedinger.engr.sgi.com>
 <200709161853.12050.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Sep 2007, Nick Piggin wrote:

> > > So if you argue that vmap is a downside, then please tell me how you
> > > consider the -ENOMEM of your approach to be better?
> >
> > That is again pretty undifferentiated. Are we talking about low page
> 
> In general.

There is no -ENOMEM approach. Lower order page allocation (< 
PAGE_ALLOC_COSTLY_ORDER) will reclaim and in the worst case the OOM killer 
will be activated. That is the nature of the failures that we saw early in 
the year when this was first merged into mm.

> > With the ZONE_MOVABLE you can remove the unmovable objects into a defined
> > pool then higher order success rates become reasonable.
> 
> OK, if you rely on reserve pools, then it is not 1st class support and hence
> it is a non-solution to VM and IO scalability problems.

ZONE_MOVABLE creates two memory pools in a machine. One of them is for 
movable and one for unmovable. That is in 2.6.23. So 2.6.23 has no first 
call support for order 0 pages?

> > > If, by special software layer, you mean the vmap/vunmap support in
> > > fsblock, let's see... that's probably all of a hundred or two lines.
> > > Contrast that with anti-fragmentation, lumpy reclaim, higher order
> > > pagecache and its new special mmap layer... Hmm, seems like a no
> > > brainer to me. You really still want to persue the "extra layer"
> > > argument as a point against fsblock here?
> >
> > Yes sure. You code could not live without these approaches. Without the
> 
> Actually: your code is the one that relies on higher order allocations. Now
> you're trying to turn that into an argument against fsblock?

fsblock also needs contiguous pages in order to have a beneficial 
effect that we seem to be looking for.

> > antifragmentation measures your fsblock code would not be very successful
> > in getting the larger contiguous segments you need to improve performance.
> 
> Complely wrong. *I* don't need to do any of that to improve performance.
> Actually the VM is well tuned for order-0 pages, and so seeing as I have
> sane hardware, 4K pagecache works beautifully for me.

Sure the system works fine as is. Not sure why we would need fsblock then.

> > (There is no new mmap layer, the higher order pagecache is simply the old
> > API with set_blocksize expanded).
> 
> Yes you add another layer in the userspace mapping code to handle higher
> order pagecache.

That would imply a new API or something? I do not see it.

> > Why: It is the same approach that you use.
> 
> Again, rubbish.

Ok the logical conclusion from the above is that you think your approach 
is rubbish.... Is there some way you could cool down a bit?
