Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbZDGEhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbZDGEhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZDGEhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:37:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:49195 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZDGEhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fXkNXv+8LTq6dkRargfLEDAZERdH/kqFgxlbHmJNDzWaGm/1ARqF/9Hgq6Ly8l8jkh
         iKMsr/MhIYGAU3eLpusY9GJCgrzOP5SmPw/BD7Lk5H2zul8BBDjb6Ugbq74aH7JpQr8d
         nC027mJydDf/4Dqtjb/LfdJUg+61uA4qa3ZDQ=
MIME-Version: 1.0
In-Reply-To: <1239067616.4753.12.camel@localhost.localdomain>
References: <49b7c2350904060702j3f725a45ub5e7d3ee3af883c1@mail.gmail.com>
	 <49b7c2350904060717l1a87cca7p880b6843ea92c702@mail.gmail.com>
	 <1239067616.4753.12.camel@localhost.localdomain>
Date: Tue, 7 Apr 2009 13:37:17 +0900
Message-ID: <49b7c2350904062137p46661ad8s11c9c2a31e367329@mail.gmail.com>
Subject: Re: [PATCH] Update old Mini-HOWTO for ftrace
From: GeunSik Lim <leemgs1@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, rt-users <linux-rt-users@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > What's the chrt for?
 We often need simple test to get  latency result  of realtime using
"current_tracers" file.
 In this case, We can run easy testcase as realtime task with the chrt command.

 Although we usually use function tracer for tracing internal kernel
functions by ftraced.
 I think that we need simple example like the chrt for monitoring
latencies and the kernel
functoins using sleep command as realtime task.


2009/4/7 Steven Rostedt <srostedt@redhat.com>:
>
> On Mon, 2009-04-06 at 23:17 +0900, GeunSik Lim wrote:
>> I attached patch file again because no-operation is changed
>> from "none"word to "nop" word.
>>
>> for example,
>> -       "wakeup preemptirqsoff preemptoff irqsoff ftrace sched_switch none\n\n"
>> +       "wakeup preemptirqsoff preemptoff irqsoff function sched_switch nop\n\n"
>>
>> ./trace_nop.c:struct tracer nop_trace __read_mostly =
>>       .name   = "nop",
>>       .init           = nop_trace_init,
>>       .reset  = nop_trace_reset,
>>       .selftest       = trace_selftest_startup_nop,
>>       .flags  = &nop_flags,
>>       .set_flag       = nop_set_flag
>>
>>
>>
>> 2009/4/6 GeunSik Lim <leemgs1@gmail.com>:
>> >   Dear Steven,
>> >
>> >   The author of ftrace(Internal kernel Function Tracer) feature
>> > renamed the ftrace tracer
>> >    to function to avoid further confusion between the ftrace
>> > infrastructure and the
>> >    function tracer on Oct-20, 2008.
>> >
>> >    But, Update of Mini-HOWTO document are still not working
>> >    .
>> >    Most of the developers often utilize "/debug/tracing/README" file
>> > as Mini-HOWTO.
>> >    They will confuse definition and usage about ftrace  between
>> > README(ftrace) file
>> >    and available_tracers(function) file after linux-2.6.27 like me.
>> >    And, I want you to append "chrt -f 5 sleep 1" command as simple
>> > example for latency.
>> >
>> >    Signed-off-by: GeunSik Lim <leemgs1@gmail.com>
>> >    Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>> >    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> > ---
>> >  kernel/trace/trace.c |    3 ++-
>> >  1 files changed, 2 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> > index a0174a4..15f0eec 100644
>> > --- a/kernel/trace/trace.c
>> > +++ b/kernel/trace/trace.c
>> > @@ -2358,7 +2358,7 @@ static const char readme_msg[] =
>> >        "# mkdir /debug\n"
>> >        "# mount -t debugfs nodev /debug\n\n"
>> >        "# cat /debug/tracing/available_tracers\n"
>> > -       "wakeup preemptirqsoff preemptoff irqsoff ftrace sched_switch none\n\n"
>> > +       "wakeup preemptirqsoff preemptoff irqsoff function
>> > sched_switch none\n\n"
>> >        "# cat /debug/tracing/current_tracer\n"
>> >        "none\n"
>> >        "# echo sched_switch > /debug/tracing/current_tracer\n"
>> > @@ -2368,6 +2368,7 @@ static const char readme_msg[] =
>> >        "noprint-parent nosym-offset nosym-addr noverbose\n"
>> >        "# echo print-parent > /debug/tracing/trace_options\n"
>> >        "# echo 1 > /debug/tracing/tracing_enabled\n"
>> > +       "# chrt -f 5 sleep 1\n"
>
>
> What's the chrt for?
>
> -- Steve
>
>
>



-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
