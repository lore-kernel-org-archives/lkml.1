Return-Path: <linux-kernel-owner+w=401wt.eu-S1761363AbXGEM2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363AbXGEM2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759282AbXGEM22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:28:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:3345 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759190AbXGEM20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:28:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nkwu0t5DTXVqvg6f/KZaff6qUUm/8FCFExcq6KgfoiheHnrlkpKgsLnIubNjvEzU7811LpBLv7evRuJaX1+RCkUuM+5agTEfYzmv9sEsoRUr6DDCxNPDvJysFLZS3gfqdWrhPz/m8ITMB2bZEGJMCkr5Mmf2lq0gJLyh7/P1RPw=
Message-ID: <468CE3E1.3000503@gmail.com>
Date: Thu, 05 Jul 2007 21:28:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070530093503.GA15559@kernel.dk>
In-Reply-To: <20070530093503.GA15559@kernel.dk>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

Jens Axboe wrote:
> On Mon, May 28 2007, Neil Brown wrote:
>> I think the implementation priorities here are:
>>
>> 1/ implement a zero-length BIO_RW_BARRIER option.
>> 2/ Use it (or otherwise) to make all dm and md modules handle
>>    barriers (and loop?).
>> 3/ Devise and implement appropriate fall-backs with-in the block layer
>>    so that  -EOPNOTSUP is never returned.
>> 4/ Remove unneeded cruft from filesystems (and elsewhere).
> 
> This is the start of 1/ above. It's very lightly tested, it's verified
> to DTRT here at least and not crash :-)
> 
> It gets rid of the ->issue_flush_fn() queue callback, all the driver
> knowledge resides in ->prepare_flush_fn() anyways. blkdev_issue_flush()
> then just reuses the empty-bio approach to queue an empty barrier, this
> should work equally well for stacked and non-stacked devices.
> 
> While this patch isn't complete yet, it's clearly the right direction to
> go.

Finally took a brief look. :-) I think the sequencing for zero-length
barrier can be better done by pre-setting QUEUE_ORDSEQ_BAR in
start_ordered() rather than short circuiting the request after it's
issued.  What do you think?

Thanks.

-- 
tejun
