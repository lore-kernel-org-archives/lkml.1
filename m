Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZERBk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZERBk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 21:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZERBkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 21:40:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:43490 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZERBkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 21:40:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dZcI0aQTQSWjUpXGCR6uzfKXrlWyGbWnOVXPvvLPKwaeBOXvfLOXJ0dRt5TEt4+a76
         /zQdk1aHhIP1YXw0FcYeM+xZFVpUWNu/V4k9AWqYwUkSn6lYp3oYnA2cZ2OHPxNh/40m
         k3Yd0pxvZ5Et6wl1pCn9WTILcP/JJ90PV4YN8=
MIME-Version: 1.0
In-Reply-To: <4A10B1B4.5080309@cn.fujitsu.com>
References: <1242545498-7285-1-git-send-email-tom.leiming@gmail.com>
	 <4A10B1B4.5080309@cn.fujitsu.com>
Date: Mon, 18 May 2009 09:40:14 +0800
Message-ID: <d82e647a0905171840v58eed575s2ce2dd6914f5479@mail.gmail.com>
Subject: Re: [PATCH] ftrace:fix check for return value of register_module_notifier
From: Ming Lei <tom.leiming@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/18 Li Zefan <lizf@cn.fujitsu.com>:
> tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> return zero should be correct, so fix it.
>>
>
> Nice catch.
>
> We have those bogus warnings:
>
>  $ dmesg | grep Failed
>  Failed to register trace ftrace module notifier
>  Failed to register trace events module notifier
>
> Could you fix the same bug in event_trace_init()?

OK, I'll submit it later.

>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> ---
>>  kernel/trace/ftrace.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index 5b606f4..140699a 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -2826,7 +2826,7 @@ void __init ftrace_init(void)
>>                                 __stop_mcount_loc);
>>
>>       ret = register_module_notifier(&ftrace_module_nb);
>> -     if (!ret)
>> +     if (ret)
>>               pr_warning("Failed to register trace ftrace module notifier\n");
>>
>>       return;
>



-- 
Lei Ming
