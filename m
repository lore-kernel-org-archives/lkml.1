Return-Path: <linux-kernel-owner+w=401wt.eu-S1161157AbXBUT41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161157AbXBUT41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXBUT41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:56:27 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:40599 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338AbXBUT4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:56:25 -0500
Date: Wed, 21 Feb 2007 08:44:12 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: PCI riser cards and PCI irq routing, etc
Message-ID: <20070221134411.GC22464@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain> <45DA7643.4020305@xs4all.nl> <200702201456.30794.s0348365@sms.ed.ac.uk> <45DB174F.30708@xs4all.nl> <45DC0FCC.7010705@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DC0FCC.7010705@xs4all.nl>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 10:24:28AM +0100, Udo van den Heuvel wrote:
> Udo van den Heuvel wrote:
> > Any ideas about how to proceed?
> > What to test?
> 
> I found some info on the VIA dual PCI extender card at
> http://www.itx-warehouse.co.uk/Product.aspx?ProductID=410.
> The text says:
> 
> The EXT-PCI is a PCI riser card which expands a PCI slot into two PCI slots.
> 
> EXT-PCI slot 1 (lower slot) uses the system resources (Device ID, INT)
> of the PCI slot of the motherboard.
> 
> EXT-PCI slot 2 (Upper slot) uses device 19 and INT_A.
> 
> 
> 
> So if my non-VIA riser card can use DN 19 and also INT_A things should work?
> (assuming that VIA Epia EN BIOS 1.07 is enough to use this card)
> 
> So, if not (as in my situation) how can I find out what is wrong?
> Or find out if the BIOS works OK with the card?
> How can I verify that the correct routing for the IRQ is in place?
> The DN is the only variable so INT lines are hardwired on the riser card?
> Then same for the motherboard.

It is quite likely that the interrupts are set based on the DN.  Now if
they use whatever the parent slot uses as INTD as INTA for the second
slot (since it is set to 19 which is 1 below 20 of the main slot), then
that probably isn't what the BIOS is likely to assign.  It really sounds
like via decided to do things their own way and only riser cards done
their way, or riser cards with a pci to pci bridge are going to work
with it.

> I.o.w.: how can I find the root cause?

Does the documentation say which interrupts are INTA, B, C and D on the
main board?  I would expect slot 20 to have INTA mapped to INTA but then
again being a weird main board it doesn't have to be that way.  It is
certainly possible via decided to just support DN19 and 20 and assign
them both INTA, which would certainly make for a very simple riser card.

--
Len Sorensen
