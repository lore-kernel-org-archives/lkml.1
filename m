Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbXKUV4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbXKUV4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 16:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXKUV4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 16:56:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59061 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752113AbXKUV4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 16:56:00 -0500
Date: Wed, 21 Nov 2007 16:55:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Laurent Pinchart <laurent.pinchart@skynet.be>
cc: linux-usb-devel@lists.sourceforge.net, Felipe Balbi <me@felipebalbi.com>,
       Oliver Neukum <oliver@neukum.org>,
       Markus Rechberger <mrechberger@gmail.com>,
       <linux-kernel@vger.kernel.org>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, Mark Lord <lkml@rtr.ca>
Subject: Re: [linux-usb-devel] USB deadlock after resume
In-Reply-To: <200711212152.16066.laurent.pinchart@skynet.be>
Message-ID: <Pine.LNX.4.44L0.0711211645290.13770-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Laurent Pinchart wrote:

> > > When you suspend, you cut off vbus (afaik, correct me if I'm wrong),
> > > which means your device will get disconnected. One way to avoid this is
> > > enabling CONFIG_USB_PERSIST and trying with that on.
> >
> > Suspend may or may not cut off power.
> 
> I've always been confused by this.
> 
> If I'm not mistaken, there are three kind of suspend modes: autosuspend, 

You mean runtime (AKA dynamic) suspend -- autosuspend is merely one
type of runtime suspend.

> suspend to RAM and suspend to disk.

The nomenclature du jour is just plain "suspend" for suspend-to-RAM and
"hibernation" for suspend-to-disk.

> In the first case I expect the USB hub 
> (either root hub or external hub) to make the bus idle but not power it down. 

Correct.

> In the last case I suspect the USB bus to be powered down.

Usually, not but always!  Some Macs have been known to keep USB suspend 
current available during hibernation.

> What controls the USB bus power on suspended ports ? Is it handled by the 
> system (BIOS, ...) ? Is it allowed to power down the ports or keep them 
> powered as it chooses ? What are the rules set in stone ?

There are no rules set in stone.  :-)

Systems are _supposed_ to keep the ports powered during suspend, but
some may fail to do so.  It depends on the firmware (i.e., BIOS for
PCs) and the motherboard design.

> > If it does cut off power, resume() will never be called, instead either
> > disconnect() or reset_resume(). 
> 
> What is reset_resume() for ? Which one will be called on resume after a bus 
> power down ?

This is explained in Documentation/usb/power-management.txt.  If the
USB Persist facility has been enabled for a device then reset_resume
will be called, to indicate that the device had to be reset as part of
the resume procedure.  If USB Persist isn't enabled then the disconnect
method will be called and the device will be re-enumerated, exactly as
though it had been unplugged and then plugged back in.

Alan Stern

