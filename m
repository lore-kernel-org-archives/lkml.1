Return-Path: <linux-kernel-owner+w=401wt.eu-S1763095AbXGKPsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763095AbXGKPsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbXGKPsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:48:38 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:4139 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbXGKPsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:48:36 -0400
Date: Wed, 11 Jul 2007 16:48:35 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Songmao Tian <tiansm@lemote.com>
cc: LinuxBIOS Mailing List <linuxbios@linuxbios.org>, marc.jones@amd.com,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: about cs5536 interrupt ack
In-Reply-To: <4694F4EB.8040000@lemote.com>
Message-ID: <Pine.LNX.4.64N.0707111634430.26459@blysk.ds.pg.gda.pl>
References: <4694A495.1050006@lemote.com> <Pine.LNX.4.64N.0707111347360.26459@blysk.ds.pg.gda.pl>
 <4694F4EB.8040000@lemote.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Songmao Tian wrote:

> > Huh?  Have you managed to find an 8259A clone *that* broken?  So what does
> > it return if you write 0xc to the address 0x20 in the I/O port space and
> > then read back from that location?  You should complain to the 
> >   
> 
> It's the value of IRR, so guess IRR. AMD has well documented cs5536, I
> appreciate that.

 Indeed.  I am surprised they have decided to drop the poll command -- it 
surely does not require much logic as it mostly reuses what's used to 
produce the vector anyway and it is commonly used when 8259A 
implementations are interfaced to non-i386 processors.  PPC is another 
example.

> > More or less -- 3-5 should probably be the outcome of a single read
> > transaction from the north bridge.  I.e. you issue a read to a "magic"
> > location, 3-5 happen, and the data value returned is the vector presented by
> > the interrupt controller on the PCI bus.
> >   
> yeah, we can implement a register in north bridge.

 Strictly speaking it would not be a register, but a "PCI INTA address 
space" much like PCI memory or I/O port address spaces.  Though as the 
former ignores addresses driven on the bus, the space occupied does not 
have to be extensive -- I would assume whatever slot size is available 
with the address decoder you have implemented would do.

> > You can still dispatch interrupts manually by examining the IRR register,
> > but having a way to ask the 8259A's prioritiser would be nice.  Although
> > given such a lethal erratum you report I would not count on the prioritiser
> > to provide any useful flexibility...
> >   
> yeah, that's a straight thought, tried but failed:(, patch followed.

 You may have to modify other functions from arch/mips/kernel/i8259.c; 
yes, this makes the whole experience not as pretty as one would hope...

  Maciej
