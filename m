Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbXJ0OnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbXJ0OnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbXJ0OnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:43:00 -0400
Received: from fallback.mail.ru ([194.67.57.14]:13123 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbXJ0Om7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:42:59 -0400
Date: Sat, 27 Oct 2007 18:37:31 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, netdev@vger.kernel.org,
       leoli@freescale.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] ucc_geth: add support for netpoll
Message-ID: <20071027143731.GA2616@zarina>
Reply-To: cbou@mail.ru
References: <20071011124842.GB13963@localhost.localdomain> <4723389F.7010109@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <4723389F.7010109@ru.mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 05:09:51PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> Anton Vorontsov wrote:
> 
> > This patch adds netpoll support for the QE UCC Gigabit Ethernet
> > driver. The approach is very similar to the gianfar driver.
> 
>     It's rather contrarywise -- this is standard approach and gianfar with its 
> 3 TSEC IRQs has a quite non-standard poll_controller() implementation.

Oh.. well, right -- gianfar a bit more comlex in that regard.

> 
> > Tested using netconsole.
> 
>     KGDBoE is considered a better test (I hope you've also tested with it).

At the time of posting it was tested using netconsole only, a few
days later it's was tested using KGDBoE also. So, it works indeed.

> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
> > index 18a6f48..06807ce 100644
> > --- a/drivers/net/ucc_geth.c
> > +++ b/drivers/net/ucc_geth.c
> > @@ -3691,6 +3691,22 @@ static irqreturn_t ucc_geth_irq_handler(int irq, void *info)
> >  	return IRQ_HANDLED;
> >  }
> >  
> > +#ifdef CONFIG_NET_POLL_CONTROLLER
> > +/*
> > + * Polling 'interrupt' - used by things like netconsole to send skbs
> > + * without having to re-enable interrupts. It's not called while
> > + * the interrupt routine is executing.
> > + */
> > +static void ucc_netpoll(struct net_device *dev)
> > +{
> > +	struct ucc_geth_private *ugeth = netdev_priv(dev);
> > +
> > +	disable_irq(ugeth->ug_info->uf_info.irq);
> > +	ucc_geth_irq_handler(ugeth->ug_info->uf_info.irq, dev);
> > +	enable_irq(ugeth->ug_info->uf_info.irq);
> 
>     Why not make it less complex (for a reader and gcc too :-) ?

Yup, I'm agree here but it's too late. Again. ;-)

This patch already accepted into the -mm (a week or so after the
silence), so.. now I'd rather not bother Andrew with such really
cosmetic changes. But if Jeff would directly apply modfied patch,
I'll send it. ;-)


Anyhow, I'm sincerely appreciate your comments.

Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
