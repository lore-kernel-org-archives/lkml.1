Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbXJWK6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbXJWK6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbXJWK6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:58:38 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11203 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbXJWK6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:58:37 -0400
Date: Tue, 23 Oct 2007 12:57:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, tomof@acm.org
Subject: Re: IDE crash...
Message-ID: <20071023105710.GJ5059@kernel.dk>
References: <20071023.001850.130236174.davem@davemloft.net> <20071023072359.GH25962@kernel.dk> <20071023.004321.74750417.davem@davemloft.net> <20071023195255S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023195255S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, FUJITA Tomonori wrote:
> On Tue, 23 Oct 2007 00:43:21 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Date: Tue, 23 Oct 2007 09:23:59 +0200
> > 
> > > On Tue, Oct 23 2007, David Miller wrote:
> > > > From: Jens Axboe <jens.axboe@oracle.com>
> > > > Date: Tue, 23 Oct 2007 09:09:33 +0200
> > > > 
> > > > > Eh this wont work, it's the wrong entry... Here's a temporary
> > > > > work-around.
> > > > > 
> > > > > diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> > > > > index c89f0d3..108202b 100644
> > > > > --- a/drivers/ide/ide-io.c
> > > > > +++ b/drivers/ide/ide-io.c
> > > > > @@ -822,6 +822,7 @@ void ide_map_sg(ide_drive_t *drive, struct request *rq)
> > > > >  		return;
> > > > >  
> > > > >  	if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
> > > > > +		sg_init_table(hwif->sg_table, hwif->sg_max_nents);
> > > > >  		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
> > > > >  	} else {
> > > > >  		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
> > > > 
> > > > That's the exact patch I'm about to boot test :-)
> > > 
> > > That should work - once you verify that, would you mind testing this one
> > > as well? Thanks!
> > 
> > This one works here too, thanks.
> 
> BTW, we avoid calling sg_init_table() for every I/O request due to Jens'
> trick. And Jens will remove the code to clear sg_dma_len/addr in
> blk_rq_map_sg(). So sparc64 iommu needs to do that for itself?
> 
> http://marc.info/?l=linux-scsi&m=119261920425120&w=2

It does - Dave, do you agree with the patch? I think it should be added,
so that sparc64 isn't the odd-arch-out in this respect. I've tentatively
applied the patch, Davem?

-- 
Jens Axboe

