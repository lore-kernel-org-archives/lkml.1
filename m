Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbXHBQlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbXHBQlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbXHBQkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:40:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:55143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757378AbXHBQkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:40:51 -0400
Date: Thu, 2 Aug 2007 09:43:29 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Engraf <david.engraf@netcom.eu>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB BIOS early handoff only when the
	we the driver is configured
Message-ID: <20070802164329.GD28721@suse.de>
References: <46B1844B.8090007@netcom.eu> <Pine.LNX.4.44L0.0708021009460.3611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708021009460.3611-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 10:32:21AM -0400, Alan Stern wrote:
> On Thu, 2 Aug 2007, David Engraf wrote:
> 
> > This would be solution too, but what if someone uses the uhci controller
> > and don't want the
> > ehci. So a single Kconfig flag wouldn't be enough, we have to add 3
> > flags for uchi, ohci and
> > ehci. I think this maybe a little bit difficult when configuring the kernel.
> > The best solution would be when we could use the CONFIG_USB_xxxx_HCD
> > flag, but it
> > seems that some hardware has problems when we disable the handoff and
> > let the BIOS
> > control the usb controller. Do you know any of this hardware?
> 
> The email messages are hidden in the depths of the linux-usb-devel 
> archives.  Maybe you can find them by checking the Git history for 
> drivers/usb/host/pci-quirks.c, finding the dates for patches that 
> affected the handoff code, and then searching through the archives near 
> those dates.
> 
> IIRC the problems arose on some MIPS machines.  And I don't think the 
> problem involved letting the firmware manage the USB controller; I 
> think the problem came when the controller driver tried to do the 
> handoff later on.

It wasn't just MIPS.  IBM has a very popular blade system that has huge
issues with this, and I think there are some other IBM systems based on
the same BIOS that also do bad things if we don't grab the USB
controller away from the BIOS as soon as possible (nasty interrupt and
other messes happen...)

thanks,

greg k-h
