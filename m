Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbZH0Pff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbZH0Pff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZH0Pfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:35:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZH0Pfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:35:32 -0400
Message-ID: <4A96A865.1050300@redhat.com>
Date: Thu, 27 Aug 2009 11:38:13 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Przemys??aw Pawe??czyk <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 08/18] tracing: Add kprobe-based event tracer
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251340337-5640-9-git-send-email-fweisbec@gmail.com> <20090827073139.GB2131@elte.hu> <20090827134800.GC6058@nowhere>
In-Reply-To: <20090827134800.GC6058@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Aug 27, 2009 at 09:31:39AM +0200, Ingo Molnar wrote:
>>
>> * Frederic Weisbecker<fweisbec@gmail.com>  wrote:
>>
>>> From: Masami Hiramatsu<mhiramat@redhat.com>
>>>
>>> Add kprobes-based event tracer on ftrace.
>>>
>>> This tracer is similar to the events tracer which is based on
>>> Tracepoint infrastructure. Instead of Tracepoint, this tracer is
>>> based on kprobes (kprobe and kretprobe). It probes anywhere where
>>> kprobes can probe(this
>>>   means, all functions body except for __kprobes functions).
>>>
>>> Similar to the events tracer, this tracer doesn't need to be
>>> activated via current_tracer, instead of that, just set probe
>>> points via /sys/kernel/debug/tracing/kprobe_events. And you can
>>> set filters on each probe events via
>>> /sys/kernel/debug/tracing/events/kprobes/<EVENT>/filter.
>>
>> ok, one observation here: this should seemlessly merge into
>> /debug/tracing/events/ and provide a record format descriptor in
>> 'format' to allow the automated fetching of the results of the
>> probe. The PERF_SAMPLE_RAW gateway should work as well.
>>
>> That way tooling that knows about /debug/tracing/events/ will
>> automatically work with kprobes events as well. We can profile based
>> on kprobes, etc. etc.
>>
>> The _setting_ of the probe is still a separate channel - but if
>> existing installed probes are merged into existing tooling that's a
>> big step forward in terms of utility.
>>
>> 	Ingo
>
>
> It does already :)
>
> But I've split out this patch that initially embeded the documentation.
> If you look at the 9/10 patch, you can see how look like the format
> files for kprobes.

As far as I've tested, it just requires two changes for perf-tools.
- Support CONFIG_PROFILE_EVENT(profile_enable/disable) on kprobe-tracer.
- Ignore 'alias' tag(which is a special tag in kprobes event) while
   parsing format file.

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

