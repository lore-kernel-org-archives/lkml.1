Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbXEIMhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbXEIMhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXEIMhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:37:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43505 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXEIMhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:37:01 -0400
Message-ID: <4641C066.8080100@garzik.org>
Date: Wed, 09 May 2007 08:36:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Henry Su <henry.su@amd.com>
CC: alan@lxorguk.ukuu.org.uk, greg@kroah.com, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       xiaosuzi520@hotmail.com
Subject: Re: [patch] Add the device IDs for AMD/ATI SB700
References: <FFECF24D2A7F6D418B9511AF6F3586020197F6A6@shacnexch2.atitech.com>
In-Reply-To: <FFECF24D2A7F6D418B9511AF6F3586020197F6A6@shacnexch2.atitech.com>
Content-Type: text/plain; charset=UTF-7
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henry Su wrote:
> From: henry.su@amd.com
> Adding the device ID for AMD/ATI SB700.
> Signed-off-by:henry su <henry.su@amd.com>

Time to train new people...

You need to split up your patches:
* send I2C and PCI quirk patches to GregKH
* send drivers/ide/* stuff to Bart
* send drivers/ata/* patches to me


> --- linux-2.6.21.1.orig/drivers/ide/pci/atiixp.c	2007-05-10 06:30:17.000000000 +0800
> +++ linux-2.6.21.1/drivers/ide/pci/atiixp.c	2007-05-10 07:18:39.000000000 +0800
> @@ -353,6 +353,7 @@ static struct pci_device_id atiixp_pci_t
>  	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP300_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
>  	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
>  	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_IDE, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
> +	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_IDE, PCI_ANY_ID, 
> +PCI_ANY_ID, 0, 0, 1},
>  	{ 0, },
>  };
>  MODULE_DEVICE_TABLE(pci, atiixp_pci_tbl);

fix word wrap


> --- linux-2.6.21.1.orig/drivers/ata/ahci.c	2007-05-10 06:30:14.000000000 +0800
> +++ linux-2.6.21.1/drivers/ata/ahci.c	2007-05-10 07:41:41.000000000 +0800
> @@ -415,6 +415,7 @@ static const struct pci_device_id ahci_p
>  	/* ATI */
>  	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 non-raid */
>  	{ PCI_VDEVICE(ATI, 0x4381), board_ahci }, /* ATI SB600 raid */
> +	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb600 }, /* ATI SB700 */
>  
>  	/* VIA */
>  	{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */
> 
> --- linux-2.6.21.1.orig/drivers/pci/quirks.c	2007-05-10 06:30:17.000000000 +0800
> +++ linux-2.6.21.1/drivers/pci/quirks.c	2007-05-10 07:49:33.000000000 +0800
> @@ -875,6 +875,7 @@ static void __devinit quirk_sb600_sata(s
>  	}
>  }
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_sb600_sata);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 
> +PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_sb600_sata);

fix word wrap

