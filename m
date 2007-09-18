Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbXIRTqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbXIRTqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbXIRTqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:46:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40921 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526AbXIRTqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:46:02 -0400
Date: Tue, 18 Sep 2007 12:44:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <andrea@suse.de>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
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
In-Reply-To: <20070918191853.GB7541@v2.random>
Message-ID: <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org>
References: <20070911060349.993975297@sgi.com> <200709161853.12050.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com>
 <200709181116.22573.nickpiggin@yahoo.com.au>
 <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
 <20070918191853.GB7541@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Andrea Arcangeli wrote:
> 
> Many? I can't recall anything besides PF_MEMALLOC and the decision
> that the VM is oom.

*All* of the buddy bitmaps, *all* of the GPF_ATOMIC, *all* of the zone 
watermarks, everything that we depend on every single day, is in the end 
just about statistically workable.

We do 1- and 2-order allocations all the time, and we "know" they work. 
Yet Nick (and this whole *idiotic* thread) has all been about how they 
cannot work.

> In general every time reliability has a low priority than performance
> I've an hard time to enjoy it.

This is not about performance. Never has been. It's about SGI wanting a 
way out of their current 16kB mess.

The way to fix performance is to move to x86-64, and use 4kB pages and be 
happy. However, the SGI people want a 16kB (and possibly bigger) 
crap-option for their people who are (often _already_) running some 
special case situation that nobody else cares about.

It's not about "performance". If it was, they would never have used ia64 
in the first place.  It's about special-case users that do odd things.

Nobody sane would *ever* argue for 16kB+ blocksizes in general. 

		Linus

PS. Yes, I realize that there's a lot of insane people out there. However, 
we generally don't do kernel design decisions based on them. But we can 
pat the insane users on the head and say "we won't guarantee it works, but 
if you eat your prozac, and don't bother us, go do your stupid things".
