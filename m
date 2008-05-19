Return-Path: <linux-kernel-owner+w=401wt.eu-S1762357AbYESPs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762357AbYESPs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758093AbYESPrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:47:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36577 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760909AbYESPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:47:12 -0400
Date: Mon, 19 May 2008 11:47:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.6.26-rc1 regression since 2.6.25
In-Reply-To: <20080519104948.GA4557@ics.muni.cz>
Message-ID: <Pine.LNX.4.44L0.0805191126260.15266-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Lukas Hejtmanek wrote:

> On Tue, May 13, 2008 at 04:06:20PM -0400, Alan Stern wrote:
> > > I did. The dmesg is attached to the bug:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=10630
> > 
> > It looks as though the dock's USB hub may not be working right.
> 
> Maybe, Lenovo HW is a piece of crap.

That's certainly possible.

>  Anyway, it worked up to 2.6.25
> (including).

Can you attach an equivalent dmesg log for 2.6.25 (with
CONFIG_USB_DEBUG enabled, of course)?

> > Just as a test, can you try applying gregkh-04-usb-2.6.26-rc2.patch 
> > (it applies to 2.6.26-rc2, obviously) from
> > 
> > 	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
> > 
> > and attaching the dmesg log from that?  It contains extra debugging not 
> > present in the vanilla kernel -- make sure that you keep 
> > CONFIG_USB_DEBUG enabled.
> 
> I did another attachement of the dmesg to the bugzilla.

Let me get this straight.  You booted without the dock, and then at 
this line:

> [14315425.975807] ACPI: \_SB_.GDCK - docking

you plugged the computer into the dock, right?

Then apparently here:

> [14315508.451197] ehci_hcd 0000:00:1a.7: port 4 remote wakeup

you plugged the USB drive into the dock, but it wasn't detected.  Or
maybe I've got it backward, the drive was already plugged in when you
docked the computer, and 14315508.451197 is when you unplugged the
drive.  Which was it?

AFAICS, the dock never reported the existence of the USB drive.

Okay, let's see some more debugging information on this.  Get a usbmon
trace (see Documentation/usb/usbmon.txt) for bus 3, starting just 
before you dock the computer.  That will tell us exactly what the 
dock's USB hub is reporting.

By the way, are you entirely certain that 2.6.25 works correctly in
both cases: drive already attached when you dock the computer, and
drive plugged in after the computer is docked?  I guess it would be
good to see equivalent usbmon traces for both 2.6.25 and 2.6.26-rc2.

Alan Stern

