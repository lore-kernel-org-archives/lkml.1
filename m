Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbYKCQUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbYKCQUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 11:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbYKCQUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 11:20:10 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:23191 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbYKCQUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 11:20:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Xen3F2dYB6XF0bnM6W7h0tfl6gYGMsHOwlWRYzVnqpgVcfgYrNqCZBiJIPngxbsL+F
         sXd/1+gGKYAb+OUdjtEpXuPAn2OqzweZaPm2k6nM0MS+k2FLpIcblKOyDaYiPdyphchK
         NTRVRTAdd0JHHVOgLHQD7l9jjEx0HVV6BQZac=
Message-ID: <bc64b4640811030820j660b8386x39bf2285b1dba887@mail.gmail.com>
Date: Mon, 3 Nov 2008 19:20:06 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH] power_supply: only register tosa_battery driver on tosa
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081103145514.GA23466@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com>
	 <bc64b4640811021236t3458bf69vd1becc4ab1133be1@mail.gmail.com>
	 <20081103145514.GA23466@oksana.dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/3 Anton Vorontsov <avorontsov@ru.mvista.com>:
> On Sun, Nov 02, 2008 at 11:36:08PM +0300, Dmitry wrote:
>> 2008/10/29 Dmitry Baryshkov <dbaryshkov@gmail.com>:
>> > There are already several wm97xx-battery drivers. Do register the tosa one
>> > only on tosa machines.
>> >
>> > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
>> > ---
>> >  drivers/power/tosa_battery.c |    3 +++
>> >  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> What about this patch?
>
> Sorry for the delay.
>
>> IMO it can and should be merged during 2.6.28-rc cycle.
>>
>> diff --git a/drivers/power/tosa_battery.c b/drivers/power/tosa_battery.c
>> index 2eab35a..4e52c22 100644
>> --- a/drivers/power/tosa_battery.c
>> +++ b/drivers/power/tosa_battery.c
>> @@ -469,6 +469,9 @@ static struct platform_driver tosa_bat_driver = {
>>
>>  static int __init tosa_bat_init(void)
>>  {
>> +     if (!machine_is_tosa())
>> +             return -EINVAL;
>> +
>
> I tend to reject this approach. You should rename the driver instead.
>
> I.e.
> -.driver.name    = "wm97xx-battery",
> -.driver.name    = "tosa-battery",
>
> And make sure that this won't break users of that driver (though
> I don't see any).

The wm97xx-battery device is registered by
drivers/input/toucscreen/wm97xx-core.c

>
>>       return platform_driver_register(&tosa_bat_driver);
>>  }
>
> Thanks,
>
> --
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2
>



-- 
With best wishes
Dmitry
