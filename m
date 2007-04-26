Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXDZAHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXDZAHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbXDZAHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:07:15 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbXDZAHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:07:13 -0400
Date: Wed, 25 Apr 2007 17:05:40 -0700 (PDT)
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
In-Reply-To: <20070425235235.GN17387@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0704251702290.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
 <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
 <20070425235718.66b71f01@the-village.bc.nu>
 <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org>
 <20070425235235.GN17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Pavel Machek wrote:
> > 
> > Why? Becuase there is no _room_ for inconsistency. There's nothing to be 
> > "inconsistent with", since any changes to memory (by things like DMA or 
> > other setup that happens while the suspend process is going on) is by 
> > _definition_ consistent with the resume image (becasue there is no 
> > separate image).
> 
> Do you propose to keep DMAs running while suspending-to-RAM?

What part of "suspend a chip" do you have trouble with?

DMA obviously does *not* happen with a suspended device. There's no need 
to turn DMA even off - it just doesn't happen!

> > For example, the whole myth that "freeze" needs to shut off DMA is a total 
> > and utter *myth*. It needs nothing of the sort at all. Rather than shut 
> > off DMA and try to make the hardware be wevy wevy quiet while it's hunting 
> > wabbits, it's a lot easier to just do nothing at all on "freeze",
> 
> No. Sorry, you are wrong here. 
> 
> Remember that during resume we run
> 
> freeze()
> copy old data into memory
> thaw()
> 
> Now, if the old kernel left DMAs running, it could be overwriting
> the data we are copying in.

The *thaw* needs to happen with devices quiescent. 

But that sure doesn't have anythign to do with the "snapshot()" path. In 
fact, you'll have rebooted the machine in between.

So what does that have to do with "snapshotting"?

			Linus
