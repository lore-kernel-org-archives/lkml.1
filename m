Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZFHI4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZFHI4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZFHI4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:56:41 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:33678 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbZFHI4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jIWad/hN5uJ2laOkTPkvgOs3xWe9P84/RkNN2bdwhxjfpUlbUaqW0F69HlfaIfmD/u
         5fpmYBwgB0zO5MOYjTxIhyR0Zt0WwFdiHTYmJUYoS5vCe5LNQ0AejRW1yf0+kqmtsZPp
         yeaAzu1UF4lG26OdFFKwRvTpTohwFl1Djtebc=
MIME-Version: 1.0
In-Reply-To: <20090608084611.GD6372@elte.hu>
References: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com>
	 <20090608081439.GB6372@elte.hu>
	 <a8e1da0906080137r179b0a5l81bb604fd64800d3@mail.gmail.com>
	 <20090608084611.GD6372@elte.hu>
Date: Mon, 8 Jun 2009 16:56:39 +0800
Message-ID: <a8e1da0906080156g29ebee6fv446b488f4d55d1a1@mail.gmail.com>
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

On Mon, Jun 8, 2009 at 4:46 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> On Mon, Jun 8, 2009 at 4:14 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> >
>> > * Dave Young <hidave.darkstar@gmail.com> wrote:
>> >
>> >> Add a halt_delay module parameter in printk.c used to read the
>> >> printk messages in halt/poweroff/restart phase, delay each printk
>> >> messages by halt_delay milliseconds. It is useful for debugging if
>> >> there's no other way to dump kernel messages that time.
>> >>
>> >> The halt_delay max value is 65535, default value is 0, change it
>> >> by:
>> >>
>> >> echo xxx > /sys/module/printk/parameters/halt_delay
>> >>
>> >> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> >> ---
>> >> Documentation/kernel-parameters.txt |    5 +++++
>> >> kernel/printk.c                     |   17 +++++++++++++++++
>> >> 2 files changed, 22 insertions(+)
>> >>
>> >> --- linux-2.6.orig/kernel/printk.c    2009-06-08 13:55:35.000000000 +0800
>> >> +++ linux-2.6/kernel/printk.c 2009-06-08 13:56:23.000000000 +0800
>> >> @@ -250,6 +250,22 @@ static inline void boot_delay_msec(void)
>> >>  }
>> >>  #endif
>> >>
>> >> +/* msecs delay after each halt/poweroff/restart phase printk,
>> >> + unsigned short is enough for delay in milliseconds */
>> >> +static unsigned short halt_delay;
>> >> +
>> >> +static inline void halt_delay_msec(void)
>> >> +{
>> >> +     if (unlikely(halt_delay == 0 || !(system_state == SYSTEM_HALT
>> >> +                             || system_state == SYSTEM_POWER_OFF
>> >> +                             || system_state == SYSTEM_RESTART)))
>> >> +             return;
>> >
>> > This is a tiny bit ugly (and goes into the vprintf path) but i
>> > can see no other way either - a system_state > SYSTEM_RUNNING
>> > check would needlessly include the suspend-to-disk state (which
>> > we dont want to include here).
>>
>> Can we move suspend-to-disk before halt state?
>
> Yes, we could do that - if all system_state uses are checked for
> side-effects - in particular comparisons. We have a few places that
> do 'if (system_state > SYSTEM_RUNNING)' - to designate 'shutdown
> state'. Now, if we have any use of > SYSTEM_SHUTDOWN that might
> break from such a reordering.
>
> I wouldnt expect such usage really, but it has to be checked. That
> would make this patch quite a bit cleaner.
>
> Mind sending a followup delta patch with this cleanup?

I'm glad to check the system_state usage, then write a followup patch.

>
>        Ingo
>



-- 
Regards
dave
