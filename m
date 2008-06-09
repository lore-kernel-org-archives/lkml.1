Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbYFIOrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbYFIOrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYFIOqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:46:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40033 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755476AbYFIOqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:46:46 -0400
Date: Mon, 9 Jun 2008 10:46:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Chris Clayton <chris2553@googlemail.com>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       USB list <linux-usb@vger.kernel.org>,
       <linux1394-devel@lists.sourceforge.net>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
In-Reply-To: <200806080619.17531.chris2553@googlemail.com>
Message-ID: <Pine.LNX.4.44L0.0806091040440.2943-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008, Chris Clayton wrote:

> > The odd thing is that it occurs in the middle of USB initialisation from
> >
> 
> Because of this oddity, I've also built 2.6.26-rc5-git2 with verbose USB 
> debugging on. A boot log from that kernel is attached. You will see lots of 
> ETIME errors from usb. A log from a similarly verbose 2.6.25.5 kernel does not 
> show these errors. usb-devel added to cc list.

In fact the log shows that the 30-second delay occurs in the middle of
ohci1394 (Firewire) initialization, not USB initialization:

Jun  8 05:26:35 upstairs kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[fbfff000-fbfff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8] 
Jun  8 05:26:35 upstairs kernel: ohci_hcd 0000:02:0a.0: urb f71cb680 path 2 ep1in 5e160000 cc 5 --> status -62 
Jun  8 05:26:35 upstairs kernel: hub 1-2:1.0: transfer --> -62 
Jun  8 05:27:08 upstairs kernel: driver: '0000:02:0b.0': driver_bound: bound to device 'ohci1394' 
Jun  8 05:27:08 upstairs kernel: bus: 'pci': really_probe: bound device 0000:02:0b.0 to driver ohci1394 

Those -62 errors from ohci_hcd are red herrings.  To test this, try 
booting with "nousb".

Alan Stern

