Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbXJEGrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbXJEGrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 02:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXJEGra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 02:47:30 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19044 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbXJEGr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 02:47:29 -0400
Date: Fri, 5 Oct 2007 08:48:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Chinner <dgc@sgi.com>
Cc: David Miller <davem@davemloft.net>, cebbert@redhat.com,
       willy@linux.intel.com, clameter@sgi.com, nickpiggin@yahoo.com.au,
       hch@lst.de, mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
Message-ID: <20071005064853.GI5711@kernel.dk>
References: <470554D9.2050505@redhat.com> <20071004.141113.08322956.davem@davemloft.net> <47055F84.109@redhat.com> <20071004.150718.95506800.davem@davemloft.net> <20071004222356.GH23367404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004222356.GH23367404@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05 2007, David Chinner wrote:
> On Thu, Oct 04, 2007 at 03:07:18PM -0700, David Miller wrote:
> > From: Chuck Ebbert <cebbert@redhat.com> Date: Thu, 04 Oct 2007 17:47:48
> > -0400
> > 
> > > On 10/04/2007 05:11 PM, David Miller wrote:
> > > > From: Chuck Ebbert <cebbert@redhat.com> Date: Thu, 04 Oct 2007 17:02:17
> > > > -0400
> > > > 
> > > >> How do you simulate reading 100TB of data spread across 3000 disks,
> > > >> selecting 10% of it using some criterion, then sorting and summarizing
> > > >> the result?
> > > > 
> > > > You repeatedly read zeros from a smaller disk into the same amount of
> > > > memory, and sort that as if it were real data instead.
> > > 
> > > You've just replaced 3000 concurrent streams of data with a single stream.
> > > That won't test the memory allocator's ability to allocate memory to many
> > > concurrent users very well.
> > 
> > You've kindly removed my "thinking outside of the box" comment.
> > 
> > The point is was not that my specific suggestion would be perfect, but that
> > if you used your creativity and thought in similar directions you might find
> > a way to do it.
> > 
> > People are too narrow minded when it comes to these things, and that's the
> > problem I want to address.
> 
> And it's a good point, too, because often problems to one person are a
> no-brainer to someone else.
> 
> Creating lots of "fake" disks is trivial to do, IMO.  Use loopback on
> sparse files containing sparse filesxi, use ramdisks containing sparse
> files or write a sparse dm target for sparse block device mapping,
> etc. I'm sure there's more than the few I just threw out...

Or use scsi_debug to fake drives/controllers, works wonderful as well
for some things and involve the full IO stack.

I'd like to second Davids emails here, this is a serious problem. Having
a reproducible test case lowers the barrier for getting the problem
fixed by orders of magnitude. It's the difference between the problem
getting fixed in a day or two and it potentially lingering for months,
because email ping-pong takes forever and "the test team has moved on to
other tests, we'll let you know the results of test foo in 3 weeks time
when we have a new slot on the box" just removing any developer
motivation to work on the issue.

-- 
Jens Axboe

