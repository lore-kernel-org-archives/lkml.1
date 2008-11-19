Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbYKSRXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbYKSRXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 12:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYKSRXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 12:23:15 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:37593 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbYKSRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 12:23:14 -0500
Date: Wed, 19 Nov 2008 18:21:25 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
       "Hommel, Thomas (GE EntSol, Intelligent Platforms)" 
	<Thomas.Hommel@gefanuc.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       James.Bottomley@HansenPartnership.com
Subject: Re: ISP1760 driver crashes
Message-ID: <20081119172125.GS26308@kernel.dk>
References: <20081119153923.GR26308@kernel.dk> <Pine.LNX.4.44L0.0811191131320.2418-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811191131320.2418-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19 2008, Alan Stern wrote:
> On Wed, 19 Nov 2008, Jens Axboe wrote:
> 
> > > --- usb-2.6.orig/drivers/scsi/scsi_lib.c
> > > +++ usb-2.6/drivers/scsi/scsi_lib.c
> > > @@ -1684,7 +1684,7 @@ static void scsi_request_fn(struct reque
> > >  u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
> > >  {
> > >  	struct device *host_dev;
> > > -	u64 bounce_limit = 0xffffffff;
> > > +	u64 bounce_limit = BLK_BOUNCE_HIGH;
> > >  
> > >  	if (shost->unchecked_isa_dma)
> > >  		return BLK_BOUNCE_ISA;
> > > 
> > 
> > The best solution is probably to either provide a "doesn't do highmem"
> > in the scsi host template, or provide an appropriate DMA mask for the
> > pci device to indicate it through that setting instead.
> 
> The DMA mask is currently set to NULL.  Is that not appropriate for a 
> device that can't do DMA?  If not, then what would be appropriate?

It's changing behaviour. There's no current rule that says if you don't
have a dma mask set, we only do PIO (even if such a rule DOES make
sense). Additionally, you don't HAVE to bounce for PIO. As I wrote
earlier, it's perfectly feasible to use bio kmap'ings to do the
transfer.

> Also, is the patch above not correct?

It'll certainly work in the sense that if you don't have a dma_mask set,
you only get lowmem pages. Whether the new behaviour is something we
want, not sure. Check with James what he thinks, it's his domain.

-- 
Jens Axboe

