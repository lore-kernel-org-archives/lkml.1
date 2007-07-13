Return-Path: <linux-kernel-owner+w=401wt.eu-S935861AbXGMHNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935861AbXGMHNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXGMHNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:13:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48699 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757397AbXGMHNY (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:13:24 -0400
Date: Fri, 13 Jul 2007 17:13:08 +1000
From: David Chinner <dgc@sgi.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Andrea Arcangeli <andrea@suse.de>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, David Kleikamp <shaggy@us.ibm.com>
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070713071308.GL31489@sgi.com>
References: <20070706222651.GG5777@v2.random> <20070708232031.GF12413810@sgi.com> <20070710101148.GJ1482@v2.random> <20070712001256.GI31489@sgi.com> <20070712111436.GG28613@v2.random> <20070712144449.GZ31489@sgi.com> <20070712163123.GL28613@v2.random> <1184258097.26210.75.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184258097.26210.75.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 09:34:57AM -0700, Dave Hansen wrote:
> On Thu, 2007-07-12 at 18:31 +0200, Andrea Arcangeli wrote:
> > On Fri, Jul 13, 2007 at 12:44:49AM +1000, David Chinner wrote:
> > > That's crap. Just because a machine has lots of memory does not
> > > make it OK to waste lots of memory.
> > 
> > It's not just wasted, it lowers overhead all over the place. Yes, the
> > benefit of wasting less pagecache may largely outweight the benefit of
> > having a larger page size, but if you've a lot of memory perhaps your
> > working set already fits in the cache, or perhaps you don't fit in the
> > cache regardless of the page size.
> 
> Have you guys seen Shaggy's page cache tails?
> 
> http://kernel.org/pub/linux/kernel/people/shaggy/OLS-2006/kleikamp.pdf
> 
> We've had the same memory waste issue on ppc64 with 64k hardware
> pages.  

Sure. Fundamentally, though, I think it is the wrong approach to
take - it's a workaround for a big negative side effect of
increasing page size. It introduces lots of complexity and
difficult-to-test corner cases; judging by the tail packing problems
reiser3 has had over the years, it has the potential to be a
never-ending source of data corruption bugs.

I think that fine granularity and aggregation for efficiency of
scale is a better model to use than increasing the base page size.
With PPC, you can handle different page sizes in the hardware (like
MIPS) and the use of 64k base page size is an obvious workaround to
the problem of not being able to use multiple page sizes within the
OS.

Adding a workaround (tail packing) to address the negative side
effects of another workaround (64k base page size) ignores the basic
problem that has led to both these things being done: Linux does not
support multiple page sizes natively.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
