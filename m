Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbZCIOnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbZCIOnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 10:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZCIOmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 10:42:51 -0400
Received: from h155.mvista.com ([63.81.120.155]:23517 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751406AbZCIOmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 10:42:51 -0400
Message-ID: <49B52AE3.1030209@ru.mvista.com>
Date: Mon, 09 Mar 2009 17:42:43 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] ide: move ide_map_sg() call out from ->dma_setup
 method
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain> <20090220171236.25429.25264.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171236.25429.25264.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Move ide_map_sg() call from ->dma_setup implementations
> and ide_destroy_dmatable() one from *_build_dmatable() to
> ide_dma_prepare().
>
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   
[...]
> Index: b/drivers/ide/au1xxx-ide.c
> ===================================================================
> --- a/drivers/ide/au1xxx-ide.c
> +++ b/drivers/ide/au1xxx-ide.c
> @@ -272,9 +272,7 @@ static int auide_build_dmatable(ide_driv
>  	if (count)
>  		return 1;
>  
> - use_pio_instead:
> -	ide_destroy_dmatable(drive);
> -
> +use_pio_instead:
>   

   Could you please get rid of goto and label too, while at it?

> Index: b/drivers/ide/pmac.c
> ===================================================================
> --- a/drivers/ide/pmac.c
> +++ b/drivers/ide/pmac.c
> @@ -1493,8 +1493,6 @@ static int pmac_ide_build_dmatable(ide_d
>  	printk(KERN_DEBUG "%s: empty DMA table?\n", drive->name);
>  
>  use_pio_instead:
> -	ide_destroy_dmatable(drive);
> -
>  	return 0; /* revert to PIO for this request */

   Ditto...

> Index: b/drivers/ide/sgiioc4.c
> ===================================================================
> --- a/drivers/ide/sgiioc4.c
> +++ b/drivers/ide/sgiioc4.c
> @@ -478,8 +478,6 @@ static int sgiioc4_build_dmatable(ide_dr
>  	}
>  
>  use_pio_instead:
> -	ide_destroy_dmatable(drive);
> -
>  	return 0;		/* revert to PIO for this request */
>   

   Ditto...

MBR, Sergei


