Return-Path: <linux-kernel-owner+w=401wt.eu-S1031392AbXDZSF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031392AbXDZSF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031398AbXDZSF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:05:56 -0400
Received: from brick.kernel.dk ([80.160.20.94]:17970 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031399AbXDZSFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:05:55 -0400
Date: Thu, 26 Apr 2007 20:02:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Mel Gorman <mel@skynet.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426180212.GF2017@kernel.dk>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <46304B9E.5070604@yahoo.com.au> <20070426084012.GA26926@skynet.ie> <463068E5.6000402@yahoo.com.au> <20070426103014.GC27620@skynet.ie> <m1y7kfl837.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704261058050.3263@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704261058050.3263@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26 2007, Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Eric W. Biederman wrote:
> 
> > I can't possibly believe any of this is about the cost of processing
> > a request, but rather the problem that some devices don't have a large
> > enough pool of requests to keep them busy if you submit the requests
> > in a 4K page sizes.
> > 
> > This all sounds like a device design issue rather than anything more
> > significant, and it doesn't sound like a long term trend.  Market
> > pressure should fix the hardware.
> 
> Sounds like we are dictating device manufacturers how to 
> design their devices instead of leaving them choice.

Well... First of all (to Eric), the 4kb pages isn't the issue. Only if
you have limited sg capabilities in your hardware AND need larger
segment sizes to get up in the range of request sizes that makes that
hardware go fast would you benefit from always using bigger pages. And
market pressure should indeed make you lose, if you design crappy
hardware like that.

Secondly, choice isn't always good. Linux should cater to the hardware
only to the extent that it makes sense. We don't make design decisions
that are unmaintainable or cripple us in some way because of bad
hardware. That would be stupid.

If we need and want larger IO sizes, then we can do that without big
compound pages. I'm merely interested in the bigger page cache pages
because it'll solve several issues at once.

-- 
Jens Axboe

