Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbZCOUsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbZCOUsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbZCOUsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:48:07 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54163 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbZCOUsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:48:05 -0400
Date: Sun, 15 Mar 2009 21:48:02 +0100
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
Message-ID: <20090315204802.GH27476@kernel.dk>
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <200903151840.21087.bzolnier@gmail.com> <20090315183950.GF27476@kernel.dk> <200903152134.46385.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903152134.46385.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15 2009, Bartlomiej Zolnierkiewicz wrote:
> > > > > Thanks for the hint but it sounds like a major pain once you hit some
> > > > > changes touching the same code areas that block patches do...
> > > > > 
> > > > > Besides this is guaranteed to inrease the workload on my side so it
> > > > > won't happen simply because of -ENOTIME.
> > > > 
> > > > When things collide, it is more work for everyone. But such is life for
> > > > middle/core layer changes. Rebasing _really_ should not be a lot of
> > > > work. And you are going to have to do it sooner or later, either upfront
> > > > or after your patches stop applying because the block changes went
> > > > upstream.
> > > 
> > > The task of running the secondary tree is not merely rebasing of patches
> > > (which I already do on a daily basis) as it also involves extra coordination,
> > > testing, updates etc.
> > 
> > Coordination with whom? If people develop off your pata tree, then there
> > should be no difference.
> 
> Coordination between trees.
> 
> Moreover people often develop against linux-next (this is perfectly
> fine with the current development model) which after change would mean
> that their patches could end up being dependent also on block (more
> work for me to sort it out).

And the difference being? The block tree is in -next in the first place.
This changeset is not yet, since I haven't had time to do testing on it
yet. But the tested stuff is usually there for each iteration.

> > > Really, no more IDE workload on my side is possible and this is a fact not
> > > something to be discussed about (unless someone is willing to help with IDE
> > > maintainance tasks or sponsor my kernel work).
> > 
> > Rate of ide/ changes is pretty high, so I'd say you are doing quite well
> > on that account.
> 
> The historical rate of change have very little to do with the fact
> that I'm currently very time constrained.

You didn't mention this being a current problem, but point taken.

> > > > The only sane way to handle conflicts like this is from the bottom and
> > > > up.
> > > > 
> > > > You could try a more helpful approach, Bart.
> > > 
> > > Well, see my initial reply.  I proposed the middle-point approach
> > > which would spread an extra effort across all parties involved and
> > > should also result in a better review/testing of changes...
> > 
> > That approach makes sense for more involved changes. Honestly, all it
> > would do in this case is slow things down and create more work for Tejun
> > or me. Potentially a lot, at least a lot more than the little extra
> > effort it would be to rebase the pata tree.
> 
> It could be "the little extra effort" after things settle down but not
> for the transition period so asking me to do it now is just plain
> wrong.  Sorry but we are week or so before merge window and I have to
> prepare for it!

I'm not _asking_ you to do anything, I'm suggesting ways we can improve
this process. The alternative is basically to sort it out post merge.
And even that is probably going to take LESS time than this email
discussion has already consumed, given the amount of conflicting
material we are dealing with for this merge. Just a reminder, this is
the IDE related diff for this particular series of changes:

 drivers/ide/ide-cd.c            |   16 -
 drivers/ide/ide-disk.c          |    1
 drivers/ide/ide-ioctls.c        |    1
 drivers/ide/ide-park.c          |    7

A conservative estimate would put that at 1 minute of merge work. Can we
please just drop this waste of time discussion on the current merge? The
important bit is how we handle this in the future, if we have larger
overlapping changes.

> > Bart, we use this approach all the time with the SCSI branch and it has
> > worked fine. It's not going to change for the ide tree. It's
> > contradictory to fanning out work at the ends.
> 
> I can look into separate trees (or maybe just having one tree based on block
> tree like discussed before) after 2.6.30-rc1/2.

Proceed at your own leisure.

-- 
Jens Axboe

