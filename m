Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958Ab0ASB2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0ASB2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 20:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279Ab0ASB2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 20:28:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57213 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab0ASB2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 20:28:12 -0500
Message-ID: <4B550A32.6010508@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 09:26:10 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf_event: cleanup for event profile buffer	operation
References: <4B54654A.4090601@cn.fujitsu.com> <4B5465D8.9070203@cn.fujitsu.com> <4B548A9A.1020806@redhat.com> <20100118172021.GL10364@nowhere> <4B549F00.6060704@redhat.com>
In-Reply-To: <4B549F00.6060704@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
>> On Mon, Jan 18, 2010 at 11:21:46AM -0500, Masami Hiramatsu wrote:
>>> Hmm, could you make it inline-functions or add __kprobes?
>>> Because it is called from kprobes, we don't want to probe
>>> the function which will be called from kprobes handlers itself.
>>>
>>> (IMHO, from the viewpoint of performance, inline-function
>>>  could be better.)
>>>
>>> Thank you,
>>
>>
>> Yeah, may be inline ftrace_profile_buf_end, would be better.
>> But we shouldn't inline ftrace_profile_buf_begin() I guess,
>> considering its size.
> 
> Indeed, especially for events...
> 

Thanks Masami and Frederic, i'll fix it in the next version

>> While at it, may be let's choose more verbose names
>> like
>>
>> ftrace_profile_buf_fill() and ftrace_profile_buf_submit().
>>
>> Also, profile is a bit of a misnomer. Not a problem since
>> ftrace_profile_templ_##call() is already a misnomer, but
>> we should start a bit of a rename. Sometimes, perf only
>> profiles trace events as counters and sometimes it records
>> the raw samples too.
>>
>> So, as more generic names, I would suggest:
>>
>> ftrace_perf_buf_fill() and ftrace_perf_buf_submit().
> 
> 
> Actual filling buffer is done in the profile handlers,
> so I think ftrace_perf_buf_prepare() may be better :-)
> ftrace_perf_buf_submit is good to me:-)
> 

OK, i'll rename those functions and add __kprobe for ftrace_perf_buf_prepare(),
i guess i can add you Acked-by :-)

Thanks,
Xiao
