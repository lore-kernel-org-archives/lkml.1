Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZDCJ7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZDCJ7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 05:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbZDCJ67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 05:58:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:32857 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592AbZDCJ67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:58:59 -0400
Message-ID: <49D5DDDE.9090407@garzik.org>
Date: Fri, 03 Apr 2009 05:58:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
References: <20090402015455.GA14087@havoc.gtf.org> <20090403094909.GQ5178@kernel.dk>
In-Reply-To: <20090403094909.GQ5178@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> This wont work, GFP_NOIO inside the queue lock. You are also only
> cloning the front bio, what happens if you have > 1 bio on the request?
> You seem to dequeue the request and complete all of it, regardless of
> whether bio->bi_size == blk_rq_bytes(rq). I'm assuming you have to clone
> because of how the osd_req_{read,write} works, so I'd suggest storing
> the byte size in your osdblk_request and only completing that in
> osdblk_end_request(). Then do a rq_for_each_bio() look in there, and
> only dequeue if you manage to start an osd request for each of them,
> THEN moving on to the next request.

Thanks for the review.  Will fix...

	Jeff


