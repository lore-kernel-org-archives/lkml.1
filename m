Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241Ab0AYV0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0AYV0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712Ab0AYV0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:26:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52095 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab0AYV0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:26:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/8] PM: Asynchronous suspend and resume of devices
Date: Mon, 25 Jan 2010 22:26:29 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-usb@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <Pine.LNX.4.44L0.1001242155410.4189-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001242155410.4189-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001252226.29289.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Alan Stern wrote:
> On Mon, 25 Jan 2010, Rafael J. Wysocki wrote:
> 
> > > I intend to write this code, but merging it will be a little tricky.  
> > > You'll have to coordinate with Greg KH.
> > 
> > OK, I don't think that's a big deal.  I can defer patch 7/8 until that code has
> > been merged.
> 
> You may have to delay 6/8 as well, since the controllers are PCI
> devices.  Writing the new code shouldn't take too long, though.

No problem with that.

Alternatively, if Greg agrees, I can add your patches modifying this into this
series.  Greg?

I wonder, though.  Since the controllers are PCI devices, we put them into D0
and restore their standard config spaces in the dpm_list order at the "early"
resume stage.  Doesn't that help here?

> Is there a good way to iterate through all PCI devices in a particular
> slot, or should it be done by going through all PCI devices and
> ignoring those in other slots?  Calling pci_get_slot() multiple times
> doesn't look very efficient.

Hmm, I don't know (added Jesse and Linux PCI to the CC list again).

> > I'll try that, but my mkinitrd automatically puts the USB drivers into
> > initramfs.  I guess I'll need to do some research to really verify it. :-)
> 
> Then when you install the test kernel, mkinitrd should build a
> corresponding initramfs image with the modified drivers, right?  
> Otherwise there would be a version mismatch error when the init code
> tried to load the old drivers into the new kernel.

Yes, but then they are loaded during restore before the image is read and
the hardware is initialized.  Would it still fail in that case?

> If nothing else works, you can simply unload the standard uhci-hcd,
> ohci-hcd, and ehci-hcd drivers and then modprobe the modified versions
> before starting the hibernation.

I guess I'll just build a special "restore" kernel without USB support.

Rafael
