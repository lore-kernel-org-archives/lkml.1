Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbYLNPvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbYLNPvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 10:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYLNPu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 10:50:59 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3474 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752677AbYLNPu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 10:50:58 -0500
Date: Sun, 14 Dec 2008 10:50:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Keith Packard <keithp@keithp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB interrupt handler routine
In-Reply-To: <20081214044112.GA28733@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0812141041350.22595-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008, Greg KH wrote:

> <added linux-usb list, that's the proper place for it...)
> 
> On Thu, Dec 11, 2008 at 08:35:37PM -0800, Keith Packard wrote:
> > We recently made a patch in the Intel DRM driver:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b60678a75d44fa9d5969f79781bd856ad5858609
> > 
> > This switches from non-MSI to MSI-mode.
> > 
> > It "should" have had no effect, but our concern is that what we're
> > really seeing is interrupt sharing troubles. We've had several people
> > say that they got an interrupt flood when plugging in a USB stick or
> > external disk.

Which drivers are using the IRQ that gets flooded?  Can we see a dmesg 
log from a kernel built with CONFIG_USB_DEBUG enabled?

> > Switching the graphics driver to MSI mode "cures" the
> > bug, but that sure seems like a work-around rather than a bug fix to me.
> > 
> > When our driver is active, it can generate a lot of interrupts,
> > potentially thousands per second. Is it possible that the UHCI or EHCI
> > drivers could get confused if checking for interrupt status this often?

I don't think so.

> > Eric noted that the USB driver

Which USB driver?  Does this refer to usb_hcd_irq()?

> > appears to not check and ACK interrupt
> > status unconditionally, preferring to check the software state
> > beforehand. I'm wondering if this may open up a potential race between
> > hardware state change and ISR bit setting.

Not if the drivers are written correctly.  As far as I know, they are.

Alan Stern

