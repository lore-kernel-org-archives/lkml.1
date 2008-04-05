Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbYDEHXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbYDEHXh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 03:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYDEHX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 03:23:28 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14874 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbYDEHX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 03:23:27 -0400
Date: Sat, 5 Apr 2008 09:23:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: use mapping_gfp_mask
Message-ID: <20080405072322.GJ12774@kernel.dk>
References: <Pine.LNX.4.64.0804032331190.27180@blonde.site> <20080404114609.GG29686@kernel.dk> <6101e8c40804041354g2b065078i997e63cf03e576f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40804041354g2b065078i997e63cf03e576f0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04 2008, Oliver Pinter wrote:
> hi all!
> 
> this patch for 2.6.22.y ?
> 
> if i good see, the __generic_file_splice_read bring out to 2.6.22 ..
> 
> http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
> http://repo.or.cz/w/linux-2.6.22.y-op.git

Loop isn't affected before 2.6.23, so while it doesn't hurt to put it
into 2.6.22, there's not much point either. 2.6.23 and 24 need the
patch.


> 
> On 4/4/08, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Thu, Apr 03 2008, Hugh Dickins wrote:
> > > The loop block driver is careful to mask __GFP_IO|__GFP_FS out of its
> > > mapping_gfp_mask, to avoid hangs under memory pressure.  But nowadays
> > > it uses splice, usually going through __generic_file_splice_read.  That
> > > must use mapping_gfp_mask instead of GFP_KERNEL to avoid those hangs.
> > >
> > > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > > ---
> > > Ought to go into 2.6.25.  For 2.6.23 and 2.6.24 stable?  Well, I've
> > > not actually seen this hang on any of these, though presumably it's
> > > lurking there.  Where I did see it, and test the fix, was 2.6.25-rc5-mm1:
> > > whose SLUB had a disturbing predilection (since corrected) for order-4
> > > allocations, even when allocating radix tree nodes.
> >
> > Thanks Hugh, definitely correct! I see it's already merged, so all is
> > well.
> >
> > --
> > Jens Axboe
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> -- 
> Thanks,
> Oliver

-- 
Jens Axboe

