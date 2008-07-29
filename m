Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbYG2CrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbYG2CrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYG2Cq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:46:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422AbYG2Cq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:46:58 -0400
Date: Mon, 28 Jul 2008 19:46:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Collins <ben.collins@canonical.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [PATCH 4/7] nsc-ircc: Default to dongle type 9 on IBM hardware
Message-Id: <20080728194612.01068283.akpm@linux-foundation.org>
In-Reply-To: <1216662057.7585.153.camel@cunning>
References: <E1KKl4I-00068K-V7@swissweb.swissdisk.com>
	<1216618176.8411.124.camel@violet.holtmann.net>
	<1216662057.7585.153.camel@cunning>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 13:40:57 -0400 Ben Collins <ben.collins@canonical.com> wrote:

> CC: Samuel Ortiz <samuel@sortiz.org>
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
> Signed-off-by: Ben Collins <ben.collins@canonical.com>
> 
> diff --git a/drivers/net/irda/nsc-ircc.c b/drivers/net/irda/nsc-ircc.c
> index effc1ce..18d1714 100644
> --- a/drivers/net/irda/nsc-ircc.c
> +++ b/drivers/net/irda/nsc-ircc.c
> @@ -151,8 +151,8 @@ static char *dongle_types[] = {
>  static chipio_t pnp_info;
>  static const struct pnp_device_id nsc_ircc_pnp_table[] = {
>  	{ .id = "NSC6001", .driver_data = 0 },
> -	{ .id = "IBM0071", .driver_data = 0 },
>  	{ .id = "HWPC224", .driver_data = 0 },
> +	{ .id = "IBM0071", .driver_data = NSC_FORCE_DONGLE_TYPE9 },
>  	{ }
>  };
>  
> @@ -930,7 +930,10 @@ static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *i
>  	pnp_info.dma = -1;
>  	pnp_succeeded = 1;
>  
> -	/* There don't seem to be any way to get the cfg_base.
> +	if (id->driver_data & NSC_FORCE_DONGLE_TYPE9)
> +		dongle_id = 0x9;
> +
> +	/* There doesn't seem to be any way of getting the cfg_base.
>  	 * On my box, cfg_base is in the PnP descriptor of the
>  	 * motherboard. Oh well... Jean II */
>  
> diff --git a/drivers/net/irda/nsc-ircc.h b/drivers/net/irda/nsc-ircc.h
> index 29398a4..71cd3c5 100644
> --- a/drivers/net/irda/nsc-ircc.h
> +++ b/drivers/net/irda/nsc-ircc.h
> @@ -35,6 +35,9 @@
>  #include <linux/types.h>
>  #include <asm/io.h>
>  
> +/* Features for chips (set in driver_data) */
> +#define NSC_FORCE_DONGLE_TYPE9	0x00000001
> +
>  /* DMA modes needed */
>  #define DMA_TX_MODE     0x08    /* Mem to I/O, ++, demand. */
>  #define DMA_RX_MODE     0x04    /* I/O to mem, ++, demand. */
> 

The changelog doesn't exist^Wexplain the reasons for this patch.

I assume it fixes some bug?  What is it?
