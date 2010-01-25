Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454Ab0AYWE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab0AYWE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 17:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229Ab0AYWE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 17:04:27 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43829 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752321Ab0AYWE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 17:04:26 -0500
Date: Mon, 25 Jan 2010 17:04:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/8] PM: Asynchronous suspend and resume of devices
In-Reply-To: <201001252226.29289.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1001251653140.1733-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010, Rafael J. Wysocki wrote:

> > You may have to delay 6/8 as well, since the controllers are PCI
> > devices.  Writing the new code shouldn't take too long, though.
> 
> No problem with that.
> 
> Alternatively, if Greg agrees, I can add your patches modifying this into this
> series.  Greg?
> 
> I wonder, though.  Since the controllers are PCI devices, we put them into D0
> and restore their standard config spaces in the dpm_list order at the "early"
> resume stage.  Doesn't that help here?

No.  The problem is that the "late" resume routines in the host
controller drivers reinitialize the hardware, and existing connections
(i.e., from before the system sleep) may not be handled properly if the
controllers are initialized in the wrong order.


> > > I'll try that, but my mkinitrd automatically puts the USB drivers into
> > > initramfs.  I guess I'll need to do some research to really verify it. :-)
> > 
> > Then when you install the test kernel, mkinitrd should build a
> > corresponding initramfs image with the modified drivers, right?  
> > Otherwise there would be a version mismatch error when the init code
> > tried to load the old drivers into the new kernel.
> 
> Yes, but then they are loaded during restore before the image is read and
> the hardware is initialized.  Would it still fail in that case?

It wouldn't matter.  What the boot kernel does shouldn't affect what 
happens after the image starts running.

BTW, I should mention that these problems don't always occur 100% of 
the time, even when the order constraints are violated.  There may
still be other races that can affect the result.  But try it and see...

Alan Stern

