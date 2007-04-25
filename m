Return-Path: <linux-kernel-owner+w=401wt.eu-S1161835AbXDYHvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161835AbXDYHvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 03:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161836AbXDYHvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 03:51:46 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:19715 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161835AbXDYHvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 03:51:45 -0400
From: Vasily Tarasov <vtaras@openvz.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: OVZDL <devel@openvz.org>
References: <1177422791.435404.4031.nullmailer@me> <20070425065822.GG9715@kernel.dk>
In-Reply-To: <20070425065822.GG9715@kernel.dk>
Subject: Re: [PATCH] cfq: get rid of cfqq hash
Date: Wed, 25 Apr 2007 15:50:27 +0400
Message-Id: <1177501827.988228.3870.nullmailer@me>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -1806,7 +1765,11 @@ static int cfq_may_queue(request_queue_t
>>  	 * so just lookup a possibly existing queue, or return 'may queue'
>>  	 * if that fails
>>  	 */
>> -	cfqq = cfq_find_cfq_hash(cfqd, key, tsk->ioprio);
>> +	cic = cfq_get_io_context_noalloc(cfqd, tsk);
>> +	if (!cic)
>> +		return ELV_MQUEUE_MAY; 
>> +
>> +	cfqq = cic->cfqq[rw & REQ_RW_SYNC];
>>  	if (cfqq) {
>>  		cfq_init_prio_data(cfqq);
>>  		cfq_prio_boost(cfqq);
> 
> Ahem, how well did you test this patch?

Ugh, again: bio_sync() returns not only 0/1
Sorry for giving so much trouble...

BTW, what tests do you use to check patches?
I'll run them on our nodes each time when sending it to you.
At the moment I use some self made tests and a bit fio scripts.

> 
> -- 
> Jens Axboe
