Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbXD0C1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbXD0C1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 22:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbXD0C1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 22:27:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50773 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752324AbXD0C1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 22:27:53 -0400
Date: Fri, 27 Apr 2007 12:27:31 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427022731.GF65285596@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426190438.3a856220.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 07:04:38PM -0700, Andrew Morton wrote:
> On Tue, 24 Apr 2007 15:21:05 -0700 clameter@sgi.com wrote:
> 
> > This patchset modifies the Linux kernel so that larger block sizes than
> > page size can be supported. Larger block sizes are handled by using
> > compound pages of an arbitrary order for the page cache instead of
> > single pages with order 0.
> 
> Something I was looking for but couldn't find: suppose an application takes
> a pagefault against the third 4k page of an order-2 pagecache "page".  We
> need to instantiate a pte against find_get_page(offset/4)+3.  But these
> patches don't touch mm/memory.c at all and filemap_nopage() appears to
> return the zeroeth 4k page all the time in that case.
> 
> So.. what am I missing, and how does that part work?

"mmap not supported yet" ;)

> Also, afaict your important requirements would be met by retaining
> PAGE_CACHE_SIZE=4k and simply ensuring that pagecache is populated by
> physically contiguous pages

Sure, that addresses the larger I/O side of things, but it doesn't address
the large filesystem blocksize issues that can only be solved with some kind
of page aggregation abstraction. Compound pages and high order page cache
indexing solves this extremely neatly, regardless of whether the compound
page is contiguous or not.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
