Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZHML4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZHML4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZHML4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:56:22 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57962 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbZHML4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:56:22 -0400
Date: Thu, 13 Aug 2009 13:56:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com
Subject: Re: inlined spinlocks on sparc64
Message-ID: <20090813115623.GB12579@kernel.dk>
References: <20090813082058.GX12579@kernel.dk> <20090813.020812.251047996.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813.020812.251047996.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13 2009, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Thu, 13 Aug 2009 10:20:58 +0200
> 
> > I deleted the original thread, so I can't reply there. Just a heads up
> > on the spinlock inlining on sparc64. I decided to give your patches a
> > shot, since one of my IO benchmarks here basically degenerates into a
> > spinlock microbenchmark with > 50% time spent there (unlock part,
> > according to perf). Some of that is surely caching effects, but still.
> > 
> > For this particular workload, I get a net improvement of about 3.5% with
> > the inlined functions. Not bad.
> 
> Doesn't surprise me, any function call can result in a register
> window spill onto the stack, and that's 128 bytes of writes.
> 
> Later when you leave the code path you have to refill that spilled
> window and you get 128 bytes of reads for each one of those.

Good thing it's not register starved ;-)

Forgot to mention that it grew my kernel image by exactly 80KB, total
size is around 5.5MB.

-- 
Jens Axboe

