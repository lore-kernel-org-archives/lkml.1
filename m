Return-Path: <linux-kernel-owner+w=401wt.eu-S2992798AbXBIUEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992798AbXBIUEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 15:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992800AbXBIUEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 15:04:51 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41695 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992798AbXBIUEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 15:04:50 -0500
Date: Fri, 9 Feb 2007 20:18:07 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, jeff@garzik.org
Subject: Re: [PATCH] pata_acpi: take two
Message-ID: <20070209201807.57e727a4@localhost.localdomain>
In-Reply-To: <45CAB125.7000907@shaw.ca>
References: <fa.E0XxdpTYuPtTLgPLQYHs2V10jM4@ifi.uio.no>
	<45CAB125.7000907@shaw.ca>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#if defined(CONFIG_ATA_ACPI)
> > +	/* Prefer the ACPI driver for Nvidia hardware */
> > +	if (pdev->vendor == PCI_VENDOR_ID_NVIDIA && ata_pata_acpi_present(pdev))
> > +		return -ENODEV;
> > +#endif		
> >  	/* Check for AMD7411 */
> >  	if (type == 3)
> >  		/* FIFO is broken */
> 
> Problem with this approach is it may break distro/initrd setups since 
> the pata_amd driver appears to be the one that "should" work based on 
> the PCI ID, so the initrd would end up containing only this driver, 

Diddums

> which will fail out with -ENODEV and cause a boot failure. If the root 
> filesystem was on a disk driven by this controller, the mkinitrd stuff 
> would have to "know" that it should also try loading pata_acpi.

Indeed they will.

> Unless there are some Nvidia boxes out there which don't provide 
> _GTM/_STM ACPI methods (which seems a bit unlikely given Allen Martin's 
> comments) then we could potentially move the Nvidia PATA PCI IDs into 
> the pata_acpi driver, at least if ACPI is enabled in the kernel build..

No we can't. It is a dynamic evaluation. The user may be booting with
acpi=off to work around BIOS problems, so the distribution initrd tools
will just have to learn this out as they do the sata_nv funnies. (Nvidia
is already a special case)
