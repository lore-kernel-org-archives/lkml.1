Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559Ab0AFCRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0AFCRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 21:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508Ab0AFCRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 21:17:47 -0500
Received: from pc-249.acfr.usyd.edu.au ([129.78.210.249]:33633 "EHLO
	rosaceae.acfr.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab0AFCRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 21:17:46 -0500
From: Alex Brooks <a.brooks@marathon-robotics.com>
Organization: Marathon Robotics
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: BAR 0: can't allocate resource
Date: Wed, 6 Jan 2010 13:16:21 +1100
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001061305.31635.a.brooks@marathon-robotics.com>
In-Reply-To: <201001061305.31635.a.brooks@marathon-robotics.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001061316.21744.a.brooks@marathon-robotics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > I have a problem getting a couple of PCI cards to play nicely
> > > > together. ...
> > > >
> > > > And (for both kernels) the output of lspci has the following line:
> > > > 01:04.0 Unclassified device [0080]: Device 0002:0080
> > >
> > > When you have only the 8-port serial card installed, it appears at
> > > 01:04.0. When you have both cards installed, we don't see a new device,
> > > and whatever is at 01:04.0 no longer looks like the octal UART.
> >
> > I'm pretty sure that it is the octal UART, but it isn't being recognised
> > properly.
>
> I'm sure it *is* the UART, but we're getting the wrong data back from
> it, so we can't use it. The Mini PCI adapter must be interfering with
> the UART board somehow. Since you said the Mini PCI slot on the adapter
> is empty, and the jumpers are programmed correctly, I suspect the adapter
> is broken. Maybe a connector problem? Do you have another one that
> behaves the same way?

Unfortunately I don't have space PC104 cards.  But I do have a spare PC104 
motherboard (not the same brand/model), and on this I can verify that both 
cards work correctly.

> If you put a Mini PCI card in the slot and try this in a system without
> the UART card, does the Mini PCI card work correctly? The jumpers on
> the adapter should determine the PCI bus number where the Mini PCI device
> appears.

Yes, a MiniPCI card in the slot works regardless of what other PCI cards are 
on the bus.  I'm trying to debug this without a MiniPCI card to remove extra 
variables.

> > To test this theory, I tried with (a) no cards at all, and (b)
> > just the MiniPCI adapter (no serial card) -- nothing else appears at
> > 01:04.0 (output of lspci attached).
>
> The PC/104+ to Mini PCI adapter looks like it's completely passive. It
> should be invisible to the OS, so it won't appear in lspci. For both
> cases, the lspci output you attached is exactly what I would expect.
>
> I don't see any indication that this is a software problem (I know nothing
> about PC/104, so let me know if you disagree, and why).

I don't have a smoking gun that points at software, it was just my guess based 
on:
 a) all the pieces of hardware work in certain combinations
 b) there's a nasty-looking error message in dmesg

> > > If so, both of those web pages mention jumpers that set the card's
> > > PCI device ("slot") number. My guess is that both of your cards
> > > are set to the same number.
> >
> > I'd already looked for this, I'm certain I have the jumpers right (I
> > tried intentionally setting them incorrectly, the failure mode is
> > different).
>
> How did you set them, and what was the failure? If the adapter is really
> passive and the Mini PCI slot is empty, it seems strange that the adapter
> jumper setting would make any difference at all.

I tried a few different incorrect settings, at least one of them was with both 
cards on the same ID.  The computer failed to boot (i.e. didn't get to the 
linux kernel at all).


Alex

-- 
------------------------------
Dr Alex Brooks

Marathon Robotics Pty Ltd
National Innovation Centre
4 Cornwallis Street
Eveleigh, NSW 2015
Sydney, Australia
Ph: +61 2 9209 4021
Web: www.marathon-robotics.com
------------------------------
