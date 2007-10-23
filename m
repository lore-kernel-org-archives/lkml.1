Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbXJWPLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbXJWPLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbXJWPLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:11:07 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:44398 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbXJWPLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:11:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18206.3808.849690.113159@stoffel.org>
Date: Tue, 23 Oct 2007 11:10:24 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: IDE crash...
In-Reply-To: <20071023074554.GA5059@kernel.dk>
References: <20071023070932.GB25962@kernel.dk>
	<20071023.001850.130236174.davem@davemloft.net>
	<20071023072359.GH25962@kernel.dk>
	<20071023.004321.74750417.davem@davemloft.net>
	<20071023074554.GA5059@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens> On Tue, Oct 23 2007, David Miller wrote:
>> From: Jens Axboe <jens.axboe@oracle.com>
>> Date: Tue, 23 Oct 2007 09:23:59 +0200
>> 
>> > On Tue, Oct 23 2007, David Miller wrote:
>> > > From: Jens Axboe <jens.axboe@oracle.com>
>> > > Date: Tue, 23 Oct 2007 09:09:33 +0200
>> > > 
>> > > > Eh this wont work, it's the wrong entry... Here's a temporary
>> > > > work-around.
>> > > > 
>> > > > diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
>> > > > index c89f0d3..108202b 100644
>> > > > --- a/drivers/ide/ide-io.c
>> > > > +++ b/drivers/ide/ide-io.c
>> > > > @@ -822,6 +822,7 @@ void ide_map_sg(ide_drive_t *drive, struct request *rq)
>> > > >  		return;
>> > > >  
>> > > >  	if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
>> > > > +		sg_init_table(hwif->sg_table, hwif->sg_max_nents);
>> > > >  		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
>> > > >  	} else {
>> > > >  		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
>> > > 
>> > > That's the exact patch I'm about to boot test :-)
>> > 
>> > That should work - once you verify that, would you mind testing this one
>> > as well? Thanks!
>> 
>> This one works here too, thanks.

Jens> Great, thanks for testing that as well. Thinking a bit more
Jens> about it, I think the forced clear should stay in
Jens> blk_rq_map_sg() since we don't want to advertise it to
Jens> drivers. So I'll just open-code it in there.

Should there be more bounds checking here, so that if you try to do a
_force() you at least check to make sure that there's something beyond
there and useable on the list?  

We're saving the time from not reallocating from scratch, but let's
make it robust by doing at least some more checks here.

John
