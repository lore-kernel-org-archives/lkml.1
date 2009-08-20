Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbZHTMsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbZHTMsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZHTMsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:48:13 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60461 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371AbZHTMsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:48:12 -0400
Date: Thu, 20 Aug 2009 14:48:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       htejun@gmail.com, bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 4/6] libata: use lazy workqueues for the pio task
Message-ID: <20090820124813.GM12579@kernel.dk>
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com> <1250763604-24355-5-git-send-email-jens.axboe@oracle.com> <4A8D4458.5060206@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8D4458.5060206@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20 2009, Stefan Richter wrote:
> Jens Axboe wrote:
>> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>> ---
>>  drivers/ata/libata-core.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index 072ba5e..35f74c9 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -6580,7 +6580,7 @@ static int __init ata_init(void)
>>  {
>>  	ata_parse_force_param();
>>  -	ata_wq = create_workqueue("ata");
>> +	ata_wq = create_lazy_workqueue("ata");
>>  	if (!ata_wq)
>>  		goto free_force_tbl;
>>  
>
> However, this does not solve the issue of lacking parallelism on UP  
> machines, does it?

No, the next step is needed there, having multiple threads. Pretty
similar to what Frederic described. Note that the current implementation
doesn't really solve that either, since work will be executed on the CPU
it is queued on. So there's no existing guarantee that it works, on UP
or SMP. This implementaion doesn't modify that behaviour, it's identical
to the current workqueue implementation in that respect.

-- 
Jens Axboe

