Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbXJDWYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbXJDWYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 18:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758608AbXJDWYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 18:24:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34865 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751819AbXJDWYb (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 18:24:31 -0400
Date: Fri, 5 Oct 2007 08:23:56 +1000
From: David Chinner <dgc@sgi.com>
To: David Miller <davem@davemloft.net>
Cc: cebbert@redhat.com, willy@linux.intel.com, clameter@sgi.com,
       nickpiggin@yahoo.com.au, hch@lst.de, mel@skynet.ie,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       dgc@sgi.com, jens.axboe@oracle.com, suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
Message-ID: <20071004222356.GH23367404@sgi.com>
References: <470554D9.2050505@redhat.com> <20071004.141113.08322956.davem@davemloft.net> <47055F84.109@redhat.com> <20071004.150718.95506800.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004.150718.95506800.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 03:07:18PM -0700, David Miller wrote:
> From: Chuck Ebbert <cebbert@redhat.com> Date: Thu, 04 Oct 2007 17:47:48
> -0400
> 
> > On 10/04/2007 05:11 PM, David Miller wrote:
> > > From: Chuck Ebbert <cebbert@redhat.com> Date: Thu, 04 Oct 2007 17:02:17
> > > -0400
> > > 
> > >> How do you simulate reading 100TB of data spread across 3000 disks,
> > >> selecting 10% of it using some criterion, then sorting and summarizing
> > >> the result?
> > > 
> > > You repeatedly read zeros from a smaller disk into the same amount of
> > > memory, and sort that as if it were real data instead.
> > 
> > You've just replaced 3000 concurrent streams of data with a single stream.
> > That won't test the memory allocator's ability to allocate memory to many
> > concurrent users very well.
> 
> You've kindly removed my "thinking outside of the box" comment.
> 
> The point is was not that my specific suggestion would be perfect, but that
> if you used your creativity and thought in similar directions you might find
> a way to do it.
> 
> People are too narrow minded when it comes to these things, and that's the
> problem I want to address.

And it's a good point, too, because often problems to one person are a
no-brainer to someone else.

Creating lots of "fake" disks is trivial to do, IMO.  Use loopback on sparse
files containing sparse filesxi, use ramdisks containing sparse files or write a
sparse dm target for sparse block device mapping, etc. I'm sure there's more than the
few I just threw out...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
