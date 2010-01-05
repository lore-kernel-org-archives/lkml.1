Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486Ab0AEXA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0AEXA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322Ab0AEXAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:00:22 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:25015 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab0AEXAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:00:17 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alex Brooks <a.brooks@marathon-robotics.com>
Subject: Re: BAR 0: can't allocate resource
Date: Tue, 5 Jan 2010 16:00:13 -0700
User-Agent: KMail/1.9.10
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001052018.02607.a.brooks@marathon-robotics.com> <201001051033.19486.bjorn.helgaas@hp.com> <201001060919.48453.a.brooks@marathon-robotics.com>
In-Reply-To: <201001060919.48453.a.brooks@marathon-robotics.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001051600.14982.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010 03:19:47 pm Alex Brooks wrote:
> > > I have a problem getting a couple of PCI cards to play nicely together.
> > > ...
> > >
> > > And (for both kernels) the output of lspci has the following line:
> > >   01:04.0 Unclassified device [0080]: Device 0002:0080
> >
> > When you have only the 8-port serial card installed, it appears at
> > 01:04.0.  When you have both cards installed, we don't see a new device,
> > and whatever is at 01:04.0 no longer looks like the octal UART.
> 
> I'm pretty sure that it is the octal UART, but it isn't being recognised 
> properly.

I'm sure it *is* the UART, but we're getting the wrong data back from
it, so we can't use it.  The Mini PCI adapter must be interfering with
the UART board somehow.  Since you said the Mini PCI slot on the adapter
is empty, and the jumpers are programmed correctly, I suspect the adapter
is broken.  Maybe a connector problem?  Do you have another one that
behaves the same way?

If you put a Mini PCI card in the slot and try this in a system without
the UART card, does the Mini PCI card work correctly?  The jumpers on
the adapter should determine the PCI bus number where the Mini PCI device
appears.

> To test this theory, I tried with (a) no cards at all, and (b)  
> just the MiniPCI adapter (no serial card) -- nothing else appears at 01:04.0 
> (output of lspci attached).

The PC/104+ to Mini PCI adapter looks like it's completely passive.  It
should be invisible to the OS, so it won't appear in lspci.  For both
cases, the lspci output you attached is exactly what I would expect.

I don't see any indication that this is a software problem (I know nothing
about PC/104, so let me know if you disagree, and why).

> > If so, both of those web pages mention jumpers that set the card's
> > PCI device ("slot") number.  My guess is that both of your cards
> > are set to the same number.
> 
> I'd already looked for this, I'm certain I have the jumpers right (I tried 
> intentionally setting them incorrectly, the failure mode is different).

How did you set them, and what was the failure?  If the adapter is really
passive and the Mini PCI slot is empty, it seems strange that the adapter
jumper setting would make any difference at all.

Bjorn
