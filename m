Return-Path: <linux-kernel-owner+w=401wt.eu-S934816AbXGMOIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934816AbXGMOIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbXGMOIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:08:34 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40941 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759242AbXGMOId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:08:33 -0400
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: David Chinner <dgc@sgi.com>
Cc: haveblue@linux.vnet.ibm.com, Andrea Arcangeli <andrea@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070713071308.GL31489@sgi.com>
References: <20070706222651.GG5777@v2.random>
	 <20070708232031.GF12413810@sgi.com> <20070710101148.GJ1482@v2.random>
	 <20070712001256.GI31489@sgi.com> <20070712111436.GG28613@v2.random>
	 <20070712144449.GZ31489@sgi.com> <20070712163123.GL28613@v2.random>
	 <1184258097.26210.75.camel@localhost>  <20070713071308.GL31489@sgi.com>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 09:08:31 -0500
Message-Id: <1184335711.15479.39.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 17:13 +1000, David Chinner wrote:
> On Thu, Jul 12, 2007 at 09:34:57AM -0700, Dave Hansen wrote:
> > On Thu, 2007-07-12 at 18:31 +0200, Andrea Arcangeli wrote:
> > > On Fri, Jul 13, 2007 at 12:44:49AM +1000, David Chinner wrote:
> > > > That's crap. Just because a machine has lots of memory does not
> > > > make it OK to waste lots of memory.
> > > 
> > > It's not just wasted, it lowers overhead all over the place. Yes, the
> > > benefit of wasting less pagecache may largely outweight the benefit of
> > > having a larger page size, but if you've a lot of memory perhaps your
> > > working set already fits in the cache, or perhaps you don't fit in the
> > > cache regardless of the page size.
> > 
> > Have you guys seen Shaggy's page cache tails?
> > 
> > http://kernel.org/pub/linux/kernel/people/shaggy/OLS-2006/kleikamp.pdf
> > 
> > We've had the same memory waste issue on ppc64 with 64k hardware
> > pages.  
> 
> Sure. Fundamentally, though, I think it is the wrong approach to
> take - it's a workaround for a big negative side effect of
> increasing page size. It introduces lots of complexity and
> difficult-to-test corner cases; judging by the tail packing problems
> reiser3 has had over the years, it has the potential to be a
> never-ending source of data corruption bugs.

Yeah, I'm not real happy right now with the complexity of my patches.  I
had some hope that Christoph's variable page cache cleanups would
simplify some of it, but that doesn't really help.  I'm working on it
though.

> I think that fine granularity and aggregation for efficiency of
> scale is a better model to use than increasing the base page size.
> With PPC, you can handle different page sizes in the hardware (like
> MIPS) and the use of 64k base page size is an obvious workaround to
> the problem of not being able to use multiple page sizes within the
> OS.
> 
> Adding a workaround (tail packing) to address the negative side
> effects of another workaround (64k base page size) ignores the basic
> problem that has led to both these things being done: Linux does not
> support multiple page sizes natively.....

I'd much prefer having support for multiple page sizes.  I have to admit
that I don't know the VM well enough to weigh in on that debate.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

