Return-Path: <linux-kernel-owner+w=401wt.eu-S1763361AbYBSJzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763361AbYBSJzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763275AbYBSJze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:55:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49237 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763249AbYBSJzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:55:31 -0500
Reply-To: <kmpark@infradead.org>
From: "Kyungmin Park" <kmpark@infradead.org>
To: "'Jens Axboe'" <jens.axboe@oracle.com>
Cc: "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
       "'Linux Filesystem Mailing List'" <linux-fsdevel@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
References: <9c9fda240802182148m6fd632pa7988530c5387245@mail.gmail.com> <20080219091608.1da174c1@crazy> <002f01c872db$69c854c0$1fa9580a@swcenter.sec.samsung.co.kr> <20080219094301.GU23197@kernel.dk>
Subject: RE: Question about synchronous write on SSD
Date: Tue, 19 Feb 2008 18:55:26 +0900
Organization: infradead
Message-ID: <000301c872dd$91461fd0$1fa9580a@swcenter.sec.samsung.co.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
In-reply-to: <20080219094301.GU23197@kernel.dk>
Thread-Index: Achy292FjunqlKltTGSLVSxblAjo+wAAKQkg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > Agree, however see the following sequence.
> >
> > __generic_make_request call q->make_request_fn(q, bio);
> > It was set by blk_init_queue_node with __make_request.
> > There are two ways in __make_request.
> > Case 1, get_rq
> > Case 2, out or merged (otherwise you mean unplug case)
> >
> > In case 1, if the BIO_RW_SYNC is set, the request gets the REQ_RW_SYNC
> > And REQ_RW_SYNC says
> > "include/linux/blkdev.h":112: __REQ_RW_SYNC,          /* request is sync (O_DIRECT) */
> > It means it acts as O_DIRECT flag. Is it right?
> > And it also is same as case 2. Unplug the device.
> > So next time it hasn't chance to merge???
> 
> But that still doesn't make it sync. I think you are working the wrong
> way. For ssd we still want merging and plugging also makes sense to some
> degree, though it probably should be minimized. It'll only cause an
> initial latency, for busy IO workloads you wont be plugging/unplugging
> much anyway.
> 
> In fact your patch makes things WORSE, since the io schedulers will now
> treat the IO as sync and introduce idling for the disk head. And you
> definitely don't want that.

Yes, you're right. It's for testing.
I just want to know the worst or corner case, if all writes are synchronous.
Of course I can measure the using tiotest "Do write synchronous" option.
Then you think it's the worse case?

Kyungmin Park

