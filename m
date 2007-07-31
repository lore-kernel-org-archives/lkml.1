Return-Path: <linux-kernel-owner+w=401wt.eu-S932896AbXGaVZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbXGaVZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbXGaVZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:25:47 -0400
Received: from canuck.infradead.org ([209.217.80.40]:57091 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759419AbXGaVZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:25:46 -0400
Date: Tue, 31 Jul 2007 14:24:54 -0700
From: Greg KH <greg@kroah.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       linux-usb-devel@lists.sourceforge.net
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stuart Hayes <Stuart_Hayes@dell.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: USB-related instability on 2.6.23-rc1
Message-ID: <20070731212454.GB18839@kroah.com>
References: <fa686aa40707311406w10169a20ibbef77c198020af8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40707311406w10169a20ibbef77c198020af8@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 03:06:07PM -0600, Grant Likely wrote:
> I've observed instability on my Macbook c2d with the Linus' latest
> tree.  Symptom is that USB devices start behaving badly and the kernel
> seems to be registering incorrect HID events; (ie. moving the mouse
> causes odd keyboard events).  If I continue to attempt to use the
> mouse, it results in a system freeze (and I don't see any kind of
> backtrace in /var/log/kern.log).  To reproduce the problem, I just
> need to be using the keyboard/mouse.  If I leave the system idle, the
> problem does not seem to occur.  If I actively use the keyboard/mouse,
> the problem can occur at any time; usually within 5-10 minutes.
> 
> In my particular case, I've got both a USB key/mouse pair on the
> laptop and an external key/mouse pair plugged in via a hub.
> Typically, it's the external mouse that exhibits badness first.
> 
> USB HID devices are definitely affected.  I have not tested USB block
> devices.  Isochronous transfers to a USB headset appear to be
> unaffected, but that's under minimal testing.
> 
> I've bisected down to commit 196705c9bbc03540429b0f7cf9ee35c2f928a534,
> "USB: EHCI cpufreq fix"
> 
> Reverting the patch at the head of the tree makes the kernel stable again.
> 
> I've attached my kernel config file and a dmesg output

Can you enable CONFIG_USB_DEBUG and send the linux-usb-devel list and
us, the output when you have these problems?

thanks,

greg k-h
