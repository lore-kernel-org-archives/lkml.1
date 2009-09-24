Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbZIXBcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbZIXBcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 21:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbZIXBck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 21:32:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:12710 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbZIXBcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 21:32:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,441,1249282800"; 
   d="scan'208";a="191020443"
Date: Thu, 24 Sep 2009 09:32:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090924013229.GC6456@localhost>
References: <20090919035835.GA9921@localhost> <20090919040051.GA10245@localhost> <20090919042607.GA19752@localhost> <20090921135321.GD6259@think> <20090922101335.GA27432@localhost> <20090922113055.GI10825@think> <20090922131832.GB7675@localhost> <20090922155941.GM10825@think> <20090923010541.GB6382@localhost> <20090923140840.GB2794@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923140840.GB2794@think>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 10:08:40PM +0800, Chris Mason wrote:
> On Wed, Sep 23, 2009 at 09:05:41AM +0800, Wu Fengguang wrote:
> 
> [ timeslice based limits on number of pages sent by the bdi threads ]
> 
> > > 
> > > The reason I prefer the timeslice idea is that we don't need the
> > > hardware to tell us how fast it is.  We just write for a while and move
> > > on.
> > 
> > That makes sense.  Note that the triple (pages, page segments,
> > submission time) can somehow adapt to hardware capabilities
> > (and at least won't hurt fast arrays).
> > 
> > - max pages are set to large enough number for big arrays
> > - max page segments could be based on the existing blk_queue_nonrot()
> > - submission time = 1s, which is mainly a safeguard for slow devices
> >   (ie. usb stick), to prevent one single inode from taking too much
> >   time. This time limit has little performance impacts.
> > 
> > Possible merits are
> > - these parameters are concrete ones and easy to handle
> > - it's natural to implement related logics in the VFS level
> > - file systems can do nothing to get most benefits
> > 
> > Also the (now necessary) per-invocation limit could be somehow
> > eliminated when balance_dirty_pages() does not do IO itself.
> 
> I think there are probably a lot of good ways to improve on our single
> max number of pages metric from today

Yes, as always, it benefits to work out some prototype solutions for
evaluation and comparison.

> , but I'm worried about the
> calculation time finding page segments.  The radix tree
> isn't all that well suited to it.

I didn't mean to "calculate" the page segments. But rather to do this
in write_cache_pages:

        if (this page index is 1MB away from prev page index)
                wbc->page_segments--;

> But, if you've got a patch I'd be happy to run a comparison against it.
> Jens' box will be better at showing any CPU cost to the radix walking.

Thanks!

Regards,
Fengguang
