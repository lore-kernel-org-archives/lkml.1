Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYHSWe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYHSWe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYHSWen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:34:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752721AbYHSWem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:34:42 -0400
Date: Tue, 19 Aug 2008 15:34:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH 2/2] ide: add proper PCI PM support
Message-Id: <20080819153437.68272594.akpm@linux-foundation.org>
In-Reply-To: <200808021917.04847.bzolnier@gmail.com>
References: <200808021917.04847.bzolnier@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2008 19:17:04 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> -static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev)
> +static unsigned int init_chipset_aec62xx(struct pci_dev *dev)
>  {
>  	/* These are necessary to get AEC6280 Macintosh cards to work */
>  	if ((dev->device == PCI_DEVICE_ID_ARTOP_ATP865) ||
> @@ -307,6 +307,10 @@ static struct pci_driver driver = {
>  	.id_table	= aec62xx_pci_tbl,
>  	.probe		= aec62xx_init_one,
>  	.remove		= aec62xx_remove,
> +#ifdef CONFIG_PM
> +	.suspend	= ide_pci_suspend,
> +	.resume		= ide_pci_resume,
> +#endif
>  };
>  
>  static int __init aec62xx_ide_init(void)
> Index: b/drivers/ide/pci/alim15x3.c
> ===================================================================
> --- a/drivers/ide/pci/alim15x3.c
> +++ b/drivers/ide/pci/alim15x3.c
> @@ -213,7 +213,7 @@ static int ali15x3_dma_setup(ide_drive_t
>   *	appropriate also sets up the 1533 southbridge.
>   */
>  
> -static unsigned int __devinit init_chipset_ali15x3(struct pci_dev *dev)
> +static unsigned int init_chipset_ali15x3(struct pci_dev *dev)
>  {
>  	unsigned long flags;
>  	u8 tmpbyte;
> @@ -581,6 +581,10 @@ static struct pci_driver driver = {
>  	.id_table	= alim15x3_pci_tbl,
>  	.probe		= alim15x3_init_one,
>  	.remove		= ide_pci_remove,
> +#ifdef CONFIG_PM
> +	.suspend	= ide_pci_suspend,
> +	.resume		= ide_pci_resume,
> +#endif

Please do

#ifndef CONFIG_PM
#define ide_pci_suspend NULL
#define ide_pci_resume NULL
#endif

in a header file and then remove all these ifdefs.

It's a pretty common convention and will clean things up rather a lot.
