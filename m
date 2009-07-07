Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZGGTVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZGGTVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 15:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbZGGTVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 15:21:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56778 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754618AbZGGTVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 15:21:08 -0400
Date: Tue, 7 Jul 2009 15:21:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Michael S. Zick" <lkml@morethan.org>
cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Null Pointer BUG in uhci_hcd
In-Reply-To: <200907071256.34760.lkml@morethan.org>
Message-ID: <Pine.LNX.4.44L0.0907071513380.8221-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Michael S. Zick wrote:

> On Tue July 7 2009, Alan Stern wrote:
> > On Tue, 7 Jul 2009, Michael S. Zick wrote:
> > 
> > > > It looks like there's a serious problem in your UHCI hardware.  
> > > > According to the log you posted, it's not working at all.
> > > > 
> > > 
> > > I am using the x86-generic drivers - -
> > 
> > Not a problem with the drivers, a problem in the hardware.
> > 
> 
> Or hardware that works as the manufacturer intended, but differently
> than expected.  Same difference as "broken" when compared to "standard".

No, hardware that doesn't work at all.  As in "all reads return
0xffffffff" -- that's just a guess but something like it would account
for what you saw.

For more information enable CONFIG_USB_DEBUG and CONFIG_DEBUG_FS, then 
see what's sitting in the usb/uhci/* files in debugfs.

> Let me see if I can find it again;
> 1106:3038 translates to: PCI_DEVICE_ID_VIA_82C586_2
> 1106:3104 translates to: PCI_DEVICE_ID_VIA_8235_USB_2
> 
> The first appears in (this device is the UHCI hub in the CX700 chipset):
> arch/powerpc/platforms/85xx/mpc85xx_cds.c:              case PCI_DEVICE_ID_VIA_82C586_2:
> arch/mips/pci/fixup-lm2e.c:DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_2,
> include/linux/pci_ids.h:#define PCI_DEVICE_ID_VIA_82C586_2      0x3038

Those are simple interrupt routing fixups.  Not related.

> The second appears in:
> include/linux/pci_ids.h:#define PCI_DEVICE_ID_VIA_8235_USB_2    0x3104
> <Hmm... Dead?  Not used?  Never used?  Source padding?>

Probably never used.

Alan Stern

