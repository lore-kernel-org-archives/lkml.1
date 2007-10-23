Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459AbXJWKx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbXJWKx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXJWKxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:53:49 -0400
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:52664 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbXJWKxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:53:49 -0400
To: davem@davemloft.net
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, tomof@acm.org
Subject: Re: IDE crash...
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20071023.004321.74750417.davem@davemloft.net>
References: <20071023.001850.130236174.davem@davemloft.net>
	<20071023072359.GH25962@kernel.dk>
	<20071023.004321.74750417.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071023195255S.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 23 Oct 2007 19:52:55 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 00:43:21 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Tue, 23 Oct 2007 09:23:59 +0200
> 
> > On Tue, Oct 23 2007, David Miller wrote:
> > > From: Jens Axboe <jens.axboe@oracle.com>
> > > Date: Tue, 23 Oct 2007 09:09:33 +0200
> > > 
> > > > Eh this wont work, it's the wrong entry... Here's a temporary
> > > > work-around.
> > > > 
> > > > diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> > > > index c89f0d3..108202b 100644
> > > > --- a/drivers/ide/ide-io.c
> > > > +++ b/drivers/ide/ide-io.c
> > > > @@ -822,6 +822,7 @@ void ide_map_sg(ide_drive_t *drive, struct request *rq)
> > > >  		return;
> > > >  
> > > >  	if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
> > > > +		sg_init_table(hwif->sg_table, hwif->sg_max_nents);
> > > >  		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
> > > >  	} else {
> > > >  		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
> > > 
> > > That's the exact patch I'm about to boot test :-)
> > 
> > That should work - once you verify that, would you mind testing this one
> > as well? Thanks!
> 
> This one works here too, thanks.

BTW, we avoid calling sg_init_table() for every I/O request due to Jens'
trick. And Jens will remove the code to clear sg_dma_len/addr in
blk_rq_map_sg(). So sparc64 iommu needs to do that for itself?

http://marc.info/?l=linux-scsi&m=119261920425120&w=2

