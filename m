Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZFHH3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZFHH3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZFHH3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:29:30 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35920 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZFHH3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:29:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vmm+W+FA8vqdvvjkWdSq+TI6SE1caeqK+fcwcMsbg+cj8JGyjK4bGgREmJvfFbze5C
         mhKNZxKTWi2A1z5I6QJbajHVzmcbRC12hQ/I8MNeeHnP5EIN1KNMYp/Ha8XQbbO+lA3X
         7k5HW3Fvh+L2+or5JDVZ/RteGrwA+y6bIhcg4=
MIME-Version: 1.0
In-Reply-To: <20090607143221.GE21340@elte.hu>
References: <a8e1da0906022009q4a6cf385t83c202e79f962b12@mail.gmail.com>
	 <20090607143221.GE21340@elte.hu>
Date: Mon, 8 Jun 2009 15:29:30 +0800
Message-ID: <a8e1da0906080029n28699e6ctea4a2cf452f7459@mail.gmail.com>
Subject: Re: [PATCH v2] printk: add halt_delay parameter for printk delay in 
	halt phase
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 7, 2009 at 10:32 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> Add a halt_delay module parameter in printk.c used to read the printk
>> messages in halt/poweroff/restart phase, delay each printk messages
>> by halt_delay milliseconds. It is useful for debugging if there's no
>> other way to dump kernel messages that time.
>>
>> The halt_delay max value is 65535, default value is 0, change it by:
>>
>> echo xxx > /sys/module/printk/parameters/halt_delay
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> ---
>> kernel/printk.c |   16 ++++++++++++++++
>> 1 file changed, 16 insertions(+)
>>
>> --- linux-2.6.orig/kernel/printk.c    2009-06-03 10:16:55.000000000 +0800
>> +++ linux-2.6/kernel/printk.c 2009-06-03 10:32:43.000000000 +0800
>> @@ -250,6 +250,22 @@ static inline void boot_delay_msec(void)
>>  }
>>  #endif
>>
>> +/* msecs delay after each halt/poweroff/restart phase printk,
>> +unsigned short is enough for delay in milliseconds */
>> +static unsigned short halt_delay;
>> +
>> +static inline void halt_delay_msec(void)
>> +{
>> +     if (unlikely(halt_delay == 0 || !(system_state == SYSTEM_HALT
>> +                             || system_state == SYSTEM_POWER_OFF
>> +                             || system_state == SYSTEM_RESTART)))
>> +             return;
>> +
>> +     mdelay(halt_delay);
>> +}
>> +
>> +module_param(halt_delay, ushort, S_IRUGO | S_IWUSR);
>> +
>>  /*
>>   * Commands to do_syslog:
>>   *
>> @@ -649,6 +665,7 @@ asmlinkage int vprintk(const char *fmt,
>>       char *p;
>>
>>       boot_delay_msec();
>> +     halt_delay_msec();
>>
>>       preempt_disable();
>>       /* This stops the holder of console_sem just where we want him */
>
> Looks nice now - but please also add a description to
> Documentation/kernel-parameters.txt.

Oops, will add in v3

>
> Thanks,
>
>        Ingo
>



-- 
Regards
dave
