Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbXL0RyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbXL0RyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 12:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbXL0Rxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 12:53:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbXL0Rxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 12:53:52 -0500
Date: Thu, 27 Dec 2007 09:52:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, inux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-Reply-To: <47739203.3060809@garzik.org>
Message-ID: <alpine.LFD.0.9999.0712270945320.21557@woody.linux-foundation.org>
References: <20071225032605.29147200@laptopd505.fenrus.org> <47739203.3060809@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Dec 2007, Jeff Garzik wrote:
> 
> 2) [non-minor] hmmmm.
> 
> 	[jgarzik@core ~]$ lspci -n | wc -l
> 	23
> 
> So I would have to perform 23 sysfs twiddles, before I could obtain a full and
> unabridged 'lspci -vvvxxx'?

Or you force it on with "pci=mmconfig" or something at boot-time.

But yes. The *fact* is that MMCONFIG has not just been globally broken, 
but broken on a per-device basis. I don't know why (and quite frankly, I 
doubt anybody does), but the PCI device ID corruption happened only for a 
specific set of devices.

Whether it was a timing issue with particular devices or whether it was a 
timing issue with some particular bridge (and could affect any devices 
behind that bridge), who knows... It almost certainly was brought on by a 
borderline (or broken) northbridge, but it apparently only affected 
specific devices - which makes me suspect that it wasn't *entirely* due to 
just the northbridge, and it was a combination of things.

I don't understand why you cannot seem to accept that per-device thing, in 
the face of clear data that yes, it really *is* per-device. Not to mention 
the fact that the way MMIO config setups work, you may well have entire 
buses that simply aren't accessible with MMIO config at all (because the 
MMIO config window is not large enough).

Furthermore, please accept the fact that of those 23 devices, exactly 
*none* will actually care. So yes, you'd have to enable it manually for 
those individual devices, but that's only if you want to do something 
totally pointless in the first place.

So stop this totally inane "it has to be global" crap. It doesn't have to 
be global at all, and we have hard data showing that it really SHOULD NOT 
be a global flag.

		Linus
