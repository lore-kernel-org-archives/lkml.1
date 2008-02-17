Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbYBQDf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbYBQDf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYBQDfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 22:35:09 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2228 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751212AbYBQDfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 22:35:06 -0500
Date: Sat, 16 Feb 2008 22:35:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Buehler <abuehler.kernel@gmail.com>
cc: Oliver Pinter <oliver.pntr@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]*
In-Reply-To: <47B78A08.1020502@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0802162210110.13745-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008, Andrew Buehler wrote:

> Messages sent to my address directly are explicitly not filtered into
> the folders I have set up for various mailing lists, so that if someone
> does send me a "heads up" reply for a specific topic on a list to which
> I am subscribed it does not get caught by the list filter and fail to
> come to my attention. If a message fails to be filtered into any
> mailing-list folder, then I should be able to conclude that it is
> specifically intended for me, and not part of normal mailing-list
> traffic. The practice of sending replies to both addresses renders this
> an invalid conclusion. I do not think that it is unreasonable to expect
> that conclusion to be valid.

It's not unreasonable.  Neither is Aristotelian physics.  Nevertheless, 
neither one is a good match to reality.

Why not arrange instead that messages sent from a mailing list server
_do_ get filtered into the corresponding folder, even if they were also
sent to your address?  This certainly should make your assumption (that
messages not filtered into any mailing-list folder are specifically
intended for you) much more valid than it is now.

> It's not that I'm not receiving all of this thread's messages via the
> list - it's that I'm not receiving *any* of them via the list, and I
> suspect that the reason is that my address is in both the To:/Cc: and
> the list itself. Something is filtering it such that I do not receive
> "duplicate" replies in this way, but it is doing so by filtering out the
> list copy rather than the direct copy. I have seen mailing lists which
> do this before, but I see no other indication that the LKML is one of
> them, and I would not be in the least surprised if this turned out to be
> yet one more problem with gmail.

Well, I _am_ receiving your messages by way of linux-usb as well as
directly, for whatever that's worth.


> > is an indication that interrupt routing is indeed not working right.
> > Or possibly your EHCI controller isn't working.  You could try
> > blacklisting or unloading ehci-hcd to see if that helps.  Of course
> > then none of your USB devices would be able to run at high speed.
> 
> ehci-hcd is not modular in my current kernel, and if there is a way to
> turn it off without its being modular I am not aware of it.

Go into the /sys/bus/pci/drivers/ehci_hcd directory.  Then for each 
symbolic link to a controller device listed there, write the device's 
name (with "echo -n") to the "unbind" file.  For example,

	echo -n 0000:00:1d.7 >unbind

That will have nearly the same effect as unloading ehci-hcd.

> Until this thread, I was not even aware that ACPI was related to USB; I
> had largely conflated it with a similar acronym which I think is related
> to power management and which I can suddenly not even find in my kernel
> config. I will, however, look into linux-acpi.

ACPI isn't directly related to USB; rather it has to do with
transferring information between the OS and the
BIOS/vendor-specific-hardware.  Power management is example where such
a transfer is needed.  In your case, the relevant information is which
IRQ is connected to which motherboard device.  If you don't have ACPI
enabled in your configuration, then perhaps that's the problem -- try
enabling it.

> That will not be helpful for the other two problems, however, since
> neither of them was ever working as far as I am aware. That also leaves
> me hesitant to conclude that they are rooted in the same IRQ issue as
> the USB problem appears to be.

Maybe they aren't.  But when you have multiple bugs, you have to fix
them one at a time.

> Which lists or other addresses would be appropriate for reporting
> problems with AHCI/libata and with networking, specifically with the
> e1000/e1000e drivers? I see a mailing list for e1000 in MAINTAINERS, but
> only the maintainer's address for SATA/libata/whatever else may be
> involved there, and I am reflexively reluctant to bother a maintainer
> directly with as little information as I presently have.

I don't know, but you should wait until the simpler problem is sorted 
out before tackling the more complicated ones.

Alan Stern

