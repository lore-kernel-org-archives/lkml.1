Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYKTUwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYKTUwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbYKTUvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:51:37 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22310 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755490AbYKTUvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:51:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hbwi6Q6y1zAzS6by9n5iJfjnnzGlj84QQeE4P8g4USEc9urtpsxgG8bazZjqMVFH2Rc1rMb7V6um0ThYYLRmd0ICCcx59Etv+8XLXO1Dm4QMpgN84APi8+BA//+NXKCAuqgRI0R2Did6flYvWvlwO5cOaUgS+aYLy8eFhlqo05s=  ;
X-YMail-OSG: kIb.MbgVM1kOacN48sWb8likhplZlQffjakp4JvG6zyvUgO5WCQ1wrSOwHS737RAcqeQBOHwl4nT6QxoTMN8nSUMXrgVqJ7wqzmRh.bY7HW.WopocMr.VWlXsk9xhO.Fzvu0k8j2wgKjIrBjJOBRXd2k1jDz21oylXR5Mj1nqvV1NkWr3YiNjK5se2UW
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 04/16] Blackfin SPI Driver: use len_in_bytes when we care about the number of bytes transferred
Date: Thu, 20 Nov 2008 12:25:28 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <1226994760-4301-5-git-send-email-cooloney@kernel.org>
In-Reply-To: <1226994760-4301-5-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201225.28758.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Use len_in_bytes when we care about the number of bytes transferred
> rather than the number of spi transactions. (this value will be the
> same for 8bit transfers, but not any other sizes)
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
>  drivers/spi/spi_bfin5xx.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index 6c5671e..cc415e8 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -803,7 +803,7 @@ static void pump_transfers(unsigned long data)
>  			if (bfin_addr_dcachable((unsigned long) drv_data->rx))
>  				invalidate_dcache_range((unsigned long) drv_data->rx,
>  							(unsigned long) (drv_data->rx +
> -							drv_data->len));
> +							drv_data->len_in_bytes));
>  
>  			/* clear tx reg soformer data is not shifted out */
>  			write_TDBR(drv_data, 0xFFFF);
> @@ -829,7 +829,7 @@ static void pump_transfers(unsigned long data)
>  			if (bfin_addr_dcachable((unsigned long) drv_data->tx))
>  				flush_dcache_range((unsigned long) drv_data->tx,
>  						(unsigned long) (drv_data->tx +
> -						drv_data->len));
> +						drv_data->len_in_bytes));
>  
>  			/* start dma */
>  			dma_enable_irq(drv_data->dma_channel);
> @@ -892,7 +892,7 @@ static void pump_transfers(unsigned long data)
>  			message->state = ERROR_STATE;
>  		} else {
>  			/* Update total byte transfered */
> -			message->actual_length += drv_data->len;
> +			message->actual_length += drv_data->len_in_bytes;
>  
>  			/* Move to next transfer of this msg */
>  			message->state = next_transfer(drv_data);
> -- 
> 1.5.6.3
> 
> 


