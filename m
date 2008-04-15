Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYDOSEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYDOSEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYDOSEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:04:06 -0400
Received: from smtp2.sssup.it ([193.205.80.100]:33351 "EHLO smtp2.sssup.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbYDOSEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:04:00 -0400
Date: Tue, 15 Apr 2008 20:08:33 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, paolo.valente@unimore.it
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
Message-ID: <20080415180833.GB32602@gandalf.sssup.it>
References: <20080401152903.GB34860@gandalf.sssup.it> <20080415082236.GD12774@kernel.dk> <20080415091139.GC29846@gandalf.sssup.it> <20080415124247.GL12774@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415124247.GL12774@kernel.dk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Tue, Apr 15, 2008 02:42:48PM +0200
>
> On Tue, Apr 15 2008, Fabio Checconi wrote:
> > of course the hlist_sched_*() functions are much better than what was
> > in the patch (the idea behind the patch was to not touch at all cfq code).
> 
> As long as the changes at that point are straight forward and 'obviously
> correct', there's no harm done. Have you thought about merging bfq and
> cfq?
> 

Well, I'm maintaining bfq as a modified version of cfq, and I use a
script to generate the bfq-iosched.c file.  It allows keeping the common
code in sync.

I've posted this version to allow comparisons between the two schedulers
and because I consider cfq a reference, more tested/stable scheduler.  If you
are interested in it I can clean up the cfq patch in the next few days and
post it here for discussion.


> > the ->bfq_ioprio_changed was there to avoid that a process/ioc doing
> > i/o on multiple devices managed by cfq and bfq would see ioprio
> > changes only for one of the two schedulers.
> > 
> > cfq_ioc_set_ioprio() (and its bfq counterpart bfq_ioc_set_ioprio())
> > unconditionally assign 0 to (bfq_)ioprio_changed, so the first
> > scheduler that sees the ioprio change eats the new priority values.
> > of course I may be wrong, but I think it (or some better mechanism
> > to avoid the problem) is necessary.
> 
> I see. If we can and will merge bfq and cfq, then it's not really an
> issue. Otherwise, I'd suggest using bits 0 of ioprio_changed for cfq and
> 1 for bfq and so on. That avoids adding another int to the io context.
> 

Yes, that's a better solution, at least for now.
[I'm sorry I cannot post a patch correcting it right now because I don't
have access to my dev and test boxes.]
 

> > > The code is now in the 'bfq' branch of the block git repo.
> > > 
> > 
> > of course we'll be glad to help in testing in any way you can find useful.
> 
> I'll push it to the for-akpm branch as well, so it should show up in the
> next -mm and get some testing there.
> 

Ok, thank you very much.
