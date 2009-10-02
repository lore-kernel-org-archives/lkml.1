Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZJBVma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZJBVma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbZJBVm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:42:29 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60431 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbZJBVm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:42:28 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/21h24qXkfNOCOPMgFUq/8
Date: Fri, 2 Oct 2009 14:42:29 -0700
From: Tony Lindgren <tony@atomide.com>
To: Venkatraman S <svenkatr@ti.com>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SDMA: Fixing bug in omap_dma_set_global_params()
Message-ID: <20091002214229.GU16865@atomide.com>
References: <1253690346-17865-1-git-send-email-anuj.aggarwal@ti.com> <618f0c910909230124q773b90f6xd377e67a758e1237@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <618f0c910909230124q773b90f6xd377e67a758e1237@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Venkatraman S <svenkatr@ti.com> [090923 01:25]:
> On Wed, Sep 23, 2009 at 12:49 PM, Anuj Aggarwal <anuj.aggarwal@ti.com> wrote:
> > Argument tparams was not being used to program
> > global register GCR.HI_THREAD_RESERVED. This patch fixes the same.
> >
> > Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
> > ---
> >  arch/arm/plat-omap/dma.c |   13 +++++++------
> >  1 files changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
> > index bf08634..7a7b6df 100644
> > --- a/arch/arm/plat-omap/dma.c
> > +++ b/arch/arm/plat-omap/dma.c
> > @@ -829,10 +829,10 @@ EXPORT_SYMBOL(omap_free_dma);
> >  *
> >  * @param arb_rate
> >  * @param max_fifo_depth
> > - * @param tparams - Number of thereads to reserve : DMA_THREAD_RESERVE_NORM
> > - *                                                 DMA_THREAD_RESERVE_ONET
> > - *                                                 DMA_THREAD_RESERVE_TWOT
> > - *                                                 DMA_THREAD_RESERVE_THREET
> > + * @param tparams - Number of threads to reserve : DMA_THREAD_RESERVE_NORM
> > + *                                                DMA_THREAD_RESERVE_ONET
> > + *                                                DMA_THREAD_RESERVE_TWOT
> > + *                                                DMA_THREAD_RESERVE_THREET
> >  */
> >  void
> >  omap_dma_set_global_params(int arb_rate, int max_fifo_depth, int tparams)
> > @@ -847,8 +847,9 @@ omap_dma_set_global_params(int arb_rate, int max_fifo_depth, int tparams)
> >        if (arb_rate == 0)
> >                arb_rate = 1;
> >
> > -       reg = (arb_rate & 0xff) << 16;
> > -       reg |= (0xff & max_fifo_depth);
> > +       reg = 0xff & max_fifo_depth;
> > +       reg |= (0x3 & tparams) << 12;
> > +       reg |= (arb_rate & 0xff) << 16;
> >
> >        dma_write(reg, GCR);
> >  }
> 
> max_fifo_depth should not be set to zero. Perhaps it deserves a check
> similar to arb_rate ?

Any news on updating this patch to also check the max_fifo_depth?

Tony
