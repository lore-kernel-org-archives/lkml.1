Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab0CKLBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:01:18 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:35348 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab0CKLBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:01:17 -0500
Message-ID: <4B98CD5D.3080709@mvista.com>
Date: Thu, 11 Mar 2010 14:00:45 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
CC: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] davinci: MMC: Pass number of SG segments as platform
 data
References: <1268292756-5369-1-git-send-email-sudhakar.raj@ti.com>
In-Reply-To: <1268292756-5369-1-git-send-email-sudhakar.raj@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Sudhakar Rajashekhara wrote:

> On some platforms like DM355, the number of EDMA parameter
> slots available for EDMA_SLOT_ANY usage are few. In such cases,
> if MMC/SD uses 16 slots for each instance of MMC controller,
> then the number of slots available for other modules will be
> very few.
>
> By passing the number of EDMA slots to be used in MMC driver
> from platform data, EDMA slots available for other purposes
> can be controlled.
>
> Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
> ---
>  arch/arm/mach-davinci/include/mach/mmc.h |    3 +++
>  drivers/mmc/host/davinci_mmc.c           |   22 +++++++++++++++-------
>  2 files changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/include/mach/mmc.h b/arch/arm/mach-davinci/include/mach/mmc.h
> index 5a85e24..384fc0e 100644
> --- a/arch/arm/mach-davinci/include/mach/mmc.h
> +++ b/arch/arm/mach-davinci/include/mach/mmc.h
> @@ -22,6 +22,9 @@ struct davinci_mmc_config {
>  
>  	/* Version of the MMC/SD controller */
>  	u8	version;
> +
> +	/* Number of sg segments */
> +	u32	nr_sg;
>   

  Why waste 4 bytres if the maximum number is 16?

> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> index 3bd0ba2..19c050c 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -137,15 +137,15 @@
>  
>  /*
>   * One scatterlist dma "segment" is at most MAX_CCNT rw_threshold units,
> - * and we handle up to NR_SG segments.  MMC_BLOCK_BOUNCE kicks in only
> + * and we handle up to MAX_NR_SG segments.  MMC_BLOCK_BOUNCE kicks in only
>   * for drivers with max_hw_segs == 1, making the segments bigger (64KB)
> - * than the page or two that's otherwise typical.  NR_SG == 16 gives at
> - * least the same throughput boost, using EDMA transfer linkage instead
> - * of spending CPU time copying pages.
> + * than the page or two that's otherwise typical. nr_sg (passed from
> + * platform data) == 16 gives at least the same throughput boost, using
> + * EDMA transfer linkage instead of spending CPU time copying pages.
>   */
>  #define MAX_CCNT	((1 << 16) - 1)
>  
> -#define NR_SG		16
> +#define MAX_NR_SG	16
>  
>  static unsigned rw_threshold = 32;
>  module_param(rw_threshold, uint, S_IRUGO);
> @@ -192,7 +192,7 @@ struct mmc_davinci_host {
>  	struct edmacc_param	tx_template;
>  	struct edmacc_param	rx_template;
>  	unsigned		n_link;
> -	u32			links[NR_SG - 1];
> +	u32			links[MAX_NR_SG - 1];
>  
>  	/* For PIO we walk scatterlists one segment at a time. */
>   

>  	unsigned int		sg_len;
> @@ -202,6 +202,8 @@ struct mmc_davinci_host {
>  	u8 version;
>  	/* for ns in one cycle calculation */
>  	unsigned ns_in_one_cycle;
> +	/* Number of sg segments */
> +	u32 nr_sg;
>   

   Same question.

WBR, Sergei

