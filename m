Return-Path: <linux-kernel-owner+w=401wt.eu-S1759806AbZELENX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806AbZELENX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 00:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZELELj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 00:11:39 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:40380 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbZELELi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 00:11:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YshIz5Ut51YVGIDAWpl9LmIAWV2dSNCfuM/23a84vrmXyeNKDGXlCoiSEFf4xpLqcM
         GenBv3dfQZgvsZNmsl15ZQT2kKlXSLvT+4Fp7TnPDhkByjNp1xxbvrswFzNtndA08r5f
         3jFLppjph5eGcjz7lMudhhgG6+aCarCjm/I78=
MIME-Version: 1.0
In-Reply-To: <1239293911.4529.7144.camel@localhost.localdomain>
References: <49DE0C36.4070507@ti.com>
	 <1239293911.4529.7144.camel@localhost.localdomain>
Date: Tue, 12 May 2009 12:11:38 +0800
Message-ID: <af3ea28a0905112111r1fa73a84j4cf9604d53288bb@mail.gmail.com>
Subject: Re: [PATCH] Allow deferrable timers for intervals tv2-tv5 to be 
	deferred
From: ye janboe <janboe.ye@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Jon Hunter <jon-hunter@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Jon, Venki

This patch is same as Jouni Hogander's which has been acked by Venki
at 30 Jun 2008.
http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-06/msg11866.html

why Jouni Hogander's patch could not be accepted by LKML?

Thanks

Janboe

2009/4/10 Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>:
> On Thu, 2009-04-09 at 07:54 -0700, Jon Hunter wrote:
>> In the current kernel implementation only kernel timers for time
>> interval tv1 are being deferred. This patch allows any timer that is
>> configured as deferrable to be defer regardless of time interval.
>>
>> This patch was previously discussed on another the thread [1] and Ack'ed
>>   by Venki Pallipadi the author of the original deferrable timer patch.
>>
>> Venki, could you also ack this patch for confirmation?
>>
>> Cheers
>> Jon
>>
>> [1] http://marc.info/?l=linux-kernel&m=123196343531966&w=2
>>
>>
>
> Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>
>> Signed-off-by: Jon Hunter <jon-hunter@ti.com>
>> ---
>>   kernel/timer.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/timer.c b/kernel/timer.c
>> index b455556..6ab6e96 100644
>> --- a/kernel/timer.c
>> +++ b/kernel/timer.c
>> @@ -1012,6 +1012,9 @@ cascade:
>>               index = slot = timer_jiffies & TVN_MASK;
>>               do {
>>                       list_for_each_entry(nte, varp->vec + slot, entry) {
>> +                             if (tbase_get_deferrable(nte->base))
>> +                                     continue;
>> +
>>                               found = 1;
>>                               if (time_before(nte->expires, expires))
>>                                       expires = nte->expires;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
