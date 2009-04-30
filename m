Return-Path: <linux-kernel-owner+w=401wt.eu-S1764572AbZD3S7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764572AbZD3S7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762402AbZD3S6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:58:53 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:62682 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762576AbZD3S6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:58:53 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18+SXNgv2AYSewH2S2cawLk
Date: Thu, 30 Apr 2009 11:58:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       "Gadiyar, Anand" <gadiyar@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH] OMAP: HSMMC: Do not enable buffer ready interrupt if
	using DMA
Message-ID: <20090430185844.GG12986@atomide.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02FB2F2A90@dbde02.ent.ti.com> <20090428213833.18afbba0@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428213833.18afbba0@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pierre Ossman <pierre@ossman.eu> [090428 12:38]:
> Jarkko? Tony?

Hmm, we haven't heard from Jarkko for a while.. Adrian, care to take
a look at this patch?

Tony
 
> On Tue, 21 Apr 2009 13:09:22 +0530
> "Gadiyar, Anand" <gadiyar@ti.com> wrote:
> 
> > From: Anand Gadiyar <gadiyar@ti.com>
> > 
> > OMAP: HSMMC: Do not enable buffer ready interrupt if using DMA
> > 
> > This considerably reduces the number of interrupts during a transfer
> > and ought to result in some power saving.
> > 
> > Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Acked-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
> > ---
> > diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> > index e62a22a..2d83807 100644
> > --- a/drivers/mmc/host/omap_hsmmc.c
> > +++ b/drivers/mmc/host/omap_hsmmc.c
> > @@ -70,6 +70,8 @@
> >  #define DTO_MASK		0x000F0000
> >  #define DTO_SHIFT		16
> >  #define INT_EN_MASK		0x307F0033
> > +#define BWR_ENABLE		(1 << 4)
> > +#define BRR_ENABLE		(1 << 5)
> >  #define INIT_STREAM		(1 << 1)
> >  #define DP_SELECT		(1 << 21)
> >  #define DDIR			(1 << 4)
> > @@ -241,7 +243,12 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd,
> >  	 */
> >  	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
> >  	OMAP_HSMMC_WRITE(host->base, ISE, INT_EN_MASK);
> > -	OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
> > +
> > +	if (host->use_dma)
> > +		OMAP_HSMMC_WRITE(host->base, IE,
> > +				 INT_EN_MASK & ~(BRR_ENABLE | BWR_ENABLE));
> > +	else
> > +		OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
> >  
> >  	host->response_busy = 0;
> >  	if (cmd->flags & MMC_RSP_PRESENT) {
> 
> 
> -- 
>      -- Pierre Ossman
> 
>   WARNING: This correspondence is being monitored by the
>   Swedish government. Make sure your server uses encryption
>   for SMTP traffic and consider using PGP for end-to-end
>   encryption.


