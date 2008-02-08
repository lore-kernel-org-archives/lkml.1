Return-Path: <linux-kernel-owner+w=401wt.eu-S1763477AbYBHUrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763477AbYBHUrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYBHUrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:47:19 -0500
Received: from brick.kernel.dk ([87.55.233.238]:28309 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbYBHUrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:47:18 -0500
Date: Fri, 8 Feb 2008 21:47:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Paul Clements <paul.clements@steeleye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NBD: make nbd default to deadline I/O scheduler
Message-ID: <20080208204713.GF23197@kernel.dk>
References: <47AC87AE.9040408@steeleye.com> <20080208093341.b4d02e22.randy.dunlap@oracle.com> <20080208101151.935b575c.akpm@linux-foundation.org> <47ACA250.1010404@steeleye.com> <20080208204510.GD23197@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208204510.GD23197@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08 2008, Jens Axboe wrote:
> On Fri, Feb 08 2008, Paul Clements wrote:
> > Andrew Morton wrote:
> > >On Fri, 8 Feb 2008 09:33:41 -0800 Randy Dunlap <randy.dunlap@oracle.com> 
> > >wrote:
> > >
> > >>On Fri, 08 Feb 2008 11:47:42 -0500 Paul Clements wrote:
> > >>
> > >>>There have been numerous reports of problems with nbd and cfq. Deadline 
> > >>>gives better performance for nbd, anyway, so let's use it by default.
> > >
> > >Please define "problems".  If it's just "slowness" then we can live with
> > >that, but I'd hope that Jens is aware and that it's understood.
> > >
> > >It it's "hangs" or "oopses" then we panic.
> > 
> > The two problems I have experienced (which may already be fixed):
> > 
> > 1) nbd hangs with cfq on RHEL 5 (2.6.18) -- this may well have been fixed
> > 
> > There's a similar debian bug that has been filed as well:
> > 
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=447638
> > 
> > 2) nbd performs about 10% better (the last time I tested) with deadline 
> > vs. cfq (the overhead of cfq doesn't provide much advantage to nbd [not 
> > being a real disk], and you end up going through the I/O scheduler on 
> > the nbd server anyway, so it makes sense that deadline is better with nbd)
> > 
> > There have been posts to nbd-general mailing list about problems with 
> > cfq and nbd also.
> 
> I'm fine with that, it's one of those things we'll do automatically when
> we have some sort of disk profile system setup. Devices without seek
> penalties should not use AS or CFQ.
> 
> Asking for a non-existing elevator is not an issue, but it may trigger
> both printks and a switch to another elevator. So if you ask for
> "deadline" and it's modular, you'll get cfq again if it's the default.
> 
> Your patch looks bad though, you forget to exit the old elevator. And
> you don't check the return value of elevator_init().
> 
> All in all, your patch definitely needs more work before it can be
> included.

argr and please don't CC closed lists on lkml, thanks! it's hugely
annoying to everyone that replies in the thread.

-- 
Jens Axboe

