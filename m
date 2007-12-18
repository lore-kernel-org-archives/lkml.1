Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbXLRVxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbXLRVxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbXLRVxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:53:09 -0500
Received: from are.twiddle.net ([64.81.246.98]:58720 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbXLRVxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:53:06 -0500
Date: Tue, 18 Dec 2007 13:51:43 -0800
From: Richard Henderson <rth@twiddle.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
Message-ID: <20071218215143.GA24769@twiddle.net>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
	Keith Packard <keithp@keithp.com>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net> <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 01:09:15PM -0800, Linus Torvalds wrote:
> However, I wonder about that
> 
> 	e0000000-efffffff : pnp 00:0b
> 
> thing. I actually suspect that that whole allocation is literally *meant* 
> for that 256MB graphics aperture, but the kernel explicitly avoids it 
> because it's listed in the PnP tables.

I assumed it was reserved for the pccard thing, which I don't see
listed or allocated anywhere else.  

> I wonder what the heck is the point of that pnp entry. Just for fun, can 
> you try to just disable CONFIG_PNP, and see if it all works then?

I'll try that, for grins.

> I'll add Keithp to the cc too, to see if the X issues can be clarified. 
> Maybe he can set us right. But maybe you just have an old X server?

I've got xorg-x11-server-Xorg-1.3.0.0-36.fc8 installed.  I wouldn't
have thought that was too old, since Fedora 8 just came out, but it's
not like I keep up on these things.  I'll give 1.4.99 a try, as that's
what's current in Rawhide.

> Of course, we could also make the minimum address more of a *hint*, and 
> only make the resource allocator only abut the top-of-known-memory when it 
> absolutely has to....

Another way to look at this is that the graphics BAR came in from
the BIOS allocated at c0000000, and we ignored that.  Perhaps there's
a way to give weight to the BIOS settings when consdering where the
PCI region is supposed to start?

On that system for which there was undeclared resources, did the BIOS
avoid that resource for the other PCI resources?  I suspect it did...


r~
