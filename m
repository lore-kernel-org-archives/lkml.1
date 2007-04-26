Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbXDZOSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbXDZOSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbXDZOSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:18:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36660 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754828AbXDZOSv (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:18:51 -0400
Date: Fri, 27 Apr 2007 00:18:26 +1000
From: David Chinner <dgc@sgi.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426141826.GV65285596@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com> <463057D9.9030804@yahoo.com.au> <46309D16.70109@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46309D16.70109@shadowen.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 01:37:42PM +0100, Andy Whitcroft wrote:
> Nick Piggin wrote:
> > Christoph Lameter wrote:
> >> On Thu, 26 Apr 2007, Nick Piggin wrote:
> >>>> What are the exact requirement you are trying to address?
> >>>
> >>> Block size > page cache size.
> >>
> >> But what do you mean with it? A block is no longer a contiguous
> >> section of memory. So you have redefined the term.
> > 
> > I don't understand what you mean at all. A block has always been a
> > contiguous area of disk.
> 
> Lets take Nick's definition of block being a disk based unit for the
> moment.  That does not change the key contention here, that even with
> hardware specifically designed to handle 4k pages that hardware handles
> larger contigious areas more efficiently.  David Chinner gives us
> figures showing major overall throughput improvements from (I assume)
> shorter scatter gather lists and better tag utilisation.

I haven't actually provided any figures - it's knowledge passed down
from those that know more about it that I do.

If you want figures about the impact of large I/Os, then we should
not be looking at the HBAs but at the impact on RAID controller
throughput (this I do have numbers on ;). It is not uncommon to
see 2MB I/Os give twice the throughput of 512K I/Os to a single
RAID controller - larger than 512k can only be acheived on systems
with a page size larger than 4k.....

> I am loath to
> say we can just blame the hardware vendors for poor design.

Never did - I'm pointing out that linux can't use all the
capabilities they have.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
