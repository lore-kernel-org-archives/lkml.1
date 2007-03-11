Return-Path: <linux-kernel-owner+w=401wt.eu-S933825AbXCKQne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825AbXCKQne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 12:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933832AbXCKQne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 12:43:34 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51992 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933825AbXCKQnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 12:43:33 -0400
Date: Sun, 11 Mar 2007 09:43:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Rolland <rol@as2917.net>
cc: "'Tejun Heo'" <htejun@gmail.com>, "'Jeff Garzik'" <jeff@garzik.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
In-Reply-To: <014d01c763d1$699510c0$2101a8c0@donald>
Message-ID: <Pine.LNX.4.64.0703110931080.9690@woody.linux-foundation.org>
References: <014d01c763d1$699510c0$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Paul,
 do I understand correctly that the *only* difference between the working 
setup is that you applied (by hand) the libata patch that Jeff sent out?

So plain 2.6.21-rc2 works fine, but with the patch applied, you get no 
interrupts on the DVD drive?

On Sun, 11 Mar 2007, Paul Rolland wrote:
> 
> > It seems like IRQ is not getting through.  The first IRQ 
> > driven command is failing for you.
> 
> Hmmmm.... 
> > Extract is :
> > ata7: PATA max UDMA/100 cmd 0x0000000000019c00 ctl 0x0000000000019882 bmdma 0x0000000000019400 irq 16
> > ata8: PATA max UDMA/100 cmd 0x0000000000019800 ctl 0x0000000000019482 bmdma 0x0000000000019408 irq 16
> 
> IRQ 16 is IO-APIC-fasteoi for libata, and is not shared... but all the
> others libata IRQ are IO-APIC-edge.

Ok, that's interesting, although IO-APIC-fasteoi certainly works for 
others (eg me), but it's still useful.

> > * Does giving 'acpi=off' or 'irqpoll' make any difference?
> > 
> > * Can you connect a harddisk to the channel and see whether 
> > that works?
>
> Tried that.. Disk is identified as ATA-7: Mastor 6Y080L0, YAR41BW0, max
> UDMA/13 and then timeout again...
> 
> Tried then with acpi=off, same result (identify is OK, but then timeout),
> and irqpoll and then it was OK !!!!

Whee... There were no changes that looked interrupt-related there..

		Linus
