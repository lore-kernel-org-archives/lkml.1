Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbZDBPXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbZDBPXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758789AbZDBPXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:23:11 -0400
Received: from www.tglx.de ([62.245.132.106]:33019 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758711AbZDBPXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:23:09 -0400
Date: Thu, 2 Apr 2009 17:21:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       henrix@sapo.pt, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/genirq] genirq: do not execute DEBUG_SHIRQ when irq
 setup failed
In-Reply-To: <1238682747.3099.16.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0904021718230.12916@localhost.localdomain>
References: <20090401170635.GA4392@hades.domain.com>  <tip-ba71604fad348656071a2a76eef9a67dab85a773@git.kernel.org> <1238682747.3099.16.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Jaswinder Singh Rajput wrote:
> On Thu, 2009-04-02 at 14:03 +0000, Luis Henriques wrote:
> > Commit-ID:  ba71604fad348656071a2a76eef9a67dab85a773
> > Gitweb:     http://git.kernel.org/tip/ba71604fad348656071a2a76eef9a67dab85a773
> > Author:     Luis Henriques <henrix@sapo.pt>
> > AuthorDate: Wed, 1 Apr 2009 18:06:35 +0100
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Thu, 2 Apr 2009 16:02:39 +0200
> > 
> > genirq: do not execute DEBUG_SHIRQ when irq setup failed
> > 
> > When requesting an IRQ, the DEBUG_SHIRQ code executes a fake IRQ just to make
> > sure the driver is ready to receive an IRQ immediately.  The problem was that
> > this fake IRQ was being executed even if interrupt line failed to be allocated
> > by __setup_irq.
> > 
> > Signed-off-by: Luis Henriques <henrix@sapo.pt>
> > LKML-Reference: <20090401170635.GA4392@hades.domain.com>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > 
> > 
> > ---
> >  kernel/irq/manage.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> > index 1516ab7..beeb7d1 100644
> > --- a/kernel/irq/manage.c
> > +++ b/kernel/irq/manage.c
> > @@ -768,7 +768,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
> >  		kfree(action);
> >  
> >  #ifdef CONFIG_DEBUG_SHIRQ
> > -	if (irqflags & IRQF_SHARED) {
> > +	if (!retval & (irqflags & IRQF_SHARED)) {
> >  		/*
> >  		 * It's a shared IRQ -- the driver ought to be prepared for it
> >  		 * to happen immediately, so let's make sure....
> 
> What is this ?

You looking at the wrong place.
 
> There is no retval:
> 
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=blob;f=kernel/irq/manage.c;h=a3eb7baf1e46f2c735edb4cc44e0386cfbc4989e;hb=HEAD

Care to read patches you want to comment on carefully _BEFORE_ you
start yelling at people and sending useless copies of the wrong
function around the world.

The patch is perfectly fine and already applied.

Thanks,

	tglx
