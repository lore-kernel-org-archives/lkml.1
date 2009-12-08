Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZLHIVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZLHIVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZLHIVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:21:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51197 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbZLHIVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:21:35 -0500
Message-ID: <4B1E0C7A.8070005@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 16:21:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 02/13] tracing: Extract calls to	trace_define_common_fields()
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC49C.8000107@cn.fujitsu.com> <4B1DE5D4.4070805@cn.fujitsu.com> <20091208075731.GC4989@nowhere> <4B1E086E.7040001@cn.fujitsu.com> <20091208081657.GG4989@nowhere>
In-Reply-To: <20091208081657.GG4989@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> @@ -1131,10 +1127,6 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
>>>>>  	struct kretprobe_trace_entry field;
>>>>>  	struct trace_probe *tp = (struct trace_probe *)event_call->data;
>>>>>  
>>>>> -	ret = trace_define_common_fields(event_call);
>>>>> -	if (!ret)
>>>>> -		return ret;
>>>>> -
>>>>>  	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
>>>>>  	DEFINE_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP, 0);
>>>>>  	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
>>>> "if (!ret)" is wrong. trace_define_common_fields() returns zero when success.
>>>> So "unsigned long, func", "unsigned long, ret_ip" ...etc are NOT "defined"
>>>> and filters can not be applied for trace_kprobe.
>>>>
>>>> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>>>
>>> Oh right!
>>>
>>> Ok, I'm queueing this one for the tracing fixes.
>>> Thanks!
>>>
>> This patch has dependency on the previous patch..So can you queue
>> all other patches and send a pull request to Ingo? We're still
>> in the early merge window, so those patches should be fine for
>> .33.
>>
>> And as this patch fixes a bug "acidentally", the changelog
>> needs a bit revision.
> 
> The problem is that we can't know in advance Linus will take
> a second round of tracing features in this merge window.
> 
> I'd rather be careful and keep separating tracing fixes and
> tracing features.
> 
> I'm preparing a separate fix.
> 

But there is no functionality change or new feature in this
patchset, all are cleanups and fixes.

That said, I don't mind how you separate them. :)

