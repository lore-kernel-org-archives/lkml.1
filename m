Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbXFXO1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbXFXO1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 10:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXFXO1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 10:27:36 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:14123 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbXFXO1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 10:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B6RrbFwOUhRTVkRjYUbT6L/kfjxQMIASPlratcqYlcDbWEeu3c6gQk5HcYGdyGkegtFQ9b6E++zMwDeDh7/h3gzpgAwdY4vH4+BDCjkKpACW2dCGPQvIEilMOIBm8MuB6OsG5e948YHlUmsti4VQxChRfPON6Q/ACWkxPloTyig=
Subject: Re: Dual slot PCI riser messes up ivtv
From: Islam Amer <pharon@gmail.com>
Reply-To: pharon@gmail.com
To: Clemens Koller <clemens.koller@anagramm.de>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <4683EA26.6030306@anagramm.de>
References: <fa.ELPuDi4dcntxF8hk4oCNldcvgoc@ifi.uio.no>
	 <467A89D4.6080607@shaw.ca> <4683D4A0.3000100@anagramm.de>
	 <20070621162654.GA10008@csclub.uwaterloo.ca> <4683EA26.6030306@anagramm.de>
Content-Type: text/plain
Date: Sun, 24 Jun 2007 17:27:24 +0300
Message-Id: <1182695244.6316.11.camel@iamer-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 19:04 +0200, Clemens Koller wrote:
> Hi, Lennart!
> 
> Lennart Sorensen schrieb:
> > On Thu, Jun 28, 2007 at 05:32:48PM +0200, Clemens Koller wrote:
> >> Robert Hancock schrieb:
> >>> Islam Amer wrote:
> >>>> I am trying to build a settop box with two cards, a PVR-150 and a DVB
> >>>> card. The mini-ITX motherboard has only one PCI slot, so I bought an
> >>>> active PCI riser.
> >> Please define "active". Is there a PCI bridge chip on the riser card?
> >> Or better: Tell us manufacturer and type of this PCI riser card and the
> >> mini-ITX board.
> > 
> > Certainly many riser cards only have jumpers to change the irq for the
> > second slot, or some default built in remapping.  And they may have id
> > select pins to pick which slots they should pretend to be.  From what I
> > have read, via mini itx boards require a very specific design for riser
> > boards, which isn't what most riser boards do.  Other mini itx boards
> > are probably different.
> 
> The main problem is the unknown BIOS support for the PCI configuration.
> Maybe the manufacturer is at least willing to publish the default
> configuration, so the PCI riser can be modified/fixed to the same
> config. (Just call him and ask for the board designer... YMMV)
> 
> However, AFAIK this (re-)configuration can be done by the kernel, too.
> (on embedded ppc platforms, the PCI mapping is done in the kernel)
> 
> At least from the electrical engineer's point of view it's not
> difficult to modify a dumb passive PCI riser card to have the IRQ's and
> REQ/GNTs routed and have the IDSEL soldered with 220 Ohms to the
> proper AD line pin. (been there, done that)
> (If somebody want's to mess around with that stuff, contact
> me off list, it's getting OT here.)
> 
> > Certainly the simplest is a riser card with a proper pci bridge that
> > creates a secondary pci bus with it's own device ids and maps the
> > interrupts correctly.  Then all that really matters is that the bios on
> > the board supports pci bridges (a few companies actually manage to fail
> > to support pci bridges at all in their bioses).
> 
> True. It might be more easy to get that running, hoping that
> the BIOS enumerates the bridge right.
> Kernel support shouldn't be an issue here as long as the
> chip is supported.
> 
> Best greets,

Sorry for the late reply, I don't have internet connection at home yet.

I tested things a little more and the situation is getting better.

First the riser card is a dual slot one , with a chip on it so I assumed
it is active. It has jumpers to set the device number of the upper slot
and the devices in the two slots have to share the IRQ. This is it
here :
www.tranquilpc.co.uk/support/Files/TPC014/Tranquil%20Riser.pdf

Second : I found out that tvtime and mplayer cannot deal with the
pvr-150 card as a normal analogue card. mplayer can deal with it using
the pvr:// syntax. Also using ivtv-tune and mplayer /dev/video0 works.

So the error tvtime was giving was probably because it uses v4l1 ioctls
which are not supported by ivtv or something, just a wild guess.

Mythtv works fine when choosing MPEG2 card.

Third : The bug lies in the situation where the PVR-150 card is in the
upper slot and the DVB card is in the lower slot, in which case the DVB
card does not work. That was the dmesg output I posted earlier.

Fourth : here's cat /proc/interrupts in the current working situation
with the PVR-150 card in the lower slot and the DVB card in the upper
slot.
  0:         64   IO-APIC-edge      timer
  1:       1130   IO-APIC-edge      i8042
  7:          0   IO-APIC-edge      parport0
  8:          3   IO-APIC-edge      rtc
  9:          0   IO-APIC-fasteoi   acpi
 12:          4   IO-APIC-edge      i8042
 14:      18035   IO-APIC-edge      ide0
 17:          0   IO-APIC-fasteoi   ohci_hcd:usb1
 18:         26   IO-APIC-fasteoi   ohci_hcd:usb2
 19:          0   IO-APIC-fasteoi   ohci_hcd:usb3
 20:          2   IO-APIC-fasteoi   ehci_hcd:usb4
 21:      12329   IO-APIC-fasteoi   eth1
 22:      16399   IO-APIC-fasteoi   SiS SI7012
 23:      15020   IO-APIC-fasteoi   saa7134[0], saa7134[0], ivtv0
NMI:          0 
LOC:     757294 
ERR:          0
MIS:          0

As you can see the two cards are sharing the IRQ properly.

Thanks and sorry for replying late.


