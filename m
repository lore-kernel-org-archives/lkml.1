Return-Path: <linux-kernel-owner+w=401wt.eu-S1031153AbXDZKaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031153AbXDZKaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031150AbXDZKaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:30:19 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:51033 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031072AbXDZKaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:30:18 -0400
Date: Thu, 26 Apr 2007 11:30:16 +0100
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426103014.GC27620@skynet.ie>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <46304B9E.5070604@yahoo.com.au> <20070426084012.GA26926@skynet.ie> <463068E5.6000402@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <463068E5.6000402@yahoo.com.au>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (26/04/07 18:55), Nick Piggin didst pronounce:
> Mel Gorman wrote:
> >On (26/04/07 16:50), Nick Piggin didst pronounce:
> 
> >>Fragmentation is the problem. The anti-frag patches don't actually
> >>guarantee anything about fragmentation, and even if they did, then
> >
> >
> >The grouping pages by mobility do not guarantee anything but the memory
> >partition (kernelcore= boot parameter) does give hard guarantees about
> >the amount of memory that is "movable". Of course, the partition requires
> >configuration at boot-time so it's less than ideal but it does give hard
> >guarantees.
> 
> For the hugepages people, I can understand that's a solution.

I think that's the closest you have ever come to saying fragmentation
avoidance is not a terrible idea :)

> But that's
> the last thing you want to do on a system with a limited amount of memory,
> or a regular Joe's desktop/server.
> 

Regular Joe is not going to be creating a filesystem with large blocks or
overly concerned with saturating all the disks hanging off his RAID array.
At most, he'll care about faster DVD writing and considering the number and
duration of those allocations, the system will be able to handle it. So I
don't think Regular Joe will generally care.

> >Indeed but then you have to deal with internal fragmentation 
> >for pages-larger-than-TLB-page. I'm not saying it's wrong but it does
> >come with it's own set of issues.
> 
> None of them is perfect (the ways to increase the size of pagecache pages,
> that is).
> 
> I think in the long term, TLB page sizes will probably increase a little
> bit... but if a given page size is "good enough" for a CPU, they really
> should be good enough for other hardware. I mean, come on, the CPU's TLB
> has to have a good hit ratio and handle several lookups per cycle with a
> 3-cycle latency on 3GHz+ hardware... surely a an IO controller's
> scatter-gather engine or IOMMU that has to do a few lookups per disk IO
> is nowhere near so critical as a CPU's datapath: just add a few more
> entries to it, they've already got hundreds of megs of cache, so that
> isn't an issue either.
> 

I cannot speak with authority on what IO controllers are really capable
of so maybe someone else will comment on this more.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
