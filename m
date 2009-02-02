Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZBBQw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZBBQw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 11:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZBBQwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 11:52:16 -0500
Received: from in.cluded.net ([195.159.98.120]:56353 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbZBBQwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 11:52:15 -0500
Message-ID: <49872324.9070908@cluded.net>
Date: Mon, 02 Feb 2009 17:45:24 +0100
From: "Daniel K." <daniel@cluded.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] scc_pata: remove DECLARE_SCC_DEV() macro
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain> <20090201174923.19144.28927.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201174923.19144.28927.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Index: b/drivers/ide/scc_pata.c
> ===================================================================
> --- a/drivers/ide/scc_pata.c
> +++ b/drivers/ide/scc_pata.c
> @@ -882,21 +882,16 @@ static const struct ide_dma_ops scc_dma_
>  	.dma_sff_read_status	= scc_dma_sff_read_status,
>  };
>  
> -#define DECLARE_SCC_DEV(name_str)			\
> -  {							\
> -      .name		= name_str,			\
> -      .init_iops	= init_iops_scc,		\
> -      .init_dma		= scc_init_dma,			\
> -      .init_hwif	= init_hwif_scc,		\
> -      .tp_ops		= &scc_tp_ops,		\
> -      .port_ops		= &scc_port_ops,		\
> -      .dma_ops		= &scc_dma_ops,			\
> -      .host_flags	= IDE_HFLAG_SINGLE,		\
> -      .pio_mask		= ATA_PIO4,			\
> -  }
> -
>  static const struct ide_port_info scc_chipsets[] __devinitdata = {
> -	/* 0 */ DECLARE_SCC_DEV("sccIDE"),
> +	.name		= "sccIDE",
> +	.init_iops	= init_iops_scc,
> +	.init_dma	= scc_init_dma,
> +	.init_hwif	= init_hwif_scc,
> +	.tp_ops		= &scc_tp_ops,
> +	.port_ops	= &scc_port_ops,
> +	.dma_ops	= &scc_dma_ops,
> +	.host_flags	= IDE_HFLAG_SINGLE,
> +	.pio_mask	= ATA_PIO4,
>  };
>  
>  /**

You're a few braces short here, aren't you?

The braces in the #define, didn't get carried over in the change.


Daniel K.
