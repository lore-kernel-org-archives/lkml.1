Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZFHIhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZFHIhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZFHIhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:37:35 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:63206 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZFHIhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hiyNQCfADa4539MRjLlEG+A0S71bEUfyH08EKoDnh8/Gx/VuER2F2u5L0BRtzWdT53
         ns5P6y5ok8BkpnLWfCiXaCai0S3GGXBeHLW6pxX9WJwAL3Ac9dNiRPZG//lcRkE47aA3
         l3r7bL9t0cAM+SlE38tX1vwjwpnWftsZKFXuo=
MIME-Version: 1.0
In-Reply-To: <20090608081439.GB6372@elte.hu>
References: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com>
	 <20090608081439.GB6372@elte.hu>
Date: Mon, 8 Jun 2009 16:37:35 +0800
Message-ID: <a8e1da0906080137r179b0a5l81bb604fd64800d3@mail.gmail.com>
Subject: Re: [PATCH v3] printk: add halt_delay parameter for printk delay in 
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

On Mon, Jun 8, 2009 at 4:14 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> Add a halt_delay module parameter in printk.c used to read the
>> printk messages in halt/poweroff/restart phase, delay each printk
>> messages by halt_delay milliseconds. It is useful for debugging if
>> there's no other way to dump kernel messages that time.
>>
>> The halt_delay max value is 65535, default value is 0, change it
>> by:
>>
>> echo xxx > /sys/module/printk/parameters/halt_delay
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> ---
>> Documentation/kernel-parameters.txt |    5 +++++
>> kernel/printk.c                     |   17 +++++++++++++++++
>> 2 files changed, 22 insertions(+)
>>
>> --- linux-2.6.orig/kernel/printk.c    2009-06-08 13:55:35.000000000 +0800
>> +++ linux-2.6/kernel/printk.c 2009-06-08 13:56:23.000000000 +0800
>> @@ -250,6 +250,22 @@ static inline void boot_delay_msec(void)
>>  }
>>  #endif
>>
>> +/* msecs delay after each halt/poweroff/restart phase printk,
>> + unsigned short is enough for delay in milliseconds */
>> +static unsigned short halt_delay;
>> +
>> +static inline void halt_delay_msec(void)
>> +{
>> +     if (unlikely(halt_delay == 0 || !(system_state == SYSTEM_HALT
>> +                             || system_state == SYSTEM_POWER_OFF
>> +                             || system_state == SYSTEM_RESTART)))
>> +             return;
>
> This is a tiny bit ugly (and goes into the vprintf path) but i can
> see no other way either - a system_state > SYSTEM_RUNNING check
> would needlessly include the suspend-to-disk state (which we dont
> want to include here).

Can we move suspend-to-disk before halt state?

>
> In theory we could turn system_state into a bitmask and have a
> print_delay_mask check instead of these flags ... but that is a far
> wider change and i'm not sure it's a net step forwards.
>
> I've applied your patch to tip:core/printk with small edits to the
> changelog - Linus & Andrew is Cc:ed, should they have any
> objections.
>
>        Ingo
>



-- 
Regards
dave
