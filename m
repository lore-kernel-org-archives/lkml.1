Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbZGHOn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbZGHOn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbZGHOnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:43:50 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:34739 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbZGHOnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:43:49 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Null Pointer BUG in uhci_hcd
Date: Wed, 8 Jul 2009 09:43:44 -0500
User-Agent: KMail/1.9.9
Cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0907071513380.8221-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907071513380.8221-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907080943.47248.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue July 7 2009, Alan Stern wrote:
> On Tue, 7 Jul 2009, Michael S. Zick wrote:
> 
> > On Tue July 7 2009, Alan Stern wrote:
> > > On Tue, 7 Jul 2009, Michael S. Zick wrote:
> > > 
> > > > > It looks like there's a serious problem in your UHCI hardware.  
> > > > > According to the log you posted, it's not working at all.
> > > > > 
> > > > 
> > > > I am using the x86-generic drivers - -
> > > 
> > > Not a problem with the drivers, a problem in the hardware.
> > > 
> > 
> > Or hardware that works as the manufacturer intended, but differently
> > than expected.  Same difference as "broken" when compared to "standard".
> 
> No, hardware that doesn't work at all.  As in "all reads return
> 0xffffffff" -- that's just a guess but something like it would account
> for what you saw.
> 

Scratches head, and other parts. . .

Hmm... Already known about this chipset/cpu combination; there is
something about its hardware timing that is a "primary problem" - -

In addition to the suggested diagnostic and suggest fix - will look
into finding if that is a problem here, also.
It may just be a hardware timing issue - the processor is hitting the
hub before the hub has its act together from the last action.

Most likely will take most of the day - unless something jumps out
and says "I'm broke" during the testing.  ;)

Mike
> For more information enable CONFIG_USB_DEBUG and CONFIG_DEBUG_FS, then 
> see what's sitting in the usb/uhci/* files in debugfs.
> 
> > Let me see if I can find it again;
> > 1106:3038 translates to: PCI_DEVICE_ID_VIA_82C586_2
> > 1106:3104 translates to: PCI_DEVICE_ID_VIA_8235_USB_2
> > 
> > The first appears in (this device is the UHCI hub in the CX700 chipset):
> > arch/powerpc/platforms/85xx/mpc85xx_cds.c:              case PCI_DEVICE_ID_VIA_82C586_2:
> > arch/mips/pci/fixup-lm2e.c:DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_2,
> > include/linux/pci_ids.h:#define PCI_DEVICE_ID_VIA_82C586_2      0x3038
> 
> Those are simple interrupt routing fixups.  Not related.
> 
> > The second appears in:
> > include/linux/pci_ids.h:#define PCI_DEVICE_ID_VIA_8235_USB_2    0x3104
> > <Hmm... Dead?  Not used?  Never used?  Source padding?>
> 
> Probably never used.
> 
> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


