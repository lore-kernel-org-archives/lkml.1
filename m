Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYGOPKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYGOPKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYGOPKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:10:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:34783 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbYGOPKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:10:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=pLYeEzKIU8pPocRzhvWpiCUGy/XjluS3yLxSPkuPZpUDSmtx0c2mPyQI+HEu4V5Rsi
         M9ZPEI5KKRUgpfELN9pqsfwrCYiklOkvlQW1jvIjBPzD6kj9HthC5i3XdZ8EUlU43hEb
         HqaMvWk8vD8pOf12fa/GQsEww3PVdI/eHCRF8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>
Subject: Re: [PATCH] ide: it821x in pass-through mode segfaults in 2.6.26-stable
Date: Wed, 16 Jul 2008 17:02:14 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@vger.kernel.org
References: <20080714211133.514936a4@laphroaig>
In-Reply-To: <20080714211133.514936a4@laphroaig>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807161702.15131.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 14 July 2008, Dimitri Gorokhovik wrote:
> (Let me know if you need the kernel config for this.) 
> ---
> The driver of ITE8212 in pass-through mode (it8212.noraid=1 on cmndline)
> attempts to use the field `.dma_host_set' of the struct ide_dma_ops in
> `ide_config_drive_speed' which is set to NULL by default.
> 
> So give a value to all fields of the struct ide_dma_ops.

Thank your for fixing it.

Please resend with your Signed-off-by: so I could apply it.

> ---
> diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
> index 6ab0411..cbf6472 100644
> --- a/drivers/ide/pci/it821x.c
> +++ b/drivers/ide/pci/it821x.c
> @@ -512,8 +512,14 @@ static void __devinit it821x_quirkproc(ide_drive_t *drive)
>  }
>  
>  static struct ide_dma_ops it821x_pass_through_dma_ops = {
> +	.dma_host_set		= ide_dma_host_set,
> +	.dma_setup		= ide_dma_setup,
> +	.dma_exec_cmd		= ide_dma_exec_cmd,
>  	.dma_start		= it821x_dma_start,
>  	.dma_end		= it821x_dma_end,
> +	.dma_test_irq		= ide_dma_test_irq,
> +	.dma_timeout		= ide_dma_timeout,
> +	.dma_lost_irq		= ide_dma_lost_irq,
>  };
>  
>  /**
