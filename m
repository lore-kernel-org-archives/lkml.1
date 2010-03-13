Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab0CMCML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 21:12:11 -0500
Received: from mail-pz0-f200.google.com ([209.85.222.200]:49147 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab0CMCMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 21:12:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=rDjoTtPOrocwtdT8iYLPvEWz72qhjIQecw46V9KixHkClTvVUgJek/buymBsRZrn7i
         05pswdHcRq36v7v1T/L+ikVu0idhled+OS8jdvIDTNhx1nN9LWoq5bCilV+xcTxIZZhP
         IJcEsY1MfaEeo/2Yq7AVLhpquH9nj15TrnI0U=
MIME-Version: 1.0
In-Reply-To: <1268436844.4471.783.camel@gandalf.stny.rr.com>
References: <40ec3ea41003120732w5f44a2ebq728047e742f32bba@mail.gmail.com>
	 <1268436844.4471.783.camel@gandalf.stny.rr.com>
Date: Fri, 12 Mar 2010 21:12:06 -0500
X-Google-Sender-Auth: 7872aa2d635ce978
Message-ID: <40ec3ea41003121812j7cb349e4g1c455ae096da35cd@mail.gmail.com>
Subject: Re: Using tracing_off() in __schedule_bug()
From: Chase Douglas <chase.douglas@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 6:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2010-03-12 at 10:32 -0500, Chase Douglas wrote:
>> We're considering using tracing_off() in __schedule_bug() in the
>> Ubuntu kernel to help us solve "scheduling while atomic" bugs without
>> needing to compile and install a special kernel to do so. Using the
>> tracing_off() call enables us to generate smaller function traces when
>> debugging, and find the bug easier since it should be at the end of
>> any traces. The patch we are thinking of using can be found at [1].
>> You can find an overview of how bugs are solved using this approach
>> there as well.
>>
>> Are there any thoughts as to the appropriateness of this patch in
>> Ubuntu kernels? My guess is that this isn't done in the upstream
>> vanilla kernels because it would be annoying to have a stock kernel
>> littered with tracing_off() calls if you hit one when you weren't
>> meaning to. However, we're interested in hearing if there's some
>> negative consequence we haven't thought of.
>
> Actually, it has been on my TODO list to litter tracing_off() all over
> the kernel ;-)
>
> No, by all means, I would definitely take a patch that turn off tracing
> at critical areas. One of which I would like to do is with the BUG()
> call.

Sounds good to me. The only place I currently see tracing_off called
is in oops_enter.

> Hmm, thinking about it more, I would rather have a separate function,
> that would call tracing_off() if some variable is set. By default it
> would be set, but in case you want to keep tracing after a bug is hit,
> you can have a way to disable it.
>
> I need to write up a patch soon. Thanks for bring this up.

I'd be happy to help out in this endeavor if you'd like. I'm wondering
if there shouldn't be multiple levels of tracing_off support specified
at boot time (disabled on WARNING, BUG, __schedule_bug, OOPS) in an
ordered priority way. I.e. tracing_off_bug would leave tracing on for
WARNING's, but turn it off for BUG's, schedule bugs, and oopses. The
default would be tracing_off_warn, which would call tracing_off on all
of the above.

Your thoughts?

-- Chase
