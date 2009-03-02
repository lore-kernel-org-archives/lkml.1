Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbZCBNNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbZCBNNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 08:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZCBNNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 08:13:16 -0500
Received: from brick.kernel.dk ([93.163.65.50]:57874 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbZCBNNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:13:15 -0500
Date: Mon, 2 Mar 2009 14:13:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: ???? <xiegang112@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The difference of request dir between AS and Deadline I/O
	scheduler?
Message-ID: <20090302131313.GU11787@kernel.dk>
References: <d364733c0903012106g2625d433o4cdbbbcc5a9ff19a@mail.gmail.com> <20090302122547.GT11787@kernel.dk> <d364733c0903020503x43a1448cq1b127a88fd816e1c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d364733c0903020503x43a1448cq1b127a88fd816e1c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02 2009, ???? wrote:
> Do you mean that the same process tends to have the same behavior of
> I/O in the way of sycn?
> Does this mean AS works better when requests are distincted by sync
> mode  (the success rate of anticipation is higher when requests are
> grouped by the mode of sync)?

Please don't top post, put your reply beneath the text you are replying
to.

It means that there's a key distinction between requests. Sync requests
often have dependencies on each other, and AS thus enables idling for
these types of requests. Async io is usually background activity. I
don't understand what you mean by higher success rate. Anticipation is
only for sync requests. The grouping is done because it makes
behavioural sense.


> 
> Thanks,
> 
> 
> On Mon, Mar 2, 2009 at 8:25 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Mon, Mar 02 2009, ???? wrote:
> >> Hi,
> >>
> >> I'm little confused about the defination of request dir in AS and
> >> Deadline I/O scheduler.
> >> In AS, the request dir is defined by wheher it's sync:
> >>
> >> data_dir = rq_is_sync(rq);
> >>
> >> But in Deadline, the requests are grouped by read and write.
> >>
> >> Why is there the difference since AS is an extension of Deadline?
> >> what's the consideration?
> >
> > Because AS uses the sync vs async distinction to decide whether to
> > anticipate a new request from that process. 'sync' is then reads or sync
> > writes, whereas deadline does not distinguish between sync and async
> > writes.
> >
> > --
> > Jens Axboe
> >
> >
> 
> 
> 
> -- 
> Xie Gang

-- 
Jens Axboe

