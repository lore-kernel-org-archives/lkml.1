Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYFMSEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYFMSEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 14:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYFMSEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 14:04:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbYFMSEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 14:04:10 -0400
Message-ID: <4852B628.8040906@redhat.com>
Date: Fri, 13 Jun 2008 14:02:16 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: "'Frank Ch. Eigler'" <fche@redhat.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Mathieu Desnoyers'" <mathieu.desnoyers@polymtl.ca>,
       "'Hideo AOKI'" <haoki@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, "'Steven Rostedt'" <rostedt@goodmis.org>
Subject: Re: Kernel marker has no performance impact on ia64.
References: <20080602232135.GA20173@Krystal> <1212618449.19205.35.camel@lappy.programming.kicks-ass.net> <20080604232241.GA8488@Krystal> <1212653539.19205.47.camel@lappy.programming.kicks-ass.net> <20080612135319.GB22348@Krystal> <1213280823.31518.114.camel@twins> <20080612155332.GA16658@redhat.com> <48514BE3.3000506@redhat.com> <20080612164318.GB17814@redhat.com> <48515770.4020002@redhat.com> <20080612174834.GB22454@redhat.com> <48517A56.20603@redhat.com> <004101c8cd0c$aa093190$fe1b94b0$@css.fujitsu.com>
In-Reply-To: <004101c8cd0c$aa093190$fe1b94b0$@css.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Thank you for comment.
Takashi Nishiie wrote:
> Hi,Hiramatsu
> 
>  Hiramatsu wrote:
> 
>> I think if someone changes the trace point in the kernel,
>> Module.markers is also changed.
>>
>> ex.)
>> DEFINE_TRACE(sched_switch, (struct task_struct * next, struct task_struct
> * prev),
>> 	     next, prev);
>>
>> if someone changes above to below,
>>
>> DEFINE_TRACE(sched_switch, (int prev_pid, int next_pid), prev_pid,
> next_pid);
>> Module.markers also change like
>>
>> sched_switch	vmlinux	(struct task_struct * next, struct task_struct *
> prev)
>> to
>>
>> sched_switch	vmlinux	(int prev_pid, int next_pid)
>>
>> In this case, the below entry never matches to new Module.markers.
>>
>> "sched_switch(struct task_struct * next, struct task_struct * prev)":"next
> %p prev %p"
>> Thus, we can find an error.
>> However, of cause, we should take care of the task_struct changes.
> 
>   The one expected of markers with SystemTap and LTTng is only 
> different the foundation of this discussion. 
> 
> SystemTap:
>   Because the output format is basically defined with user script in 
> systemtap script, "format information" is unnecessary. It can do 
> nothing but guess from "format information" in present markers though 
> the type of the argument is indispensable for SystemTap on the other 
> hand. If the type of an accurate argument is understood, correct 
> processing can be executed. Moreover, being able to refer to the 
> member of the structure if the argument is a pointer of the structure 
> becomes possible, and it is convenient. 

It's not so easy for systemtap... for example, if a marker pass 'char *',
how can we do it? it might have to record as a string, or might have to
record as a pointer. Obviously, printf-style information includes a kind of
'semantic' information. So, I think the 'lookup table' is good.

> LTTng:
>   Because the output format is not originally defined in LTTng, "format 
> information" is indispensable. 

Sure, however, LTTng can have original "format information" itself.

>   I think that I only have to add the item that shows the type of an 
> accurate argument if the format of "Module.markers" is changed. 

I think those 'semantic' type information (which informs you what
is this value and how this value should be recorded) should be
defined by each tracer, because what information they want to
extract from arguments are strongly depends on their use cases.

Actually, that requires tracers to pay maintenance costs, but
it's not so big if the "regular" marking point is enough stable.

Regards,

> 
> Thank you,
> 
> --
> Takashi Nishiie
> 
> 
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

