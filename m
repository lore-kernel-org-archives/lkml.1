Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbXGOE7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbXGOE7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 00:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbXGOE7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 00:59:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48422 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbXGOE7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 00:59:35 -0400
Message-ID: <4699A9AD.2050206@garzik.org>
Date: Sun, 15 Jul 2007 00:59:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: surya.prabhakar@wipro.com
CC: caglar@pardus.org.tr, linux-kernel@vger.kernel.org, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/12] drivers/isdn/hisax/avm_pci.c: replace pci_find_device
 with pci_get_device
References: <200707140144.20855.caglar@pardus.org.tr> <46996D12.40501@garzik.org> <A94AD757879CE142B7CEBC3E6FF5D3EC015DAC49@BLR-EC-MBX02.wipro.com>
In-Reply-To: <A94AD757879CE142B7CEBC3E6FF5D3EC015DAC49@BLR-EC-MBX02.wipro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.7 (---)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-3.7 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

surya.prabhakar@wipro.com wrote:
> 
> 
> S.Çaglar Onur wrote:
>  > @@ -858,5 +858,10 @@ ready:
>  >       cs->irq_func = &avm_pcipnp_interrupt;
>  >       cs->writeisac(cs, ISAC_MASK, 0xFF);
>  >       ISACVersion(cs, (cs->subtyp == AVM_FRITZ_PCI) ? "AVM PCI:" : 
> "AVM PnP:");
>  > +     pci_dev_put(dev_avm);
>  >       return (1);
>  > +
>  > +dev_avm_cleanup:
>  > +     pci_dev_put(dev_avm);
>  > +     return (0);
>  >  }
> 
> 
>  >NAK -- every single one of these patches is wrong.  All you did was make
>  >the warning go away, while INTRODUCING new lifetime problems.
> 
>  >The ISDN PCI driver obviously continues execution after the setup
>  >function ends, yet you pci_dev_put() the device at the end of setup.  As
>  >a result, no reference is held even though we continue using the device.
> 
> This series of patches were initially released by me and were also 
> accepted by kkeil.
> It was ack'ed by keil and is now in -mm tree list of andrew morton.
> http://marc.info/?l=linux-kernel&m=118436681515269&w=2 
> <http://marc.info/?l=linux-kernel&m=118436681515269&w=2>
> 
> There are many other drivers with similar implementation. Please have a 
> look at
> linux2.6/drivers/char/sonypi.c , ide/pci/cs5530.c etc..
> 
> Moreover my earlier patch for sound/oss/trident.c was ack'ed by Alan cox 
> and is now in the
> current kernel with similar implementation.

Simple question:  where is a reference -held-, when the PCI device is in 
use?

If you cannot show this, your patch is provably wrong.  And I did not 
see a reference kept in any of your patches.

If you can show me where a reference is stored, I rescind my NAK. 
Otherwise, the patches are demonstrably, provably incorrect.

ACKs cannot get around the -facts-.

	Jeff



