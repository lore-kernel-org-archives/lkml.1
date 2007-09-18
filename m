Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbXIRTTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbXIRTTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758430AbXIRTS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:18:58 -0400
Received: from ns.suse.de ([195.135.220.2]:42076 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758315AbXIRTS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:18:56 -0400
Date: Tue, 18 Sep 2007 21:18:53 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070918191853.GB7541@v2.random>
References: <20070911060349.993975297@sgi.com> <200709161853.12050.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com> <200709181116.22573.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 11:30:17AM -0700, Linus Torvalds wrote:
> The fact is, *none* of those things are true. The VM doesn't guarantee 
> anything, and is already very much about statistics in many places. You 

Many? I can't recall anything besides PF_MEMALLOC and the decision
that the VM is oom. Those are the only two gray areas... the safety
margin is large enough that nobody notices the lack of black-and-white
solution.

So instead of working to provide guarantees for the above two gray
spots, we're making everything weaker, that's the wrong direction as
far as I can tell, especially if we're going to mess up big time the
commo code in a backwards way only for those few users of those few
I/O devices out there.

In general every time reliability has a low priority than performance
I've an hard time to enjoy it.
