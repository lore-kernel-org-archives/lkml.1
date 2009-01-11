Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZAKU6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZAKU6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZAKU6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:58:23 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:13097 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751468AbZAKU6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:58:22 -0500
Message-ID: <496A5D64.6030007@ru.mvista.com>
Date: Sun, 11 Jan 2009 23:58:12 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] ide: move ->rqsize init from init_irq() to ide_init_port()
References: <20090106183520.21193.63704.sendpatchset@localhost.localdomain> <20090106183602.21193.67001.sendpatchset@localhost.localdomain>
In-Reply-To: <20090106183602.21193.67001.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

> Index: b/drivers/ide/ide-probe.c
> ===================================================================
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c
>   
[...]
> @@ -1242,6 +1234,13 @@ static void ide_init_port(ide_hwif_t *hw
>  
>  	if (d->max_sectors)
>  		hwif->rqsize = d->max_sectors;
> +	else {
> +		if ((hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
> +		    (hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA))
>   

   Er, why not:

		if (hwif->host_flags &
		    (IDE_HFLAG_NO_LBA48 | IDE_HFLAG_NO_LBA48_DMA))


MBR, Sergei


