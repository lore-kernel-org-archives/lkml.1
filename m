Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbXKUQbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbXKUQbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 11:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbXKUQbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 11:31:16 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46711 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754581AbXKUQbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 11:31:15 -0500
Date: Wed, 21 Nov 2007 11:31:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Markus Rechberger <mrechberger@gmail.com>
cc: Oliver Neukum <oliver@neukum.org>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, Mark Lord <lkml@rtr.ca>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] USB deadlock after resume
In-Reply-To: <d9def9db0711210637x6fd5ad09o549b787639690d55@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0711211128380.3226-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Markus Rechberger wrote:

> > > it's not just usb_set_interface that hangs actually.
> > > It seems to hang at
> > >
> > > wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
> > >
> > > in drivers/usb/core/urb.c after resuming. I disabled access to the usb
> > > subsystem in the uvc driver, although connecting any other usb storage
> > > fails too, just at the same point.
> >
> > Which URB is usb_kill_urb() called for?
> >
> 
> it's the usb_control_message which calls usb_kill_urb if I haven't got
> it wrong. (if you're looking for some other information please let me
> know)
> Although, I got a bit further with it. The error seems to happen
> earlier already.
> If I load the driver, and do not access the device after suspending
> all usb_control commands fail with -71 eproto.

That's very strange.  Getting -71 errors is understandable; it 
indicates that the device can't handle being suspended.  But the 
wait_event() line still shouldn't hang.  If it does, it indicates that 
there's something wrong with the USB host controller, not just the 
device.

Can you try testing this on a different sort of computer?

Alan Stern

