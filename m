Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934Ab0ASV3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab0ASV3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895Ab0ASV3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:29:44 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55696 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755894Ab0ASV3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:29:44 -0500
Date: Tue, 19 Jan 2010 21:32:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
Cc: "Dave Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.33 1/3] net: Micrel KSZ8841/2 PCI Ethernet driver
Message-ID: <20100119213214.024b7794@lxorguk.ukuu.org.uk>
In-Reply-To: <14385191E87B904DBD836449AA30269D580A93@MORGANITE.micrel.com>
References: <14385191E87B904DBD836449AA30269D021A4A@MORGANITE.micrel.com>
	<20100116145014.172ad340@lxorguk.ukuu.org.uk>
	<14385191E87B904DBD836449AA30269D580A93@MORGANITE.micrel.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +#define PCI_VENDOR_ID_KS884X		0x16C6
> >> +#define PCI_DEVICE_ID_KS8841		0x8841
> >> +#define PCI_DEVICE_ID_KS8842		0x8842
> > 
> > Those belong in the pci device id header.
> > 
> > 
> 
> I do not quite understand your suggestion.  Do I need to put those IDs
> in one of the kernel headers?

Into include/linux/pci_ids.h

> >> +	hw->pdev = pdev;
> > 
> > 
> > If you make a private copy of pdev in your struct you should refcount
> it and use
> > pci_dev_get/pci_dev_put when you take and release the reference. 

> I do not understand how pci_dev_get/pci_dev_put work.  Does the pdev
> pointer actually change during the lifetime of the PCI driver?

No but it can go away if the device is removed. The pci_dev_get ensures
it won't go away while you have a pointer to it. and the pci_dev_put
gives up your reference.

> I also like the attribute to associate with the network device rather
> than the PCI device, as the KSZ8842 driver can create another virtual
> network device.  I tried to pass the device pointer of the network
> device to device_create_file function and the driver crashed.  I will
> investigate this matter further.

Ok
