Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbZGIAsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbZGIAsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 20:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbZGIAsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 20:48:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:38566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811AbZGIAsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 20:48:06 -0400
Message-ID: <4A553E36.8060006@kernel.org>
Date: Thu, 09 Jul 2009 09:47:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Niel Lambrechts <niel.lambrechts@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/4] block: implement mixed merge of different failfast
 requests
References: <1246610898-22350-1-git-send-email-tj@kernel.org> <1246610898-22350-4-git-send-email-tj@kernel.org> <4A507203.8020001@panasas.com>
In-Reply-To: <4A507203.8020001@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Jul 2009 00:47:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Boaz Harrosh wrote:
>> @@ -1165,6 +1165,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
>>  	const unsigned short prio = bio_prio(bio);
>>  	const int sync = bio_sync(bio);
>>  	const int unplug = bio_unplug(bio);
>> +	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
> 
> Perhaps a bio_fail_fast(bio)
> and also an blk_failfast(rq).

Me not being a big fan of those simple accessors, I want to avoid
adding those especially the use of bio ones are mostly confined to
block layer proper.

Thanks.

-- 
tejun
