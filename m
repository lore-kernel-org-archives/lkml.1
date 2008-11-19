Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYKSQeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYKSQeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYKSQdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:33:52 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40794 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751920AbYKSQdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:33:51 -0500
Date: Wed, 19 Nov 2008 11:33:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
       "Hommel, Thomas (GE EntSol, Intelligent Platforms)" 
	<Thomas.Hommel@gefanuc.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: ISP1760 driver crashes
In-Reply-To: <20081119153923.GR26308@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.0811191131320.2418-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008, Jens Axboe wrote:

> > --- usb-2.6.orig/drivers/scsi/scsi_lib.c
> > +++ usb-2.6/drivers/scsi/scsi_lib.c
> > @@ -1684,7 +1684,7 @@ static void scsi_request_fn(struct reque
> >  u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
> >  {
> >  	struct device *host_dev;
> > -	u64 bounce_limit = 0xffffffff;
> > +	u64 bounce_limit = BLK_BOUNCE_HIGH;
> >  
> >  	if (shost->unchecked_isa_dma)
> >  		return BLK_BOUNCE_ISA;
> > 
> 
> The best solution is probably to either provide a "doesn't do highmem"
> in the scsi host template, or provide an appropriate DMA mask for the
> pci device to indicate it through that setting instead.

The DMA mask is currently set to NULL.  Is that not appropriate for a 
device that can't do DMA?  If not, then what would be appropriate?

Also, is the patch above not correct?

Alan Stern

