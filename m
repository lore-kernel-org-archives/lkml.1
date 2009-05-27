Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbZE0RUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbZE0RUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZE0RUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:20:24 -0400
Received: from www.tglx.de ([62.245.132.106]:49784 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZE0RUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:20:24 -0400
Date: Wed, 27 May 2009 19:19:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Harald Welte <HaraldWelte@viatech.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, lkml@morethan.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: LOCK prefix on uni processor has its use (was Re: [BUG FIX] Make
 x86_32 uni-processor Atomic ops, Atomic)
In-Reply-To: <20090527170118.GC4024@prithivi.gnumonks.org>
Message-ID: <alpine.LFD.2.00.0905271906490.3397@localhost.localdomain>
References: <200905221139.26941.lkml@morethan.org> <200905221946.01808.lkml@morethan.org> <4A1748A9.1020306@zytor.com> <200905231304.55973.lkml@morethan.org> <4A188A48.5000208@zytor.com> <20090527170118.GC4024@prithivi.gnumonks.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Harald Welte wrote:
> Here are some statements from the CPU logic guys at VIA/Centaur:
> 
> * A read-modify-write sequence cannot be interupted.
> * All X86 instructions except rep-strings are atomic wrt interrupts.
> * The lock prefix has uses on a UP processor: It keeps DMA devices from
>   interfering with a read-modify-write sequence
...

> Now if I understand the issues correctly, it would mean that there is some
> driver code that modifies a certain chunk of memory, while DMA of some
> peripheral is also accessing that memory.  I suppose it would not have to be
> the same actual address, but probably being within the same cache line is
> already sufficient.
> 
> Now the question is: Is this a valid operation of a driver?  Should the driver
> do such things, or is such a driver broken?  When would that occur?  I'm trying
> to come up with a case, but typically you e.g. allocate some DMA buffer and
> then don't touch it until the hardware has processed it.

Right, that would be more than stupid, but even then it would not
explain any breakage of the kernel. Such a driver would not be
functional anyway if it relies on some read/write modify operations in
an active DMA buffer. That would also explode on any other system as
you have no control whether the access to that memory happens before
or after the DMA operation.

Can you please ask them to clarify that DMA issue further ?

Thanks,

	tglx
