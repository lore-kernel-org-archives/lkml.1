Return-Path: <linux-kernel-owner+w=401wt.eu-S1763660AbXHQGR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763660AbXHQGR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 02:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759437AbXHQGRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 02:17:38 -0400
Received: from brick.kernel.dk ([87.55.233.238]:29019 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759121AbXHQGRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 02:17:37 -0400
Date: Fri, 17 Aug 2007 08:17:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 000 of 6] A few block-layer tidy-up patches.
Message-ID: <20070817061733.GD23758@kernel.dk>
References: <20070816211551.11839.patches@notabene> <20070816113638.GX23758@kernel.dk> <18116.61035.621593.588647@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18116.61035.621593.588647@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17 2007, Neil Brown wrote:
> On Thursday August 16, jens.axboe@oracle.com wrote:
> > On Thu, Aug 16 2007, NeilBrown wrote:
> > > Following are 5 patches which - I think - clean up various bits and pieces
> > > in the block layer.
> > > 
> > > The only part that might be seen as a function change rather than
> > > simply rearranging code is in ps3disk where bvec_kmap_irq is used
> > > instead of bio_kmap_atomic (so interrupts are disabled).
> > > 
> > > The only other user of bvec_kmap_irq is ide-floppy.c.  If that does
> > > need to disable interrupts, and ps3disk doesn't, make the disabling of
> > > interrupts should be separated from the kmapping??
> > 
> > Applied 1-6, thanks! BTW, your patch #2 doesn't apply cleanly on
> > floppy.c in current -git, and there has been no changes there since July
> > 24th. So you must be diffing against something else?
> 
> Yes, current -mm.  That is where I usually work.  I'll make sure
> future patches are against -linus or -block.

OK

> > You also don't re-indent and remove one nesting when removing
> > bio_for_each_segment(). It makes it easier to review, but I formatted
> > that as well since I had to hand-apply patch #2.
> 
> I meant to mention that in the changelog comment.  I deliberately
> didn't re-indent most of the loops to ease review.  I was going to
> send an indent-only patch it the first was accepted.  No need now :-)

Once I started going through them, it seemed so. No problem, it does
make it easier to verify that no little extra edit crept in.

> > Please inspect the #block-2.6.24 branch to see the result.
> 
> I don't know where to look for this.  I checked
>   http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git
> but they don't seem to be there.
> ??

That's where it is, but the kernel.org mirroring is just horrible slow.
Just checked now and it's there.

-- 
Jens Axboe

