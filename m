Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZLARVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZLARVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZLARVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:21:54 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:16380 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752542AbZLARVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:21:53 -0500
Message-ID: <4B1550F5.5070909@ru.mvista.com>
Date: Tue, 01 Dec 2009 20:23:01 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/86] pata_artop: remove dead 34MHz PCI clock support
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125170307.5446.12439.sendpatchset@localhost>
In-Reply-To: <20091125170307.5446.12439.sendpatchset@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> It has been dead for the last three years (== since the initial driver
> merge) and probability that it will ever get fixed is quite low.

> Since there is no reason to keep this dead code around any longer just
> remove it (it can still be retrieved from the git history if necessary).

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/pata_artop.c |   29 ++++++++---------------------
>  1 file changed, 8 insertions(+), 21 deletions(-)

> Index: b/drivers/ata/pata_artop.c
> ===================================================================
> --- a/drivers/ata/pata_artop.c
> +++ b/drivers/ata/pata_artop.c
> @@ -30,15 +30,6 @@
>  #define DRV_NAME	"pata_artop"
>  #define DRV_VERSION	"0.4.5"
>  
> -/*
> - *	The ARTOP has 33 Mhz and "over clocked" timing tables. Until we
> - *	get PCI bus speed functionality we leave this as 0. Its a variable
> - *	for when we get the functionality and also for folks wanting to
> - *	test stuff.
> - */
> -
> -static int clock = 0;
> -
>  /**
>   *	atp8xx_prereset	-	probe begin
>   *	@link: link
[...]
> @@ -223,7 +210,7 @@ static void atp850_set_dmamode(struct at
>  
>  	/* Add ultra DMA bits if in UDMA mode */
>  	if (adev->dma_mode >= XFER_UDMA_0) {
> -		u8 mode = (adev->dma_mode - XFER_UDMA_0) + 1 - clock;
> +		u8 mode = (adev->dma_mode - XFER_UDMA_0) + 1;
>  		if (mode == 0)
>  			mode = 1;

    Note that 'mode' can't be 0 anymore, so this check can be removed.

>  		ultra |= (mode << (2 * dn));
> @@ -261,7 +248,7 @@ static void atp86x_set_dmamode(struct at
>  	pci_read_config_byte(pdev, 0x44 + ap->port_no, &ultra);
>  	ultra &= ~(7 << (4  * adev->devno));	/* One nibble per drive */
>  	if (adev->dma_mode >= XFER_UDMA_0) {
> -		u8 mode = adev->dma_mode - XFER_UDMA_0 + 1 - clock;
> +		u8 mode = adev->dma_mode - XFER_UDMA_0 + 1;
>  		if (mode == 0)
>  			mode = 1;

    Same here...

MBR, Sergei
