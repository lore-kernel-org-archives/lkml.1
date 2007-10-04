Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbXJDRqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbXJDRqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbXJDRpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:45:51 -0400
Received: from mga07.intel.com ([143.182.124.22]:48837 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755966AbXJDRpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:45:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,231,1188802800"; 
   d="scan'208";a="292733636"
Date: Thu, 4 Oct 2007 11:32:24 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SLUB performance regression vs SLAB
Message-ID: <20071004183224.GA8641@linux.intel.com>
References: <20070919033605.785839297@sgi.com> <200709280742.38262.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com> <200709281514.48293.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0710011343020.19779@schroedinger.engr.sgi.com> <20071004161621.GO12049@parisc-linux.org> <Pine.LNX.4.64.0710041034550.10854@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710041034550.10854@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 10:38:15AM -0700, Christoph Lameter wrote:
> On Thu, 4 Oct 2007, Matthew Wilcox wrote:
> 
> > So, on "a well-known OLTP benchmark which prohibits publishing absolute
> > numbers" and on an x86-64 system (I don't think exactly which model
> > is important), we're seeing *6.51%* performance loss on slub vs slab.
> > This is with a 2.6.23-rc3 kernel.  Tuning the boot parameters, as you've
> > asked for before (slub_min_order=2, slub_max_order=4, slub_min_objects=8)
> > gets back 0.38% of that.  It's still down 6.13% over slab.
> 
> Yeah the fastpath vs. slow path is not the issue as Siddha and I concluded 
> earlier. Seems that we are mainly seeing cacheline bouncing due to two 
> cpus accessing meta data in the same page struct. The patches in 
> MM that are scheduled to be merged for .24 address that issue. I 
> have repeatedly asked that these patches be tested. The patches were 
> posted months ago.

I just checked with the guys who did the test.  When I said -rc3, I
mis-spoke; this is 2.6.23-rc3 *plus* the patches which Suresh agreed to
test for you.
