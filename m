Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbYA1UCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbYA1UCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYA1UBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:01:51 -0500
Received: from iabervon.org ([66.92.72.58]:49217 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761975AbYA1UBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:01:50 -0500
Date: Mon, 28 Jan 2008 15:01:41 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Richard Heck <rgheck@bobjweil.com>
cc: Gene Heskett <gene.heskett@gmail.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
In-Reply-To: <479E1D9E.3000900@bobjweil.com>
Message-ID: <alpine.LNX.1.00.0801281445200.13593@iabervon.org>
References: <200801272122.21823.gene.heskett@gmail.com> <1201539043.31293.7.camel@zem> <1201540830.6526.19.camel@localhost> <200801281230.32910.gene.heskett@gmail.com> <alpine.LNX.1.00.0801281248190.13593@iabervon.org> <479E1D9E.3000900@bobjweil.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008, Richard Heck wrote:

> Daniel Barkalow wrote:
> > Can you switch back to old IDE to get your work done (and to make sure it's
> > not a hardware issue that's developed recently)? 
> I think it'd be really, REALLY helpful to a lot of people if you, or someone,
> could explain in moderate detail how this might be done. I tried doing it
> myself, but I'm not sufficiently expert at configuring kernels that I was ever
> able to figure out how to do it.

As far as configuring the kernel, I can help:

Go to Device Drivers, ATA/ATAPI/MFM/RLL support, and turn on anything that 
looks relevant; go to Device Drivers, Serial ATA and Parallel ATA drivers, 
and turn off anything that's PATA and looks relevant.

(Whether a device uses IDE or PATA depends on which driver that supports 
the device is present and find it first, not on any sort of global 
configuration, which is probably what tripped you up)

Building this and installing it along with the appropriate initrd (which 
might be handled by Fedora's install scripts) will either get you back to 
old IDE or will make your kernel panic on boot, depending on whether you 
got it right (so make sure you can still boot the kernel you're sure of or 
something from a boot disk). This will also cause your hard drives to show 
up as different device nodes, so if your boot process doesn't mount by 
disk uuid but by some other feature (and I don't know what Fedora does), 
you'll also need to change it to something either stable across access 
methods or which works for the one you're now using.

> Obviously, the short version is: switch back to Fedora 6. But this kind of
> problem with libata---and yes, you're almost surely right that it's not one
> problem but lots---is sufficiently widespread that a Mini HOWTO, say, would be
> really welcome and, I'm guessing, widely used.

Fedora really ought to provide documentation, because there's some 
distro-specific stuff (like how you deal with the kernel's device node for 
the root partition changing), and they're using code by default that's at 
least somewhat documented as experimental (although it doesn't seem to be 
actually marked as experimental in all cases).

	-Daniel
*This .sig left intentionally blank*
