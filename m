Return-Path: <linux-kernel-owner+w=401wt.eu-S932452AbXBSSXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbXBSSXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 13:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932450AbXBSSXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 13:23:46 -0500
Received: from khc.piap.pl ([195.187.100.11]:40668 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452AbXBSSXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 13:23:45 -0500
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl>
	<20070218155445.GV7584@csclub.uwaterloo.ca>
	<m3ejon8afh.fsf@maximus.localdomain>
	<20070219150316.GP7582@csclub.uwaterloo.ca>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 19 Feb 2007 19:23:43 +0100
In-Reply-To: <20070219150316.GP7582@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Mon, 19 Feb 2007 10:03:16 -0500")
Message-ID: <m3vehyovkg.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:

> The PCI spec doesn't require 4 seperate interrupts.  They certainly can
> all be the same.  I do believe it does require the rotation method on
> anything using PCI bridges

Correct, PCI-PCI bridges have to rotate their INT lines (used ones
only, of course). The BIOS and OS would have no way to know the
topology otherwise (especially if the bridge is on a add-on card).

> If you
> make a mainboard on the other hand you can do whatever you want since
> you get to design the firmware that assigns the interrupts.

Precisely.

> Depends if the riser card is specific to that system, or if it is
> supposed to be a generic PCI card.

I think a generic card would require a bridge - how would you produce
IDSEL signals without a bridge, and without knowledge about the
motherboard?

If you know the motherboard you know, for example, that is uses
A(D)25-31 as IDSELs for on-board devices and A24 for PCI slot. Then
you can use, say, A23 for card #1 and reuse A24 (or IDSEL from the
mb connector) as IDSEL for card #0. And you know your BIOS will
support this.

If you don't know the motherboard you don't even know if IDSELs are
derived from AD 0->31 or if they are made differently. The BIOS may
just support only one device connected directly to the PCI slot.

I have never seen a riser card with a bridge, though of course it
doesn't mean there aren't any.

> It may.  But using just INTB and INTD on a card is not allowed by the
> spec as far as I understand it.

Yep, single function -> INTA, two functions -> INT A+B and so on.

> Sure.  But if you have a PCI to PCI bridge on a card, then you only get
> 4 interrupt lines into the card, and you have to distribute them by the
> spec to the chips behind the bridge if you want the system to know how
> the interrupts should be used

Right.

> (although I guess a driver could do its
> own thing if it really wanted to).

Well, that would be against PCI bridge specs but it probably could.
Normally, a special driver for PCI-PCI bridge is not needed.

> It does help make sure that if you have 8 devices, each IRQ is used by
> only two devices, so the interrupt handler doesn't have too many devices
> to check when an interrupt occours.

Right.
-- 
Krzysztof Halasa
