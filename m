Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbXLRV5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbXLRV5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbXLRV5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:57:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbXLRV53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:57:29 -0500
Date: Tue, 18 Dec 2007 13:56:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Richard Henderson <rth@twiddle.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
In-Reply-To: <47683FA1.6070103@redhat.com>
Message-ID: <alpine.LFD.0.9999.0712181353300.21557@woody.linux-foundation.org>
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net>
 <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org> <47683FA1.6070103@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Dec 2007, Chuck Ebbert wrote:

> On 12/18/2007 04:09 PM, Linus Torvalds wrote:
> > 
> > I wonder what the heck is the point of that pnp entry. Just for fun, can 
> > you try to just disable CONFIG_PNP, and see if it all works then?
> 
> pnpacpi=off should work.
> 
> PnP is also trying (and failing) to reserve all physical memory.

Yeah, that really is a pretty confused-looking pnp table thing. But I have 
absolutely zero idea how PnP is even supposed to work - the whole thing is 
just a total hack for Windows, afaik.

The sad part is that *normally* the right thing to do about almost any 
BIOS information is what we do right now: just avoid that magic address 
range like the plague, because we have no clue what the heck the BIOS is 
up to. But it looks like in this particular case, some of the problems 
may arise exactly *because* we avoid that range.

It would be good to know what Windows does. If ACPI is found, does it 
perhaps just ignore all the PnP entries these days?

			Linus
