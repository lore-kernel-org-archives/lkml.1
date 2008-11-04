Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYKDRgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYKDRgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbYKDRgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:36:37 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:47009 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754004AbYKDRgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:36:36 -0500
Message-ID: <4910881E.3020609@ru.mvista.com>
Date: Tue, 04 Nov 2008 20:36:30 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trm290: add IDE_HFLAG_TRM290 host flag
References: <20081103200244.5098.29817.sendpatchset@localhost.localdomain> <20081103200313.5098.63642.sendpatchset@localhost.localdomain>
In-Reply-To: <20081103200313.5098.63642.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] trm290: add IDE_HFLAG_TRM290 host flag

> * Add IDE_HFLAG_TRM290 host flag and use it in ide_build_dmatable().

    Actually, I've considered removing TRM290 hacks from that function and 
re-implemeting the whole thing in the driver but that wouldn't sever this 
driver's ties with CONFIG_BLK_DEV_IDEDMA_SFF since the latter gets selected by 
CONFIG_BLK_DEV_IDEDMA_PCI...

> * Remove no longer needed ide_trm290 chipset type.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/ide-dma-sff.c
> ===================================================================
> --- a/drivers/ide/ide-dma-sff.c
> +++ b/drivers/ide/ide-dma-sff.c
> @@ -98,10 +98,10 @@ int ide_build_dmatable(ide_drive_t *driv
>  {
>  	ide_hwif_t *hwif = drive->hwif;
>  	__le32 *table = (__le32 *)hwif->dmatable_cpu;
> -	unsigned int is_trm290	= (hwif->chipset == ide_trm290) ? 1 : 0;
>  	unsigned int count = 0;
>  	int i;
>  	struct scatterlist *sg;
> +	u8 is_trm290 = !!(hwif->host_flags & IDE_HFLAG_TRM290);

    I'd keep all the initilaized variables together...

MBR, Sergei
