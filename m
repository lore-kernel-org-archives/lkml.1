Return-Path: <linux-kernel-owner+w=401wt.eu-S1423464AbXDZAii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423464AbXDZAii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423468AbXDZAii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:38:38 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423464AbXDZAih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:38:37 -0400
Date: Wed, 25 Apr 2007 17:38:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070426001414.GO17387@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0704251734320.9964@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
 <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
 <20070425235718.66b71f01@the-village.bc.nu>
 <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org>
 <20070425235235.GN17387@elf.ucw.cz> <alpine.LFD.0.98.0704251702290.9964@woody.linux-foundation.org>
 <20070426001414.GO17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Pavel Machek wrote:
> 
> Ok, I guess I'll have nightmares of DMA controllers doing DMAs from
> chips that are no longer there tonight.

Umm. Welcome to the 21st century: we don't do that "separate DMA 
controller" thing any more. All devices do their own DMA.

> Only the fact that we are currently using same device call during
> snapshot() and during restore(). We obviously could do _5_ device
> calls
> 
> (suspend/resume/freeze/quiesce_disable_dma/thaw)
> 
> ...but that looks like too many calls to me.

I'd much rather have five or even more functions that each do *one* 
obvious thing. 

Think like a device driver writer: would you prefer to just implement five 
functions that do something very specific that you know trivially how to 
do ("I know how to disable interrupts and DMA") or would you want to do 
some high-level opertion that you don't even know why the caller asks you 
to suspend? What does "suspend()" even mean when the caller is just going 
to wake up up immediately again? Is it performance-critical? Should I tear 
down all my DMA's? I dunno!

In other words, splitting things up actually makes things simpler. That's 
*doubly* true if you can then give each specific function some really 
clear goals.

		Linus
