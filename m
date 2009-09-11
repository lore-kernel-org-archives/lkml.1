Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZIKDfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZIKDfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 23:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZIKDfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 23:35:50 -0400
Received: from mail-pz0-f184.google.com ([209.85.222.184]:40645 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZIKDft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 23:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HKAUnPSKtHuYCy8UqKuuSRdAOoCHThaWPdhgMGdh4p+NHFe7xH4gHG12N4AzGYRF1F
         52gBMSIhKIQEPtsCUTIU6vsNJiNHUn6Usz5P7KBNUMUSv1yXh03LqnmX/6k7dkeFAGDt
         wRPTOdHSI9OgFaNaKHN7CzG0p2IWLxq0zyCmo=
MIME-Version: 1.0
In-Reply-To: <1252620938.7319.3.camel@localhost.localdomain>
References: <af3ea28a0909090035t710f5895i135760a2c7bd8a02@mail.gmail.com>
	 <1252537622.9883.24.camel@localhost.localdomain>
	 <af3ea28a0909100107q328d1288x8d677d4d5f79f728@mail.gmail.com>
	 <2674af740909100231x582851dbv9b71bc2914be7030@mail.gmail.com>
	 <1252620938.7319.3.camel@localhost.localdomain>
Date: Fri, 11 Sep 2009 11:35:53 +0800
Message-ID: <af3ea28a0909102035r5b39f3f5he8885996cf55fa65@mail.gmail.com>
Subject: Re: [PATCH] update clocksource raw_time in timekeeping_suspend
From: ye janboe <janboe.ye@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, zippel@linux-m68k.org,
       akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So CLOCK_MONOTONIC_RAW is not suitable for getting real hw time which
includes sleep time.

Is there other timer suitable for this?

Thanks

2009/9/11 john stultz <johnstul@us.ibm.com>:
> On Thu, 2009-09-10 at 17:31 +0800, Yong Zhang wrote:
>> On Thu, Sep 10, 2009 at 4:07 PM, ye janboe <janboe.ye@gmail.com> wrote:
>> > hi, John
>> >
>> > Thanks for your comments.
>> >
>> > After sent this patch, I realize that this patch exposes the hardware
>> > detail ugly in common code.
>> >
>> > In embed system, user space apps need to have a method to get the
>> > right time which will not be impacted by NTP and suspend.
>> >
>> > Yes, you are right. I want to add sleep_length to the raw time and
>> > user space apps could get the right time after suspend.
>> >
>>
>> What I get from the code is that CLOCK_MONOTONIC doesn't consider
>> sleep_length either. Do I miss something?
>
> You're quite right. I forgot we drop sleep_length from
> wall_to_monotonic, so it should not increase while we're suspended.
>
> Janboe: So I think things are fine as they stand. No patch necessary.
>
> But please let me know if I'm yet again forgetting something or you're
> finding CLOCK_MONOTONIC_RAW to be insufficient in some way.
>
> thanks
> -john
>
>
