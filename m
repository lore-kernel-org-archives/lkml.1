Return-Path: <linux-kernel-owner+w=401wt.eu-S1760088AbXJDTFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbXJDTFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 15:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbXJDTFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 15:05:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49679 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756017AbXJDTFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 15:05:36 -0400
Date: Thu, 4 Oct 2007 12:05:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <willy@linux.intel.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>, suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
In-Reply-To: <20071004192824.GA9852@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0710041156120.11927@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <200709280742.38262.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
 <200709281514.48293.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0710011343020.19779@schroedinger.engr.sgi.com>
 <20071004161621.GO12049@parisc-linux.org> <Pine.LNX.4.64.0710041034550.10854@schroedinger.engr.sgi.com>
 <20071004183224.GA8641@linux.intel.com> <Pine.LNX.4.64.0710041046270.11091@schroedinger.engr.sgi.com>
 <20071004192824.GA9852@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007, Matthew Wilcox wrote:

> We have three runs, all with 2.6.23-rc3 plus the patches that Suresh
> applied from 20070922.  The first run is with slab.  The second run is
> with SLUB and the third run is SLUB plus the tuning parameters you
> recommended.

There was quite a bit of communication on tuning parameters. Guess we got 
more confusion there and multiple configurations settings that I wanted to 
be tested separately were merged. Setting slub_min_order to more than zero 
can certainly be detrimental to performance since higher order page 
allocations can cause cacheline bouncing on zone locks.

Which patches? 20070922 refers to a pull on the slab git tree on the 
performance branch?

> I have a spreadsheet with Vtune data in it that was collected during
> each of these test runs, so we can see which functions are the hottest.
> I can grab that data and send it to you, if that's interesting.

Please do. Add the kernel .configs please. Is there any slab queue tuning 
going on on boot with the SLAB configuration?

Include any tuning that was done to the kernel please.

> > Was the page allocator pass through patchset 
> > separately applied as I requested?
> 
> I don't believe so.  Suresh?

If it was a git pull then the pass through was included and never taken 
out.

> I think for future tests, it would be easiest if you send me a git
> reference.  That way we will all know precisely what is being tested.

Sure we can do that.

> > Finally: Is there some way that I can reproduce the tests on my machines?
> 
> As usual for these kinds of setups ... take a two-CPU machine, 64GB
> of memory, half a dozen fibre channel adapters, about 3000 discs,
> a commercial database, a team of experts for three months worth of
> tuning ...
> 
> I don't know if anyone's tried to replicate a benchmark like this using
> Postgres.  Would be nice if they have ...

Well we got our own performance test department here at SGI. If we get 
them involved then we can add another 3 months until we get the test 
results confirmed ;-). Seems that this is a small configuration. Why
does it take that long? And the experts knew SLAB and not SLUB right?

Lets look at all the data that you got and then see if this is enough to 
figure out what is wrong.
