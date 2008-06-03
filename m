Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbYFCVp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbYFCVp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYFCVpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:45:15 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:47512 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYFCVpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:45:13 -0400
Date: Tue, 3 Jun 2008 14:44:40 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Matthew Wilcox <matthew@wil.cx>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <20080603213310.GC3549@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0806031439520.3242@t2.domain.actdsltmp>
References: <1211852026.3286.36.camel@pasglop>
 <alpine.LFD.1.10.0805271451100.2958@woody.linux-foundation.org>
 <20080602072403.GA20222@flint.arm.linux.org.uk> <200806031416.18195.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0806031154050.3242@t2.domain.actdsltmp>
 <20080603213310.GC3549@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008, Matthew Wilcox wrote:
> On Tue, Jun 03, 2008 at 12:43:21PM -0700, Trent Piepho wrote:
>> IOW, there are four ways one can defined endianness/swapping:
>> 1) Little-endian
>> 2) Big-endian
>> 3) Native-endian aka non-byte-swapping
>> 4) Foreign-endian aka byte-swapping
>>
>> 1 and 2 are by far the most used.  Some code wants 3.  No one wants 4.  Yet
>> our API is providing 3 & 4, the two which are the least useful.
>
> You've fundamentally misunderstood.
>
> readX/writeX and __readX/__writeX provide little-endian access.
> __raw_readX provide native-endian.
>
> If you want 2 or 4, define your own accessors.  Some architectures define
> other accessors (eg gsc_readX on parisc is native (big) endian, and

How about providing 1 and 2, and if you want 3 or 4 define your own accessors?

>> Is it enough to provide only "all or none" for ordering strictness?  For
>> instance on powerpc, one can get a speedup by dropping strict ordering for
>> IO
>> vs cacheable memory, but still keeping ordering for IO vs IO and IO vs
>> locks. This is much easier to program for than no ordering at all.  In
>> fact, if one
>> doesn't use coherent DMA, it's basically the same as fully strict ordering.
>
> I don't understand why you keep talking about DMA.  Are you talking
> about ordering between readX() and DMA?  PCI proides those guarantees.

I guess you haven't been reading the whole thread.  The reason it started was
because gcc can re-order powerpc (and everyone else's too) IO accesses vs
accesses to cachable memory (but not spin-locks), which ends up only being a
problem with coherent DMA.
