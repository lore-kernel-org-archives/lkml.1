Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbXL0NYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbXL0NYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 08:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXL0NYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 08:24:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:15751 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbXL0NX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 08:23:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LO0FCse+/br85F2Nt34cpJikIfNflgSouSgVwu3fVyrYB+oxvfTFWMvrL1h6/y2GXe6WeAihaY5FuECwPsnDckJqjvY3OXDbH/E1Ffh+kcKbbXLH5PZcPhiTrZQVFAdLqH/w+vCDVhzMbJkGsi96clpENK29hj2uyriIbUgwpfE=
Message-ID: <4104961b0712270523g30d04560qb1b6df0e6aadbf4c@mail.gmail.com>
Date: Thu, 27 Dec 2007 21:23:58 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: What does "ordering by draining" mean?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071210103753.GB5008@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4104961b0712100149h69b1e1fas355b770f93affd03@mail.gmail.com>
	 <20071210103753.GB5008@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 10, 2007 6:37 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>
> On Mon, Dec 10 2007, jidong xiao wrote:
> > Hi,
> >
> > I am reading the source code of block I/O layer, and now seeing there
> > saying "ordering by draining" or "ordering by tag" in
> > include/blkdev.h,and the comments in that file says: "Hardbarrier is
> > supported with one of the following methods", but what do these two
> > methods exactly mean?
>
> ordering by draining means that you empty the pending queue of requests
> and then flush the cache to prevent a later issue of a new request to
> reach the platter before the older ones. order by tag means that the hw
> has a way of being told not to reorder beyond the barrier, in which case
> you don't have to drain the queue.
>

Well, I saw these comments in sd_revalidate_disk(), does this mean
SCSI TCQ is not supported in Linux?

   1545         /*
   1546          * We now have all cache related info, determine how we deal
   1547          * with ordered requests.  Note that as the current SCSI
   1548          * dispatch function can alter request order, we cannot use
   1549          * QUEUE_ORDERED_TAG_* even when ordered tag is supported.
   1550          */
   1551         if (sdkp->WCE)
   1552                 ordered = sdkp->DPOFUA
   1553                         ? QUEUE_ORDERED_DRAIN_FUA :
QUEUE_ORDERED_DRAIN_FLUSH;
   1554         else
   1555                 ordered = QUEUE_ORDERED_DRAIN;
   1556
   1557         blk_queue_ordered(sdkp->disk->queue, ordered, sd_prepare_flush);

Regards
Jason
