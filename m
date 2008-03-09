Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbYCIRmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbYCIRmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYCIRmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:42:33 -0400
Received: from h155.mvista.com ([63.81.120.155]:36353 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752088AbYCIRmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:42:32 -0400
Message-ID: <47D421D4.4060008@ru.mvista.com>
Date: Sun, 09 Mar 2008 20:43:48 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ide: add struct ide_port_ops
References: <200802232116.31811.bzolnier@gmail.com>
In-Reply-To: <200802232116.31811.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Move hooks for port/host specific methods from ide_hwif_t to
>   'struct ide_port_ops'.

> * Add 'const struct ide_port_ops *port_ops' to 'struct ide_port_info'
>   and ide_hwif_t.

> * Update host drivers and core code accordingly.

> While at it:

> * Rename ata66_*() cable detect functions to *_cable_detect() to match
>   the standard naming. (Suggested by Sergei Shtylyov)

> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/pci/scc_pata.c
> ===================================================================
> --- a/drivers/ide/pci/scc_pata.c
> +++ b/drivers/ide/pci/scc_pata.c
> @@ -675,24 +675,27 @@ static void __devinit init_hwif_scc(ide_
>  
>  	hwif->dma_setup = scc_dma_setup;
>  	hwif->ide_dma_end = scc_ide_dma_end;
> -	hwif->set_pio_mode = scc_set_pio_mode;
> -	hwif->set_dma_mode = scc_set_dma_mode;
>  	hwif->ide_dma_test_irq = scc_dma_test_irq;
> -	hwif->udma_filter = scc_udma_filter;
>  
>  	if (in_be32((void __iomem *)(hwif->config_data + 0xff0)) & CCKCTRL_ATACLKOEN)
>  		hwif->ultra_mask = ATA_UDMA6; /* 133MHz */
>  	else
>  		hwif->ultra_mask = ATA_UDMA5; /* 100MHz */
> -
> -	hwif->cable_detect = scc_cable_detect;
>  }
>  
> +static const struct ide_port_ops scc_port_ops = {
> +	.set_pio_mode		= scc_set_pio_mode,
> +	.set_dma_mode		= scc_set_dma_mode,
> +	.udma_filter		= scc_udma_filter,
> +	.cable_detect		= scc_cable_detect,
> +};
> +
>  #define DECLARE_SCC_DEV(name_str)			\
>    {							\
>        .name		= name_str,			\
>        .init_iops	= init_iops_scc,		\
>        .init_hwif	= init_hwif_scc,		\
> +      .port_ops		= &scc_port_ops,		\
>        .host_flags	= IDE_HFLAG_SINGLE,		\
>        .pio_mask		= ATA_PIO4,			\
>    }

    Hm, this file makes use of some strange indentation...

MBR, Sergei
