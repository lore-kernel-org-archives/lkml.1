Return-Path: <linux-kernel-owner+w=401wt.eu-S1762657AbZD1SKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762657AbZD1SKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZD1SKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:10:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54188 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbZD1SKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:10:04 -0400
Message-ID: <49F74672.2090407@garzik.org>
Date: Tue, 28 Apr 2009 14:09:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Mark Lord <liml@rtr.ca>, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, donari75@gmail.com,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/3] mg_disk: fix CONFIG_LBD=y warning
References: <1240890740-3462-1-git-send-email-tj@kernel.org> <1240890740-3462-3-git-send-email-tj@kernel.org> <49F71E86.7040300@rtr.ca> <200904281728.58209.bzolnier@gmail.com>
In-Reply-To: <200904281728.58209.bzolnier@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Tuesday 28 April 2009 17:19:34 Mark Lord wrote:
>> Tejun Heo wrote:
>>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>
>>> drivers/block/mg_disk.c: In function ‘mg_dump_status’:
>>> drivers/block/mg_disk.c:265: warning: format ‘%ld’ expects type ‘long int’, but
>>> argument 2 has type ‘sector_t’
>>>
>>> [ Impact: kill build warning ]
>>>
>>> Cc: unsik Kim <donari75@gmail.com>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>> ---
>>>  drivers/block/mg_disk.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
>>> index d3e72ad..f389835 100644
>>> --- a/drivers/block/mg_disk.c
>>> +++ b/drivers/block/mg_disk.c
>>> @@ -79,7 +79,7 @@ static void mg_dump_status(const char *msg, unsigned int stat,
>>>  			if (host->breq) {
>>>  				req = elv_next_request(host->breq);
>>>  				if (req)
>>> -					printk(", sector=%ld", req->sector);
>>> +					printk(", sector=%u", (u32)req->sector);
>> ..
>>
>> Eh?  Shouldn't that be fixed the other way around, like this:
>>
>>   +					printk(", sector=%llu", (u64)req->sector);
>>
>> This way, it will still give correct data when sector_t is a u64.
> 
> shouldn't matter, req->sector is never > u32 for mg_disk

It never matters... until the code gets copied elsewhere.  IMO wrong 
code should never be kept -- "impossible to hit" just means it is low 
priority :)

	Jeff



