Return-Path: <linux-kernel-owner+w=401wt.eu-S936012AbXFFU5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936012AbXFFU5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935295AbXFFU5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:57:09 -0400
Received: from 1wt.eu ([62.212.114.60]:2885 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935089AbXFFU5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:57:07 -0400
Date: Wed, 6 Jun 2007 22:57:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: Filippo Carletti <carletti@mobilia.it>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.4.34 - Add some ahci pci ids
Message-ID: <20070606205700.GA10263@1wt.eu>
References: <465FE51E.2060705@mobilia.it> <466005C6.4050303@garzik.org> <20070606054304.GA4241@1wt.eu> <4667160E.5000608@mobilia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4667160E.5000608@mobilia.it>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 10:16:14PM +0200, Filippo Carletti wrote:
> >>> The original patch contained also this lines (that I omitted):
> >>> +       /* JMicron-specific fixup: make sure we're in AHCI mode */
> >>> +       if (pdev->vendor == 0x197b)
> >>> +               pci_write_config_byte(pdev, 0x41, 0xa1);
> >> NAK.  Don't omit obviously needed lines, if you are going to add JMicron 
> >> PCI IDs.
> > 
> > Filippo,
> > 
> > would you please resend your patch including the lines you have omitted ?
> > Jeff is right, those lines are explicitly labelled as a fixup, so either
> > we merge the complete patch, or nothing at all.
> 
> I'm attaching a revised patch that includes JMicron fixup I missed earlier.

Thanks for your quick reply Filippo.

> The patch applies but it's not tested because I lack appropriate hw.

Just for information, have you built it already ?
Jeff, does this one look good to you ?

Thanks,
Willy

> --- drivers/scsi/ahci.c.orig	2006-12-23 20:34:20.000000000 +0000
> +++ drivers/scsi/ahci.c	2007-05-11 22:11:52.000000000 +0000
> @@ -275,6 +275,24 @@
>  	  board_ahci }, /* ESB2 */
>  	{ PCI_VENDOR_ID_INTEL, 0x27c6, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
>  	  board_ahci }, /* ICH7-M DH */
> +	{ PCI_VENDOR_ID_INTEL, 0x2821, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +	  board_ahci }, /* ICH8 */
> +	{ PCI_VENDOR_ID_INTEL, 0x2822, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +	  board_ahci }, /* ICH8 */
> +	{ PCI_VENDOR_ID_INTEL, 0x2824, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +	  board_ahci }, /* ICH8 */
> +	{ PCI_VENDOR_ID_INTEL, 0x2829, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +	  board_ahci }, /* ICH8M */
> +	{ PCI_VENDOR_ID_INTEL, 0x282a, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +	  board_ahci }, /* ICH8M */
> +	{ 0x197b, 0x2360, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +	  board_ahci }, /* JMicron JMB360 */
> +	{ 0x197b, 0x2363, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +	  board_ahci }, /* JMicron JMB363 */
> +	{ PCI_VENDOR_ID_ATI, 0x4380, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +	  board_ahci }, /* ATI SB600 non-raid */
> +	{ PCI_VENDOR_ID_ATI, 0x4381, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +	  board_ahci }, /* ATI SB600 raid */
>  	{ }	/* terminate list */
>  };
> 
> @@ -1085,6 +1085,10 @@
>  	if (have_msi)
>  		hpriv->flags |= AHCI_FLAG_MSI;
>  
> +	/* JMicron-specific fixup: make sure we're in AHCI mode */
> +	if (pdev->vendor == 0x197b)
> +		pci_write_config_byte(pdev, 0x41, 0xa1);
> +
>  	/* initialize adapter */
>  	rc = ahci_host_init(probe_ent);
>  	if (rc)

