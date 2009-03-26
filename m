Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbZCZHl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbZCZHl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZCZHls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:41:48 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:54344 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbZCZHlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cucI7acfLZ1Mup0zYt8b3Hxb/Ga+SLzX/16qkZvRktto4BOCxiDj5oL496vHRbJQ/c
         L+q5BEHd6luDeLib6Lz9qiIzEezJom42fHSSEH3oAxCTTLNKmQhvb5RjCioyPIR9RvEQ
         GBuxch23Khk+3oehL9yLGOfjkPcPNRB49H2r4=
Message-ID: <49CB31DB.2040608@gmail.com>
Date: Thu, 26 Mar 2009 16:42:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 03/14] block: implement blk_rq_map_kern_prealloc()
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <1237910776-10983-4-git-send-email-tj@kernel.org> <49CA4B4B.50408@panasas.com> <49CAE425.5050009@kernel.org>
In-Reply-To: <49CAE425.5050009@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A few issues.

Tejun Heo wrote:
>> Perhaps you could reorder the code below a bit?
>>
>> My proposal is:
>> * blk_rq_map_kern_prealloc => is simplified to be
>>     int blk_rq_map_bio(struct request_queue *q, struct request *rq,
>> 		       struct bio *bio);

The thing is that the prealloc variant should be allowed to be called
from IRQ context and blk_queue_bounce() shouldn't be called.
Hmmm... well, the caller is supposed to know what it's doing and maybe
we can just add a comment that it shouldn't be called with buffers
which might get bounced from IRQ context.

>> * The extra checks currently inside blk_rq_map_kern_prealloc are moved
>>   to bio_map_kern_prealloc()
>>
>> * Users call bio_map_kern_prealloc() directly and then use blk_rq_map_bio()
>>   in a two stage process.

This breaks consistency with blk_rq_map_*() family of functions.  Do
you have a plan to make them all consistent?  I think we really need
to maintain API consistency.

Thanks.

-- 
tejun
