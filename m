Return-Path: <linux-kernel-owner+w=401wt.eu-S1762256AbYEGPiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256AbYEGPiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbYEGPid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:38:33 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57692 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760714AbYEGPi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:38:29 -0400
Date: Wed, 7 May 2008 16:28:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <JosephChan@via.com.tw>
Cc: <JosephChan@via.com.tw>, <akpm@linux-foundation.org>,
       <geert@linux-m68k.org>, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH 3/9] viafb: VIA Frame Buffer Device
 Driver
Message-ID: <20080507162820.4ecd1b55@core>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67754@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67754@exchtp03.taipei.via.com.tw>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/* Indentify GFX Chip Name */
> +	pdev =
> +	    (struct pci_dev *)pci_get_device(PCI_VIA_VENDOR_ID,
> +					     UNICHROME_CLE266_DID, NULL);
> +	if (pdev != NULL)
> +		chip_info.gfx_chip_name = UNICHROME_CLE266;
> +
> +	pdev =
> +	    (struct pci_dev *)pci_get_device(PCI_VIA_VENDOR_ID,
> +					     UNICHROME_K400_DID, NULL);

pci_get_device takes a reference so you need to do a pci_dev_put() on the
result if you have finished with it. Alternatively you could make use of
pci_dev_present()

> +	case UNICHROME_CLE266:
> +		pdev =
> +		    (struct pci_dev *)pci_get_device(PCI_VIA_VENDOR_ID,
> +						     UNICHROME_CLE266_DID,

Similar issue here.


> +void get_fb_info(unsigned int *fb_base, unsigned int *fb_len)
> +{
> +	struct pci_dev *pdev = NULL;
> +
> +	switch (chip_info.gfx_chip_name) {
> +	case UNICHROME_CLE266:
> +		pdev =
> +		    (struct pci_dev *)pci_get_device(PCI_VIA_VENDOR_ID,
> +						     UNICHROME_CLE266_DID,
> +						     NULL);

And here

So it might be better to for example use an array of types and keep the
array reference in the probe function pci_device_id field (which is how a
lot of stuff like libata drivers avoid doing messy lookups)

