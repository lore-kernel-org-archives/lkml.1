Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbZIIClt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbZIIClt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZIIClt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:41:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbZIICls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:41:48 -0400
Message-ID: <4AA715A3.8040108@cn.fujitsu.com>
Date: Wed, 09 Sep 2009 10:40:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: rostedt@goodmis.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing: Add sysctl to enable/disable tracing on
 oops
References: <4AA7092C.4070706@cn.fujitsu.com> <1252461867.11070.6.camel@gandalf.stny.rr.com> <20090909113231.0CE6.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090909113231.0CE6.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>>>> Currently we always disable tracing on oops, and this patch
>>>>>>> adds a sysctl so one can choose to enable it.
>>>>>> Hmm, we already have a way to enable it.
>>>>>>
>>>>>> # echo 1 > /debug/tracing/tracing_on
>>>>>>
>>>>> What I want is a way to not disable it when an oops happened. :)
>>>>>
>>>> Ah, I misunderstood. May I ask a silly question?
>>>>
>>>> Why?
>>>>
>>> Otherwise we won't get trace output from trae_crash_kexec if
>>> crash_kexec() is not called by panic(). For example:
>>>
>>>   oops_begin()
>>> ->trace_off()
>>> ->panic_on_oops
>>> ->kexec_should_crash()
>>> ->crash_kexec()
>> OK, but I'm not exactly sure what you final goal is here. To have a
>> something to search for in the ring buffer after the crash? Maybe
>> instead we can add a "trace_oops" event? Just put it before the
>> tracing_off call.
> 
> I have another silly question.
> Why should we call tracing_off() in oops_enter()?
> 

I guess it's because trace outputs generated during oops can
overwrite/mess up those generated before oops?

It was added by this commit, but I can't find trace_printk_on_oops.

commit bdff78707f3ce47e891f3201c9666122a70556ce
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Jul 24 15:30:45 2009 -0400

    trace: stop tracer in oops_enter()

    If trace_printk_on_oops is set we lose interesting trace information
    when the tracer is enabled across oops handling and printing. We want
    the trace which might give us information _WHY_ we oopsed.

