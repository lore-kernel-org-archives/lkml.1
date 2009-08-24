Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbZHXQmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbZHXQmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZHXQmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:42:16 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59415 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbZHXQmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:42:13 -0400
Date: Mon, 24 Aug 2009 18:42:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: Re: [PATCH 4/7] libata: use lazy workqueues for the pio task
Message-ID: <20090824164214.GO12579@kernel.dk>
References: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com> <1251100616-28604-5-git-send-email-jens.axboe@oracle.com> <4A92C081.50207@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A92C081.50207@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24 2009, Jeff Garzik wrote:
> On 08/24/2009 03:56 AM, Jens Axboe wrote:
>> Signed-off-by: Jens Axboe<jens.axboe@oracle.com>
>> ---
>>   drivers/ata/libata-core.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index 072ba5e..35f74c9 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -6580,7 +6580,7 @@ static int __init ata_init(void)
>>   {
>>   	ata_parse_force_param();
>>
>> -	ata_wq = create_workqueue("ata");
>> +	ata_wq = create_lazy_workqueue("ata");
>>   	if (!ata_wq)
>>   		goto free_force_tbl;
>
> No objections to the code, operationally...
>
> But it is disappointing that the "1 thread on UP" problem is not solved  
> while changing this libata area.  Is there no way to specify a minimum  
> lazy-thread count?
>
> A key problem continues to be tying to the number of CPUs, which is  
> quite inappropriate for libata.

We'll solve that next, the first problem is reducing the per-cpu
threads. Lots of places use per-cpu workqueues because that is what is
available, not necessarily because it's an appropriate choice. Like the
ata_wq above, it's not even a good fit.

-- 
Jens Axboe

