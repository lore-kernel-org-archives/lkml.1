Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbZDOGSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbZDOGSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZDOGRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:17:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54439 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZDOGRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:17:51 -0400
Message-ID: <A9824EB551AA41DD8383638D3C305A66@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Frederic Weisbecker" <fweisbec@gmail.com>
Cc: <kosaki.motohiro@jp.fujitsu.com>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Tom Zanussi" <tzanussi@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, "Oleg Nesterov" <oleg@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com>
Subject: Re: [PATCH v2 5/4] ftrace, workqueuetrace: display work name
Date: Wed, 15 Apr 2009 14:17:23 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3F6I4qu016570

* From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
> Hi
> 
>> Kosaki-san,
>> 
>> Perhaps you misunderstood me, which is easy because my english is
>> evil ;-)
> 
> hehe, my english is poor much than you ;)
> 
> 
>> We have to distinguish event tracing and statistical/histogram tracing
>> here.
>> 
>> Event tracing is about logging the events when they come and store
>> them one by one to output them later. That's what does TRACE_EVENT
>> for instance.
>> 
>> Statistical tracing doesn't store a trace of each event but instead
>> update some numbers after each event: number of events, maximum
>> latency, average, etc...
> 
> Agreed.
> 
> 
>> About event tracing, we want to have something that let us identifying
>> the events individually. For the works it can be either the function
>> embedeed in the work, or the work itself.
>> But do we need both? Since it's rare that a function can be embedeed in
>> more than two works, I guess we only need one of those informations.
>> Which one is the more efficient to identify a work? That can be discussed
>> actually.
> 
> OK. I think function name is enough. I'll drop this patch.
> 
> And also function name has another benefit.
> symbol name is module unload safe. then we don't need to care
> module unloading.
> 
> In the other hand, work_struct variable is often static variable.
> it mean the variable name is often very short.
> 
> 
>> When I talked about per-work tracing, it was in a generic way. What do we
>> use to identify each work individually: either the function or the work
>> name? Both seems accurate for that actually, the fact is that both can
>> be used for per-work tracing.
>> 
>> Actually my previous mails were focused on statistical tracing.
>> 
>> You proposed something that would result in the following final view:
>> 
>> workqueue_name:pid n_inserted n_executed cpu max_latency
>> 
>> And then by looking at the trace file, we can retrieve the work/function
>> that produced this max latency.
>> 
>> While I proposed this another idea:
>> 
>> workqueue_name:pid n_inserted n_executed cpu
>> 
>> work1 latency_avg latency_max
>> work2 latency_avg latency_max
>> work3 latency_avg latency_max
>> .....
>> 
>> (We can have it with one file per workqueue).
>> work1 can be either the work name or the function executed though
>> the function is probably the main focus here because it's the
>> real source culprit.
>> But we can also output work_name:func
>> 
>> You see? With such output we see immediately which works are creating the
>> worst latencies.
>> And the event tracing is still very helpful here to have a more
>> fine grained tracing and see the behaviour of some works more precisely.
>> 
>> That's a kind of tracing process we can imagine:
>> 
>> - we start by looking at the statistics and indentify the wicked
>>   works/funcs.
>> - we look at the events on /debug/tracing/trace and, coupling with
>>   some well-chosen filters, we observe the behaviour of a work with
>>   more precision.
>> 
>> 
>> But I'm not opposite to your patch, I think it can be helpful to also
>> have the work name on certain circumstances.
>> But it makes the whole line a bit messy with a lot of informations for
>> those who only need the func name (or only the work name).
>> The best would be to have a runtime option to choose whether we want
>> to display it or not.
> 
> I understand you mean. thanks.
> My conclusion is follow,
> 
> Conclusion:
> 1/4 resend, but remove __entry->work
> 2/4 resend
> 3/4 remake as your suggestion
> 4/4 remake as your suggestion
> 5/4 dropped
> 
> but unfortunately I don't have enough development time. then,
> I and Zhaolei discuss this issue and we agreed Zaholei develop it.
Hello,

I will do it.

Thanks
Zhaolei
> 
> 
> Thanks!
> 
> 
> 
> 
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
