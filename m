Return-Path: <linux-kernel-owner+w=401wt.eu-S1763640AbYDOMnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763640AbYDOMnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758514AbYDOMmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:42:54 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1675 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbYDOMmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:42:54 -0400
Date: Tue, 15 Apr 2008 14:42:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: linux-kernel@vger.kernel.org, paolo.valente@unimore.it
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
Message-ID: <20080415124247.GL12774@kernel.dk>
References: <20080401152903.GB34860@gandalf.sssup.it> <20080415082236.GD12774@kernel.dk> <20080415091139.GC29846@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415091139.GC29846@gandalf.sssup.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15 2008, Fabio Checconi wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Date: Tue, Apr 15, 2008 10:22:36AM +0200
> >
> > On Tue, Apr 01 2008, Fabio Checconi wrote:
> ...
> > > We would greatly appreciate any sort of feedback from you, comments,
> > > suggestions, corrections and so on.  Thank you for your attention.
> > 
> > Fabio, I've merged the scheduler for some testing. Overall the code
> > looks great, you've done a good job!
> > 
> 
> thank you very much :)
> 
> 
> > I didn't touch patches 2 and 3, but I rewrote #1 somewhat. See the
> > result here:
> > 
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=973a02c4ea1c324c41e45b69c074b13d3bfa97de;hp=a985aabe4d7a720b109c2b63549f8641676a9c88
> > 
> > I'm sure you'll agree with the hlist_sched_*() functions. I also killed
> > the ->bfq_ioprio_changed modification, what exactly was the purpose of
> > that?
> > 
> 
> of course the hlist_sched_*() functions are much better than what was
> in the patch (the idea behind the patch was to not touch at all cfq code).

As long as the changes at that point are straight forward and 'obviously
correct', there's no harm done. Have you thought about merging bfq and
cfq?

> the ->bfq_ioprio_changed was there to avoid that a process/ioc doing
> i/o on multiple devices managed by cfq and bfq would see ioprio
> changes only for one of the two schedulers.
> 
> cfq_ioc_set_ioprio() (and its bfq counterpart bfq_ioc_set_ioprio())
> unconditionally assign 0 to (bfq_)ioprio_changed, so the first
> scheduler that sees the ioprio change eats the new priority values.
> of course I may be wrong, but I think it (or some better mechanism
> to avoid the problem) is necessary.

I see. If we can and will merge bfq and cfq, then it's not really an
issue. Otherwise, I'd suggest using bits 0 of ioprio_changed for cfq and
1 for bfq and so on. That avoids adding another int to the io context.

> > The code is now in the 'bfq' branch of the block git repo.
> > 
> 
> of course we'll be glad to help in testing in any way you can find useful.

I'll push it to the for-akpm branch as well, so it should show up in the
next -mm and get some testing there.

-- 
Jens Axboe

