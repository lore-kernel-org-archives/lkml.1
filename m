Return-Path: <linux-kernel-owner+w=401wt.eu-S1763543AbYBHU17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763543AbYBHU17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761541AbYBHU1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:27:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59148 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761506AbYBHU1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:27:50 -0500
Date: Fri, 8 Feb 2008 22:02:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Message-ID: <20080208210258.GA13058@one.firstfloor.org>
References: <20080207195519.GA21772@basil.nowhere.org> <200802081839.18267.prakash@punnoor.de> <20080208190143.GB11573@one.firstfloor.org> <200802082000.39919.prakash@punnoor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802082000.39919.prakash@punnoor.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 08:00:39PM +0100, Prakash Punnoor wrote:
> On the day of Friday 08 February 2008 Andi Kleen hast written:
> > On Fri, Feb 08, 2008 at 06:39:17PM +0100, Prakash Punnoor wrote:
> > > On the day of Friday 08 February 2008 Andi Kleen hast written:
> > > > On Fri, Feb 08, 2008 at 04:13:35PM +0100, Prakash Punnoor wrote:
> > > > > Sorry, I meant the opposite. I needed the acpi_skip_timer_override
> > > > > kernel parameter for nforce2, thus no override. So this chipset is
> > > > > missing here. At least I remember that my nforce2 needed the
> > > > > skipping,
> > > >
> > > > I hope you remember correctly and mean it this time. It would be better
> > > > if you could double check.
> > >
> > > Yes, confirmed. timer w/o the skipping stays XT-PIC on nforce2.
> >
> > Confirmed what? Did you test my patch on both machines?
> > What was the result?
> 
> I confirmed that it (nforce2) needed the acpi_skip_timer_override. If you read 
> my mail, you knew I didn't test your patch.

Ok can you please do so then?  Or stop your obstructism? 

I believe my patch will and according to the test results I had so far 
from other people it also works fairly well. If it doesn't work
on your systems I can fix it of course, but I need something more
concrete to work with; not just some speculation.

> 
> Perhaps I wasn't percise, Len Brown had it in his earlier patch descriptions:
> 
> "
> workaround for nForce2 BIOS bug: XT-PIC timer in IOAPIC mode 

Again when you see "XT-PIC" in /proc/interrupts then you're not in IO-APIC
mode.

I think Len refers to the case of the PIC being routed through the IO-APIC,
but that is a different case and you won't see XT-PIC, but "IO-APIC-level" 
usually.

> My kernels are compiled and configured for APIC. With broken BIOSes the timer 
> ends up as XT-PIC anyway. That is what I wanted to say and which you could 
> see from my cat /proc/interrupts dumps.

Well it doesn't make sense. When you have XT-PIC you're not in IO-APIC 
mode and the timer override is a nop because it only changes how the 
IO-APICs are programmed. 

Long ago there used to be a condition where ACPI would fall back
to XT-PIC mode if something went wrong -- perhaps you're thinking
of this case -- but that code was dropped a long time ago.


> productive system and I usually don't mess with it. So come up with a patch 
> that makes sense (and triggers on my nforce2 and does not trigger on my 
> mcp51) in my eyes, or I won't test anything and keep the NAK.

Your objections don't make sense, so you can NAK all day.  You're
talking about timer overrides in PIC mode which is just pure non sense.

Ok if you're unwilling to test I'm ignoring you in the future.
Please stop sending me email.

-Andi
