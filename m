Return-Path: <linux-kernel-owner+w=401wt.eu-S965678AbXBHFM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965678AbXBHFM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965684AbXBHFM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:12:28 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:53900 "EHLO
	pd5mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965678AbXBHFM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:12:27 -0500
Date: Wed, 07 Feb 2007 23:12:05 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] pata_acpi: take two
In-reply-to: <fa.E0XxdpTYuPtTLgPLQYHs2V10jM4@ifi.uio.no>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, jeff@garzik.org
Message-id: <45CAB125.7000907@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.E0XxdpTYuPtTLgPLQYHs2V10jM4@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> --- linux.vanilla-2.6.20-rc6-mm3/drivers/ata/pata_amd.c	2007-01-31 14:20:10.000000000 +0000
> +++ linux-2.6.20-rc6-mm3/drivers/ata/pata_amd.c	2007-02-06 17:04:19.000000000 +0000
> @@ -642,6 +642,11 @@
>  	if (type == 1 && rev > 0x7)
>  		type = 2;
>  
> +#if defined(CONFIG_ATA_ACPI)
> +	/* Prefer the ACPI driver for Nvidia hardware */
> +	if (pdev->vendor == PCI_VENDOR_ID_NVIDIA && ata_pata_acpi_present(pdev))
> +		return -ENODEV;
> +#endif		
>  	/* Check for AMD7411 */
>  	if (type == 3)
>  		/* FIFO is broken */

Problem with this approach is it may break distro/initrd setups since 
the pata_amd driver appears to be the one that "should" work based on 
the PCI ID, so the initrd would end up containing only this driver, 
which will fail out with -ENODEV and cause a boot failure. If the root 
filesystem was on a disk driven by this controller, the mkinitrd stuff 
would have to "know" that it should also try loading pata_acpi.

Unless there are some Nvidia boxes out there which don't provide 
_GTM/_STM ACPI methods (which seems a bit unlikely given Allen Martin's 
comments) then we could potentially move the Nvidia PATA PCI IDs into 
the pata_acpi driver, at least if ACPI is enabled in the kernel build..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

