Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbYGBS5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbYGBS5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 14:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYGBS5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 14:57:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbYGBS5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:57:31 -0400
Date: Wed, 2 Jul 2008 11:57:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: philipp.zabel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: fix a bug in the asic3 irq demux code
Message-Id: <20080702115726.d7ccb114.akpm@linux-foundation.org>
In-Reply-To: <20080702182219.GB15015@caravaggio>
References: <1215020573.24941.1.camel@localhost.localdomain>
	<20080702105303.990e6395.akpm@linux-foundation.org>
	<20080702182219.GB15015@caravaggio>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 20:22:20 +0200
Samuel Ortiz <sameo@openedhand.com> wrote:

> Hi Andrew,
> 
> On Wed, Jul 02, 2008 at 10:53:03AM -0700, Andrew Morton wrote:
> > On Wed, 02 Jul 2008 19:42:53 +0200 Philipp Zabel <philipp.zabel@gmail.com> wrote:
> > 
> > > Wrong irq numbers were given to desc->handle_irq, which
> > > on some devices caused endless loops (asic3_irq_demux
> > > calling itself, basically).
> > > 
> > > Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> > > ---
> > >  drivers/mfd/asic3.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
> > > index 8e41130..59ec9c6 100644
> > > --- a/drivers/mfd/asic3.c
> > > +++ b/drivers/mfd/asic3.c
> > > @@ -308,7 +308,7 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
> > >  		for (i = ASIC3_NUM_GPIOS; i < ASIC3_NR_IRQS; i++) {
> > >  			/* They start at bit 4 and go up */
> > >  			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4))) {
> > > -				desc = irq_desc +  + i;
> > > +				desc = irq_desc + asic->irq_base + i;
> > >  				desc->handle_irq(asic->irq_base + i,
> > >  						 desc);
> > >  			}
> > 
> > hm, I seem to have a pile of mfd patches.  I'll look to offload those
> > on Samuel.
> > 
> > Samuel, will you be setting up an MFD git tree for linux-next?  (You
> > should, please).
> I have set up an mfd tree here: http://git.o-hand.com/?r=linux-mfd
> with a for-next branch.

OK, thanks.  Linus gets upset over git-over-http for some reason, so
I'd suggest that you move to kernel.org when that is set up.

Plus: I pull from lots of different git servers and it's quite common
that at least one of them is dead.  It was git://www.linux-m32r.org
yesterday.

> I havent asked Stephen to pull from it yet,
> and I havent Cc'ed you on the mfd patches that are sitting there as
> I was mostly setting things up. I will clean things up and re-apply
> them so that you get a notification for all the mfd patches that are
> already on -mm.
> 
> I also requested for an account on kernel.org, but I'm still waiting
> for an answer.

Cool.

I assume that sameo@openedhand.com is now the preferred address?  Will
samuel@sortiz.org continue to work?

