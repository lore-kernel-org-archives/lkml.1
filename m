Return-Path: <linux-kernel-owner+w=401wt.eu-S1752436Ab0AYDMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab0AYDMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 22:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061Ab0AYDMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 22:12:34 -0500
Received: from netrider.rowland.org ([192.131.102.5]:52262 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752103Ab0AYDMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 22:12:34 -0500
Date: Sun, 24 Jan 2010 22:12:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       <linux-usb@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [PATCH 2/8] PM: Asynchronous suspend and resume of devices
In-Reply-To: <201001250027.42621.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1001242155410.4189-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010, Rafael J. Wysocki wrote:

> > I intend to write this code, but merging it will be a little tricky.  
> > You'll have to coordinate with Greg KH.
> 
> OK, I don't think that's a big deal.  I can defer patch 7/8 until that code has
> been merged.

You may have to delay 6/8 as well, since the controllers are PCI
devices.  Writing the new code shouldn't take too long, though.

Is there a good way to iterate through all PCI devices in a particular
slot, or should it be done by going through all PCI devices and
ignoring those in other slots?  Calling pci_get_slot() multiple times
doesn't look very efficient.


> I'll try that, but my mkinitrd automatically puts the USB drivers into
> initramfs.  I guess I'll need to do some research to really verify it. :-)

Then when you install the test kernel, mkinitrd should build a
corresponding initramfs image with the modified drivers, right?  
Otherwise there would be a version mismatch error when the init code
tried to load the old drivers into the new kernel.

If nothing else works, you can simply unload the standard uhci-hcd,
ohci-hcd, and ehci-hcd drivers and then modprobe the modified versions
before starting the hibernation.

Alan Stern

