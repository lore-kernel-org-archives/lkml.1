Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZENRWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZENRWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZENRWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:22:37 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:52372 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbZENRWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:22:36 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+SkilL0CXv3yx56YAcfrxO
Date: Thu, 14 May 2009 10:22:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Carlos Aguiar <carlos.aguiar@indt.org.br>,
       Anderson Briglia <briglia.anderson@gmail.com>,
       "Syed Mohammed, Khasim" <x0khasim@ti.com>,
       Ben Nizette <bn@niasdigital.com>, linux-omap@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] omap mmc host: Use disable_irq_nosync() from
	within irq handlers.
Message-ID: <20090514172226.GK5593@atomide.com>
References: <1239861321.29831.130.camel@linux-51e8.site> <20090426212118.19526712@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090426212118.19526712@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pierre Ossman <pierre@ossman.eu> [090426 12:22]:
> Should I queue this up or do you want to do something differently for
> this?

Looks like a valid fix to me.

Acked-by: Tony Lindgren <tony@atomide.com>
 
> On Thu, 16 Apr 2009 15:55:21 +1000
> Ben Nizette <bn@niasdigital.com> wrote:
> 
> > 
> > disable_irq() should wait for all running handlers to complete
> > before returning.  As such, if it's used to disable an interrupt
> > from that interrupt's handler it will deadlock.  This replaces
> > the dangerous instances with the _nosync() variant which doesn't
> > have this problem.
> > 
> > Signed-off-by: Ben Nizette <bn@niasdigital.com>
> > ---
> > diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
> > index 5570849..d5ea652 100644
> > --- a/drivers/mmc/host/omap.c
> > +++ b/drivers/mmc/host/omap.c
> > @@ -824,7 +824,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
> >  		del_timer(&host->cmd_abort_timer);
> >  		host->abort = 1;
> >  		OMAP_MMC_WRITE(host, IE, 0);
> > -		disable_irq(host->irq);
> > +		disable_irq_nosync(host->irq);
> >  		schedule_work(&host->cmd_abort_work);
> >  		return IRQ_HANDLED;
> >  	}
> 
> 
> -- 
>      -- Pierre Ossman
> 
>   WARNING: This correspondence is being monitored by the
>   Swedish government. Make sure your server uses encryption
>   for SMTP traffic and consider using PGP for end-to-end
>   encryption.


