Return-Path: <linux-kernel-owner+w=401wt.eu-S1759836AbXJDRi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbXJDRi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbXJDRiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:38:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41127 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755242AbXJDRiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:38:16 -0400
Date: Thu, 4 Oct 2007 10:38:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <willy@linux.intel.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SLUB performance regression vs SLAB
In-Reply-To: <20071004161621.GO12049@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0710041034550.10854@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <200709280742.38262.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
 <200709281514.48293.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0710011343020.19779@schroedinger.engr.sgi.com>
 <20071004161621.GO12049@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007, Matthew Wilcox wrote:

> So, on "a well-known OLTP benchmark which prohibits publishing absolute
> numbers" and on an x86-64 system (I don't think exactly which model
> is important), we're seeing *6.51%* performance loss on slub vs slab.
> This is with a 2.6.23-rc3 kernel.  Tuning the boot parameters, as you've
> asked for before (slub_min_order=2, slub_max_order=4, slub_min_objects=8)
> gets back 0.38% of that.  It's still down 6.13% over slab.

Yeah the fastpath vs. slow path is not the issue as Siddha and I concluded 
earlier. Seems that we are mainly seeing cacheline bouncing due to two 
cpus accessing meta data in the same page struct. The patches in 
MM that are scheduled to be merged for .24 address that issue. I 
have repeatedly asked that these patches be tested. The patches were 
posted months ago.

> Now, where do we go next?  I suspect that 2.6.23-rc9 has significant
> changes since -rc3, but I'd like to confirm that before kicking off
> another (expensive) run.  Please, tell me what useful kernels are to test.

I thought Siddha has a test in the works with the per cpu structure 
patchset from MM? Could you sync up with Siddha?

