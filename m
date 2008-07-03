Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbYGCM6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbYGCM6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYGCM5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:57:43 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:56178 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbYGCM5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:57:42 -0400
Date: Thu, 3 Jul 2008 11:25:35 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mfd: fix a bug in the asic3 irq demux code
Message-ID: <20080703092534.GA6436@caravaggio>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1215020573.24941.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215020573.24941.1.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Wed, Jul 02, 2008 at 07:42:53PM +0200, Philipp Zabel wrote:
> Wrong irq numbers were given to desc->handle_irq, which
> on some devices caused endless loops (asic3_irq_demux
> calling itself, basically).
Thanks, applied to my mfd tree.

Cheers,
Samuel.


> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/mfd/asic3.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
> index 8e41130..59ec9c6 100644
> --- a/drivers/mfd/asic3.c
> +++ b/drivers/mfd/asic3.c
> @@ -308,7 +308,7 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
>  		for (i = ASIC3_NUM_GPIOS; i < ASIC3_NR_IRQS; i++) {
>  			/* They start at bit 4 and go up */
>  			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4))) {
> -				desc = irq_desc +  + i;
> +				desc = irq_desc + asic->irq_base + i;
>  				desc->handle_irq(asic->irq_base + i,
>  						 desc);
>  			}
> -- 
> 1.5.6
> 
> 
