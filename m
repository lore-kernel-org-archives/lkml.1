Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbZGGR5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbZGGR5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZGGR4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:56:50 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:35661 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbZGGR4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:56:49 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Null Pointer BUG in uhci_hcd
Date: Tue, 7 Jul 2009 12:56:32 -0500
User-Agent: KMail/1.9.9
Cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0907071325580.8221-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907071325580.8221-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071256.34760.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue July 7 2009, Alan Stern wrote:
> On Tue, 7 Jul 2009, Michael S. Zick wrote:
> 
> > > It looks like there's a serious problem in your UHCI hardware.  
> > > According to the log you posted, it's not working at all.
> > > 
> > 
> > I am using the x86-generic drivers - -
> 
> Not a problem with the drivers, a problem in the hardware.
> 

Or hardware that works as the manufacturer intended, but differently
than expected.  Same difference as "broken" when compared to "standard".

>
> > There are VIA-device specific drivers in other arch trees,
> > (arm?, powerpc?) - I haven't compared them to the x86-generic
> > to see if they had to do something specific for 1106:3038, 1106:3104
> > 
> > Any idea if those drivers are "long dead" or still in use?
> 
> I don't know what drivers you're talking about.
> 

Let me see if I can find it again;
1106:3038 translates to: PCI_DEVICE_ID_VIA_82C586_2
1106:3104 translates to: PCI_DEVICE_ID_VIA_8235_USB_2

The first appears in (this device is the UHCI hub in the CX700 chipset):
arch/powerpc/platforms/85xx/mpc85xx_cds.c:              case PCI_DEVICE_ID_VIA_82C586_2:
arch/mips/pci/fixup-lm2e.c:DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_2,
include/linux/pci_ids.h:#define PCI_DEVICE_ID_VIA_82C586_2      0x3038

The second appears in:
include/linux/pci_ids.h:#define PCI_DEVICE_ID_VIA_8235_USB_2    0x3104
<Hmm... Dead?  Not used?  Never used?  Source padding?>

Not including any sources that may be hardcoded rather than use the defines.

Mike
> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


