Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbZCOQsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbZCOQsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 12:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZCOQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 12:48:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49842 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbZCOQsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 12:48:40 -0400
Date: Sun, 15 Mar 2009 17:48:38 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Mike Miller <mike.miller@hp.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 11/14] block: implement and use
	[__]blk_end_request_all()
Message-ID: <20090315164837.GE27476@kernel.dk>
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <200903142023.14747.bzolnier@gmail.com> <1237060560.3907.57.camel@localhost.localdomain> <200903142119.10056.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903142119.10056.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14 2009, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 14 March 2009, James Bottomley wrote:
> > On Sat, 2009-03-14 at 20:23 +0100, Bartlomiej Zolnierkiewicz wrote:
> > > > > More generic comment follows -> this patch is guaranteed to clash
> > > > > with at least linux-next/pata-2.6 tree so why not introduce block
> > > > > layer helpers now, then push all driver updates through respective
> > > > > driver maintainers and deal with end_request() later (after all
> > > > > driver updates are in-tree)?
> > > > 
> > > > Most of the lld changes being trivial, I was hoping to push things
> > > > through blk tree, but IDE seems to be the most intertwined with the
> > > > block layer and it's likely to see quite some amount of not-so-trivial
> > > > changes to subtle paths.  How about pushing !IDE parts into blk tree
> > > > and pulling blk into pata-2.6, make IDE related changes there and
> > > > pulling back into blk tree so that further progresses can be made?
> > > 
> > > There is a "tiny" problem with this -- pata-2.6 is a quilt tree based on
> > > Linus' tree and it is not going to change for now (for various reasons).
> > 
> > Actually this one's easily solvable if you base the quilt on the block
> > tree (just specify it to linux-next in the BASE directive and it will do
> > the right thing).
> > 
> > What I'd do is actually run two quilts: one based on vanilla and one
> > based on block and only add block dependent patches to the latter.  This
> > is like running a postmerge git tree (you can only send a pull request
> > for it after block goes in).
> 
> Thanks for the hint but it sounds like a major pain once you hit some
> changes touching the same code areas that block patches do...
> 
> Besides this is guaranteed to inrease the workload on my side so it
> won't happen simply because of -ENOTIME.

When things collide, it is more work for everyone. But such is life for
middle/core layer changes. Rebasing _really_ should not be a lot of
work. And you are going to have to do it sooner or later, either upfront
or after your patches stop applying because the block changes went
upstream.

The only sane way to handle conflicts like this is from the bottom and
up.

You could try a more helpful approach, Bart.

-- 
Jens Axboe

