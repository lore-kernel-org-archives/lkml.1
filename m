Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab0BGU1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 15:27:00 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:41863 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab0BGU06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 15:26:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YmbVzFbij39QmA2Ksp1lEhLZJuIURSupdHFmtqGUTodv0zz0ZSqlHqbN1iq1antjcL
         1GgsShy6hLWYptmIMGsXwYMOimANULBXgptrrqEJRzx0yHgJ4l4cpIoefkUgg4FZIhSa
         80invTXMmCln2AR9cjX7B33HbGnw979sY2ERQ=
MIME-Version: 1.0
In-Reply-To: <1265572738.12224.278.camel@laptop>
References: <10f740e81002071157p11b78784i8091d4790c29f30d@mail.gmail.com>
	 <1265572738.12224.278.camel@laptop>
Date: Sun, 7 Feb 2010 21:26:57 +0100
X-Google-Sender-Auth: 4ceaa3e3c334726d
Message-ID: <10f740e81002071226g3290d276q4c9df0e79a1e7ac0@mail.gmail.com>
Subject: Re: [PATCH] sched: Fix unused variable warning on UP (was: Re: 
	linux-next: tip tree build warning)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 7, 2010 at 20:58, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, 2010-02-07 at 20:57 +0100, Geert Uytterhoeven wrote:
>> On Mon, Feb 1, 2010 at 08:12, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > Today's linux-next build (powerpc allnoconfig) produced this warning:
>> >
>> > kernel/sched.c: In function 'wake_up_new_task':
>> > kernel/sched.c:2631: warning: unused variable 'cpu'
>> >
>> > Introduced by commit fabf318e5e4bda0aca2b0d617b191884fda62703 ("sched:
>> > Fix fork vs hotplug vs cpuset namespaces").
>>
>> And now we have it in 2.6.33-rc7, too...
>> Patch below (FWIW, compile-tested on m68k with CONFIG_SMP=n only).
>>
>> ---
>> From cbf4f334632ade9c5ed9b88728ec82af074e4ace Mon Sep 17 00:00:00 2001
>> From: Geert Uytterhoeven <geert@linux-m68k.org>
>> Date: Sun, 7 Feb 2010 20:47:30 +0100
>> Subject: [PATCH] sched: Fix unused variable warning on UP
>>
>> Fix warning
>>
>> | kernel/sched.c:2650: warning: unused variable 'cpu'
>>
>> if CONFIG_SMP is not set.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>  kernel/sched.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 3a8fb30..c47561e 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -2647,9 +2647,10 @@ void wake_up_new_task(struct task_struct *p,
>> unsigned long clone_flags)
>>  {
>>       unsigned long flags;
>>       struct rq *rq;
>> -     int cpu = get_cpu();
>>
>>  #ifdef CONFIG_SMP
>> +     int cpu = get_cpu();
>> +
>>       /*
>>        * Fork balancing, do it here and not earlier because:
>>        *  - cpus_allowed can change in the fork path
>
> Which introduces a preempt imbalance... I like akpm's fix much better.

Bummer, you're right. Sorry, that teaches me not to write patches
after 2 days of FOSDEM ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
