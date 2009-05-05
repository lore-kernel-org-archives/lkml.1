Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZEEDna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZEEDna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 23:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZEEDnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 23:43:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:52527 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbZEEDnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 23:43:14 -0400
Message-ID: <49FFB55B.9060902@kernel.org>
Date: Tue, 05 May 2009 12:41:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu,
       fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com,
       Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au,
       grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net,
       jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com,
       dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com,
       davem@davemloft.net, rusty@rustcorp.com.au,
       Markus.Lidel@shadowconnect.com, bharrosh@panasas.com,
       Doug Gilbert <dgilbert@interlog.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org> <49FEDAC0.3040503@ru.mvista.com>
In-Reply-To: <49FEDAC0.3040503@ru.mvista.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 05 May 2009 03:40:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
>> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
>> index 7149224..3813a0e 100644
>> --- a/drivers/ide/ide-tape.c
>> +++ b/drivers/ide/ide-tape.c
>> @@ -380,7 +380,7 @@ static int ide_tape_callback(ide_drive_t *drive,
>> int dsc)
>>          }
>>  
>>          tape->first_frame += blocks;
>> -        rq->data_len -= blocks * tape->blk_size;
>> +        rq->resid_len = blk_rq_bytes(rq) - blocks * tape->blk_size;
> 
>    Is it already guaranteed that rq->data_len == blk_rq_bytes(rq) here?

Oops, no.  I'll move it to later ide-cleanup-rq-data_len-usages patch.

Thanks.

-- 
tejun
