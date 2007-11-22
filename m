Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbXKVRHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbXKVRHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 12:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbXKVRHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 12:07:04 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3226 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751676AbXKVRHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 12:07:03 -0500
Date: Thu, 22 Nov 2007 12:07:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Kirill A. Shutemov" <k.shutemov@velesys.com>
cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.24-rc3-mm1: usb mouse doesn't work
In-Reply-To: <20071122101750.GC7085@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0711221202490.31699-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007, Kirill A. Shutemov wrote:

> > > uhci_hcd 0000:00:1d.3: UHCI Host Controller
> > > uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
> > > uhci_hcd 0000:00:1d.3: irq 7, io base 0x0000bf20
> > > usb usb4: configuration #1 chosen from 1 choice
> > > hub 4-0:1.0: USB hub found
> > > hub 4-0:1.0: 2 ports detected
> > > usb usb4: new device found, idVendor=0000, idProduct=0000
> > > usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
> > > usb usb4: Product: UHCI Host Controller
> > > usb usb4: Manufacturer: Linux 2.6.24-kas-alt1 uhci_hcd
> > > usb usb4: SerialNumber: 0000:00:1d.3
> > > uhci_hcd 0000:00:1d.3: FGR not stopped yet!
> > > 
> > 
> > I've had some strangenesses with USB lately.  Sometimes running `lsusb'
> > makes the USB system notice a newly attached device.
> 
> No. But I have new messages in dmesg:
> 
> uhci_hcd 0000:00:1d.3: FGR not stopped yet!
> uhci_hcd 0000:00:1d.2: FGR not stopped yet!
> uhci_hcd 0000:00:1d.1: FGR not stopped yet!
> uhci_hcd 0000:00:1d.0: FGR not stopped yet!
> 
> 
> > Is that "FGR not stopped yet!" messgae new behaviour?
> 
> It is a new message since 2.6.24-rc3. I have never try -mm tree before.

These messages could indicate a timing problem.  You can see the code
that writes the messages near the end of wakeup_rh() in
drivers/usb/host/uhci-hcd.c.

The message gets written if the controller hardware hasn't turned off a 
particular bit after a 4-us delay.  If the udelay() function wasn't 
working right, it could cause this problem.

Alan Stern

