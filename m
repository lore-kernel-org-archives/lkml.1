Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbYKTUyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbYKTUyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbYKTUvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:51:43 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:22362 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756773AbYKTUvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:51:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GNg0ZrP/7QzuBnHIwIeflz4PiNhPeUHw3VysQhS1+6d0W7ZT1SUB1guDERviFZ8RmeV80WHSRf1YembI/Z1CRjvfoxcOjW2LhNlpNLDbzWB7mHFmp1yhGuFbpA3oRxZ03ygXHkUcLjZ6+mclHjGnmSI+e31Ww/s9KsmEtJQcuTA=  ;
X-YMail-OSG: .0AmxOwVM1kIwdjDVqSElTV8nmfZJtfYhpkoHIqtxcAmXbu7_7GPluuKUqiDfH4qsrvhPvBMF.Xo4u.MG8Nh9zLliqXuZ6ueRFw03WlvcPTVZ41cEqxzlheG2fYy8KY97kieJQUoxskpSBnKR8NBweJ7EdVRlGVP8Ga3oUoue9rqneF4iLTfbNQXpfYs
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 08/16] Blackfin SPI Driver: add a few more debug messages in useful places
Date: Thu, 20 Nov 2008 12:35:29 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <1226994760-4301-9-git-send-email-cooloney@kernel.org>
In-Reply-To: <1226994760-4301-9-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201235.29955.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Grr.  I'm tired of acking with a "please provide a real
patch comment".  Consider all the other patches in this
series that don't have patch comments as getting NAKs,
for that reason.


> ---
>  drivers/spi/spi_bfin5xx.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index a7c8976..e293d19 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -559,9 +559,13 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
>  	struct driver_data *drv_data = dev_id;
>  	struct chip_data *chip = drv_data->cur_chip;
>  	struct spi_message *msg = drv_data->cur_msg;
> +	unsigned short dmastat = get_dma_curr_irqstat(drv_data->dma_channel);
>  	u16 spistat = read_STAT(drv_data);
>  
> -	dev_dbg(&drv_data->pdev->dev, "in dma_irq_handler\n");
> +	dev_dbg(&drv_data->pdev->dev,
> +		"in dma_irq_handler dmastat:0x%x spistat:0x%x\n",
> +		dmastat, spistat);
> +
>  	clear_dma_irqstat(drv_data->dma_channel);
>  
>  	/* Wait for DMA to complete */
> @@ -631,6 +635,7 @@ static void pump_transfers(unsigned long data)
>  
>  	 /* Handle for abort */
>  	if (message->state == ERROR_STATE) {
> +		dev_dbg(&drv_data->pdev->dev, "transfer: we've hit an error\n");
>  		message->status = -EIO;
>  		giveback(drv_data);
>  		return;
> @@ -638,6 +643,7 @@ static void pump_transfers(unsigned long data)
>  
>  	/* Handle end of message */
>  	if (message->state == DONE_STATE) {
> +		dev_dbg(&drv_data->pdev->dev, "transfer: all done!\n");
>  		message->status = 0;
>  		giveback(drv_data);
>  		return;
> @@ -645,6 +651,7 @@ static void pump_transfers(unsigned long data)
>  
>  	/* Delay if requested at end of transfer */
>  	if (message->state == RUNNING_STATE) {
> +		dev_dbg(&drv_data->pdev->dev, "transfer: still running ...\n");
>  		previous = list_entry(transfer->transfer_list.prev,
>  				      struct spi_transfer, transfer_list);
>  		if (previous->delay_usecs)
> @@ -805,7 +812,8 @@ static void pump_transfers(unsigned long data)
>  		dma_config = (RESTART | dma_width | DI_EN);
>  		if (drv_data->rx != NULL) {
>  			/* set transfer mode, and enable SPI */
> -			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
> +			dev_dbg(&drv_data->pdev->dev, "doing DMA in to %p (size %zx)\n",
> +				drv_data->rx, drv_data->len_in_bytes);
>  
>  			/* invalidate caches, if needed */
>  			if (bfin_addr_dcachable((unsigned long) drv_data->rx))
> -- 
> 1.5.6.3
> 
> 


