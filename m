Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbZCIOBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbZCIOBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 10:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZCIOBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 10:01:00 -0400
Received: from h155.mvista.com ([63.81.120.155]:22843 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751213AbZCIOA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 10:00:59 -0400
Message-ID: <49B52113.3000804@ru.mvista.com>
Date: Mon, 09 Mar 2009 17:00:51 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] ide: destroy DMA mappings after ending DMA
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain> <20090220171201.25429.29473.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171201.25429.29473.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: destroy DMA mappings after ending DMA
>
> Move ide_destroy_dmatable() call out from ->dma_end method to
> {ide_pc,cdrom_newpc,ide_dma}_intr(), ide_dma_timeout_retry()
> and sgiioc4_resetproc().
>
> This causes minor/safe behavior changes w.r.t.:
> * cmd64x.c::cmd64{8,x}_dma_end()
> * cs5536.c::cs5536_dma_end()
> * icside.c::icside_dma_end()
> * it821x.c::it821x_dma_end()
> * scc_pata.c::__scc_dma_end()
> * sl82c105.c::sl82c105_dma_end()
> * tx4939ide.c::tx4939ide_dma_end()
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Index: b/drivers/ide/sgiioc4.c
> ===================================================================
> --- a/drivers/ide/sgiioc4.c
> +++ b/drivers/ide/sgiioc4.c
> @@ -259,7 +259,6 @@ static int sgiioc4_dma_end(ide_drive_t *
>  	}
>  
>  	drive->waiting_for_dma = 0;
> -	ide_destroy_dmatable(drive);
>  
>  	return dma_stat;
>  }
> @@ -284,6 +283,7 @@ static void
>  sgiioc4_resetproc(ide_drive_t * drive)
>  {
>  	sgiioc4_dma_end(drive);
> +	ide_destroy_dmatable(drive);
>  	sgiioc4_clearirq(drive);
>  }

   I somewhat doubt that resetproc() can be called with DMA still active...

MBR, Sergei


