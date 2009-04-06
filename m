Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbZDFSAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbZDFSAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZDFSAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:00:25 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58152 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZDFSAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:00:24 -0400
X-Greylist: delayed 4255 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2009 14:00:24 EDT
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/06DTsF3/K4L5xU5yjst49
Date: Mon, 6 Apr 2009 09:49:18 -0700
From: Tony Lindgren <tony@atomide.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] omap_hsmmc: Flush posted write to IRQ
Message-ID: <20090406164917.GA30724@atomide.com>
References: <49D9EF0F.9090808@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D9EF0F.9090808@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Hunter <adrian.hunter@nokia.com> [090406 05:00]:
> From: Kevin Hilman <khilman@deeprootsystems.com>
>
> Spurious IRQs seen on MMC after 2.6.29.  Flush posted write in IRQ
> handler.
>
> The interrupt line is released by clearing the error status bits
> in the MMCHS_STAT register, which must occur before the interrupt
> handler returns to avoid unwanted irqs.  Hence the need to flush
> the posted write.
>
> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>

Acked-by: Tony Lindgen <tony@atomide.com>

> ---
>
>
>
>
> This patch is slightly modified from Kevin's original, which is
> here:
>
> 	http://marc.info/?l=linux-omap&m=123862814815052&w=2
>
>
>
> drivers/mmc/host/omap_hsmmc.c |    4 ++++
> 1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 04e5a0c..2ae6049 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -452,6 +452,8 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
> 	if (host->mrq == NULL) {
> 		OMAP_HSMMC_WRITE(host->base, STAT,
> 			OMAP_HSMMC_READ(host->base, STAT));
> +		/* Flush posted write */
> +		OMAP_HSMMC_READ(host->base, STAT);
> 		return IRQ_HANDLED;
> 	}
>
> @@ -523,6 +525,8 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
> 	}
>
> 	OMAP_HSMMC_WRITE(host->base, STAT, status);
> +	/* Flush posted write */
> +	OMAP_HSMMC_READ(host->base, STAT);
>
> 	if (end_cmd || (status & CC))
> 		mmc_omap_cmd_done(host, host->cmd);
> -- 
> 1.5.6.3
