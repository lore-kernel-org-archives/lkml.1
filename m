Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbXFUQ1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbXFUQ1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbXFUQ04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:26:56 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:43384 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbXFUQ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:26:55 -0400
Date: Thu, 21 Jun 2007 12:26:54 -0400
To: Clemens Koller <clemens.koller@anagramm.de>
Cc: Robert Hancock <hancockr@shaw.ca>, pharon@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Dual slot PCI riser messes up ivtv
Message-ID: <20070621162654.GA10008@csclub.uwaterloo.ca>
References: <fa.ELPuDi4dcntxF8hk4oCNldcvgoc@ifi.uio.no> <467A89D4.6080607@shaw.ca> <4683D4A0.3000100@anagramm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4683D4A0.3000100@anagramm.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 05:32:48PM +0200, Clemens Koller wrote:
> Robert Hancock schrieb:
> >Islam Amer wrote:
> >> I am trying to build a settop box with two cards, a PVR-150 and a DVB
> >> card. The mini-ITX motherboard has only one PCI slot, so I bought an
> >> active PCI riser.
> 
> Please define "active". Is there a PCI bridge chip on the riser card?
> Or better: Tell us manufacturer and type of this PCI riser card and the
> mini-ITX board.

Certainly many riser cards only have jumpers to change the irq for the
second slot, or some default built in remapping.  And they may have id
select pins to pick which slots they should pretend to be.  From what I
have read, via mini itx boards require a very specific design for riser
boards, which isn't what most riser boards do.  Other mini itx boards
are probably different.

> I am using a 1 to 3 PCI Bus riser card (passive, noname, bought it on ebay
> some years ago).
> The important thing is that in that case the IRQn lines as well as
> the REQ#n and GNT#n lines are routed and coupled to the right IDSEL's of
> the slots. It might be possible that the mini-ITX motherboard's PCI
> configuration (BIOS) is limited there.
> (This could propably be fixed in the kernel. At least in embedded
> environments, it's common to have all PCI ID/IRQ routing
> information in the kernel (or in the DeviceTree or OpenFirmware nowadays))

Certainly the simplest is a riser card with a proper pci bridge that
creates a secondary pci bus with it's own device ids and maps the
interrupts correctly.  Then all that really matters is that the bios on
the board supports pci bridges (a few companies actually manage to fail
to support pci bridges at all in their bioses).

--
Len Sorensen
