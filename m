Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZGGUku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZGGUku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZGGUkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:40:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46915 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbZGGUkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:40:40 -0400
Message-ID: <4A53B338.4060803@redhat.com>
Date: Tue, 07 Jul 2009 16:42:32 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH -tip -v10 7/7] tracing: add kprobe-based event tracer
References: <20090701010838.32547.62843.stgit@localhost.localdomain> <20090701010923.32547.74203.stgit@localhost.localdomain> <20090707073103.GA6173@nowhere> <4A53A830.3000305@redhat.com> <20090707202008.GE6184@nowhere>
In-Reply-To: <20090707202008.GE6184@nowhere>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Jul 07, 2009 at 03:55:28PM -0400, Masami Hiramatsu wrote:
>> Frederic Weisbecker wrote:
>>>> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
>>>> index 206cb7d..65945eb 100644
>>>> --- a/kernel/trace/trace.h
>>>> +++ b/kernel/trace/trace.h
>>>> @@ -45,6 +45,8 @@ enum trace_type {
>>>>  	TRACE_POWER,
>>>>  	TRACE_BLK,
>>>>  	TRACE_KSYM,
>>>> +	TRACE_KPROBE,
>>>> +	TRACE_KRETPROBE,
>>>>  
>>>>  	__TRACE_LAST_TYPE,
>>>>  };
>>>> @@ -227,6 +229,22 @@ struct trace_ksym {
>>>>  	char			ksym_name[KSYM_NAME_LEN];
>>>>  	char			p_name[TASK_COMM_LEN];
>>>>  };
>>>> +#define TRACE_KPROBE_ARGS 6
>>>> +
>>>> +struct kprobe_trace_entry {
>>>> +	struct trace_entry	ent;
>>>> +	unsigned long		ip;
>>>> +	int			nargs;
>>>> +	unsigned long		args[TRACE_KPROBE_ARGS];
>>>
>>>
>>> I see that you actually make use of arg as a dynamic sizeable
>>> array.
>>> For clarity, args[TRACE_KPROBE_ARGS] could be args[0].
>>>
>>> It's just a neat and wouldn't affect the code nor the data
>>> but would be clearer for readers of that code.
>> Hmm. In that case, I think we'll need a new macro for field
>> definition, like TRACE_FIELD_ZERO(type, item).
> 
> 
> 
> You mean that for trace_define_field() to describe fields of events?
> Actually the fields should be defined dynamically depending on how
> is built the kprobe event (which arguments are requested, how many,
> etc..).

Yeah, if you specified a probe point with its event name, the tracer
will make a corresponding event dynamically. There are also anonymous
probes which don't have corresponding events. For those anonymous
probes, I need to define two generic event types(kprobe and kretprobe).

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

