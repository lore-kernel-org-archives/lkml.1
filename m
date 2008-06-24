Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYFXVdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYFXVdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbYFXVdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:33:21 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:41626 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbYFXVdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:33:19 -0400
Date: Tue, 24 Jun 2008 17:32:58 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: drive appears confused; hda lost interrupt; IRQ169: nobody cared
In-reply-to: <1198331994.5964.12.camel@elara.tcw.local>
X-X-Sender: lenb@localhost.localdomain
To: Michael Schmitt <mschmitt@unixkiste.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0806241728070.3014@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1198237821.4577.63.camel@elara.tcw.local>
 <20071221131812.7d362e7e@the-village.bc.nu>
 <1198331994.5964.12.camel@elara.tcw.local>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> thanks for the input! This BIOS seems to be current, there are just two
> beta BIOS available and as in the changelog there is nothing IRQ related
> written (there is almost nothing in it) I don't think I want to flash
> one of them, but here are the various options I tried:
> 
> noapic > the one and the same thing, but this time (as classic PIC is
> used) nobody cared about IRQ 11.
> 
> acpi=noirq > the same, this time IRQ 185
> 
> pci=routeirq > the same as right above
> 
> pci=nobios > without irqpoll hda DMA expire, IRQ lost, with irqpoll IRQ
> 169 again
> 
> pci=noacpi > the same as two and three above
> 
> irqfixup (instead of irqpoll) > hda DMA timer expire, IRQ lost
> 
> I may have missed some options to try out, do you suggest some else?
> I've read kernel-parameters.txt and tried to find reasonable options...
> But what I don't get... how tragic are those "irq N nobody cared" and
> "drive appears confused" messages as I don't see a negative impact? And
> at the end, what do they mean? If an IRQ is disabled I thought the
> device behind it would not work anymore... but...
> Maybe I will give the two beta BIOS a try nevertheless.

Start by running a recent kernel, such as 2.6.25 or 2.6.26-rc.

when we hit the "nobody cared", we basically mask that IRQ forever.
If any devices on that IRQ needs interrupts, that would starve them
to death from that moment forward (unless you boot with irqpoll)

The fact that (at least some of) the devices on the disabled IRQ
still work means that they're secretly getting
an IRQ from someplace else, and you should be able to find
that place by watching /proc/interrupts.

-Len

