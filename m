Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbXBWLqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbXBWLqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:46:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932178AbXBWLqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:46:51 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52102 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932145AbXBWLqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:46:50 -0500
Date: Fri, 23 Feb 2007 12:50:27 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI driver support for pata
Message-ID: <20070223125027.3f0a7f14@lxorguk.ukuu.org.uk>
In-Reply-To: <45DE3207.6020707@shaw.ca>
References: <fa.IjFXvdcBtWXV65pRZipPd0NVTOA@ifi.uio.no>
	<45DD2E12.6000705@shaw.ca>
	<45DD3F20.7050907@pobox.com>
	<20070222142439.50cff3e9@lxorguk.ukuu.org.uk>
	<45DDCEC4.7050208@garzik.org>
	<20070222182939.56d43a68@lxorguk.ukuu.org.uk>
	<45DE3207.6020707@shaw.ca>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Couldn't be do this generically inside libata core somehow, i.e. try to 
> use ACPI to set the proper mode and fall back to the driver-specific 
> mode setting code if that didn't work? I think if we could do that it 

We want to use the native hebaviour first

> would solve a number of problems (i.e. we could prevent it from doing 
> this on SATA controllers which appear to be IDE based on the PCI ID, 
> like the NVIDIA SATA controllers, since the _GTM and _STM methods seem 
> to have undefined behavior on SATA). This would also eliminate the need 

We check this already. A PATA interface without GTM/STM and friends will
not be picked up by pata_acpi but passed on to ata_generic.

> for mkinitrd, people, etc. to know that they're supposed to be loading 
> this other pata_acpi driver instead, since any PATA driver could take 
> advantage of this feature.

The link order is set up so that we try things in a very specific
deliberate order

- Hardware specific driver (unless it deliberately punts to ACPI)
- ACPI driver using _GTM/_STM etc
- Generic PCI driver ("stay in the mode the BIOS set and pray")
- ISA register compatibility mode (PIO)

This is essentially the strategy used by the old IDE layer since way back
when (minus ACPI support) and has served us pretty well.

Alan
