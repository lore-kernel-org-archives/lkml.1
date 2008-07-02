Return-Path: <linux-kernel-owner+w=401wt.eu-S1761605AbYGBVV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605AbYGBVV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYGBVTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:19:05 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:41872 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468AbYGBVTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:19:03 -0400
Date: Wed, 2 Jul 2008 23:18:58 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: philipp.zabel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: fix a bug in the asic3 irq demux code
Message-ID: <20080702211857.GC15015@caravaggio>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1215020573.24941.1.camel@localhost.localdomain> <20080702105303.990e6395.akpm@linux-foundation.org> <20080702182219.GB15015@caravaggio> <20080702115726.d7ccb114.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702115726.d7ccb114.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 11:57:26AM -0700, Andrew Morton wrote:
> On Wed, 2 Jul 2008 20:22:20 +0200
> Samuel Ortiz <sameo@openedhand.com> wrote:
> 
> > Hi Andrew,
> > 
> > On Wed, Jul 02, 2008 at 10:53:03AM -0700, Andrew Morton wrote:
> > > On Wed, 02 Jul 2008 19:42:53 +0200 Philipp Zabel <philipp.zabel@gmail.com> wrote:
> > > 
> > > > Wrong irq numbers were given to desc->handle_irq, which
> > > > on some devices caused endless loops (asic3_irq_demux
> > > > calling itself, basically).
> > > > 
> > > > Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> > > > ---
> > > >  drivers/mfd/asic3.c |    2 +-
> > > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
> > > > index 8e41130..59ec9c6 100644
> > > > --- a/drivers/mfd/asic3.c
> > > > +++ b/drivers/mfd/asic3.c
> > > > @@ -308,7 +308,7 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
> > > >  		for (i = ASIC3_NUM_GPIOS; i < ASIC3_NR_IRQS; i++) {
> > > >  			/* They start at bit 4 and go up */
> > > >  			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4))) {
> > > > -				desc = irq_desc +  + i;
> > > > +				desc = irq_desc + asic->irq_base + i;
> > > >  				desc->handle_irq(asic->irq_base + i,
> > > >  						 desc);
> > > >  			}
> > > 
> > > hm, I seem to have a pile of mfd patches.  I'll look to offload those
> > > on Samuel.
> > > 
> > > Samuel, will you be setting up an MFD git tree for linux-next?  (You
> > > should, please).
> > I have set up an mfd tree here: http://git.o-hand.com/?r=linux-mfd
> > with a for-next branch.
> 
> OK, thanks.  Linus gets upset over git-over-http for some reason, so
> I'd suggest that you move to kernel.org when that is set up.
Oh, this is only the gitweb interface, the git address is:
git://git.o-hand.com/linux-mfd.git

But please dont pull from it right now. I'll let you (and Stephen) know
whenever it is ready for pulling.
 
> Plus: I pull from lots of different git servers and it's quite common
> that at least one of them is dead.  It was git://www.linux-m32r.org
> yesterday.
If I get an account on kernel.org, I'll definitely move over there.


> > I havent asked Stephen to pull from it yet,
> > and I havent Cc'ed you on the mfd patches that are sitting there as
> > I was mostly setting things up. I will clean things up and re-apply
> > them so that you get a notification for all the mfd patches that are
> > already on -mm.
> > 
> > I also requested for an account on kernel.org, but I'm still waiting
> > for an answer.
> 
> Cool.
> 
> I assume that sameo@openedhand.com is now the preferred address?  Will
> samuel@sortiz.org continue to work?
Both will work. I'll do the MFD work from my @openedhand.com address and
my IrDA one from @sortiz.org

Cheers,
Samuel.
