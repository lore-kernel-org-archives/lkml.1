Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYFTWDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYFTWDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 18:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbYFTWD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 18:03:27 -0400
Received: from h155.mvista.com ([63.81.120.155]:58555 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753145AbYFTWD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 18:03:26 -0400
Message-ID: <485C2924.7040905@ru.mvista.com>
Date: Sat, 21 Jun 2008 02:03:16 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/18] ide: remove ide_setup_dma()
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <20080620213350.13202.73557.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213350.13202.73557.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:
> Export sff_dma_ops and then remove ide_setup_dma().
>
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>
>   
[...]
> Index: b/drivers/ide/arm/palm_bk3710.c
> ===================================================================
> --- a/drivers/ide/arm/palm_bk3710.c
> +++ b/drivers/ide/arm/palm_bk3710.c
> @@ -318,15 +318,14 @@ static u8 __devinit palm_bk3710_cable_de
>  static int __devinit palm_bk3710_init_dma(ide_hwif_t *hwif,
>  					  const struct ide_port_info *d)
>  {
> -	unsigned long base =
> -		hwif->io_ports.data_addr - IDE_PALM_ATA_PRI_REG_OFFSET;
> -
>  	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
>  
>  	if (ide_allocate_dma_engine(hwif))
>  		return -1;
>  
> -	ide_setup_dma(hwif, base);
> +	hwif->dma_base = hwif->io_ports.data_addr - IDE_PALM_ATA_PRI_REG_OFFSET;
>   

   That's er... too complex. Actually, 'base' has the value for 
'dma_base' at that moment...

WBR, Sergei


