Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbZDEKU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbZDEKU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 06:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbZDEKUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 06:20:42 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:3338 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757701AbZDEKUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 06:20:41 -0400
Message-ID: <49D8856E.3090903@panasas.com>
Date: Sun, 05 Apr 2009 13:18:22 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
References: <20090402015455.GA14087@havoc.gtf.org> <20090403094909.GQ5178@kernel.dk> <49D5DDDE.9090407@garzik.org>
In-Reply-To: <49D5DDDE.9090407@garzik.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Apr 2009 10:20:38.0413 (UTC) FILETIME=[2A4EA3D0:01C9B5D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2009 12:58 PM, Jeff Garzik wrote:
> Jens Axboe wrote:
>> This wont work, GFP_NOIO inside the queue lock. You are also only
>> cloning the front bio, what happens if you have > 1 bio on the request?
>> You seem to dequeue the request and complete all of it, regardless of
>> whether bio->bi_size == blk_rq_bytes(rq). I'm assuming you have to clone
>> because of how the osd_req_{read,write} works, so I'd suggest storing
>> the byte size in your osdblk_request and only completing that in
>> osdblk_end_request(). Then do a rq_for_each_bio() look in there, and
>> only dequeue if you manage to start an osd request for each of them,
>> THEN moving on to the next request.
> 

There is nothing preventing from issuing a linked bio list. The only thing
is that osd_read/write looks at the first bio for total size.
If the first bio->bi_size does not specify the full length of the chain
then we should add another parameter to osd_read/write for that.

The original idea was to specifically allow chained bios.

Please advise?

> Thanks for the review.  Will fix...
> 
> 	Jeff
> 

Thanks
Boaz
