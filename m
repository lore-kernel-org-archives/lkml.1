Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZLBVxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZLBVxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 16:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbZLBVxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 16:53:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494AbZLBVxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 16:53:33 -0500
Message-ID: <4B16E1C0.7000401@redhat.com>
Date: Wed, 02 Dec 2009 16:53:04 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/9] perf-probe updates
References: <20091201001912.10235.79411.stgit@harusame> <20091201072902.GA4587@elte.hu>
In-Reply-To: <20091201072902.GA4587@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> * Masami Hiramatsu<mhiramat@redhat.com>  wrote:
>
>> Hi,
>>
>> Here are bugfixes and updates for perf-probe and kprobe-tracer. I've
>> fixed some minor bugs and added --list option and simple probe naming.
>
> Applied, thanks Masami!
>
>> TODO:
>>   - Support build-id checking.
>>   - Support --del option to remove probes.
>>   - Support --line option to show which lines user can probe.
>>   - Support lazy string matching.
>
> ok, cool!
>
> One other small detail i noticed wrt. probe naming. Right now if we
> insert a single probe into a function it gets named schedule_0:
>
>   # perf probe schedule
>   Could not open vmlinux/module file. Try to use symbols.
>   Added new event: p:probe/schedule_0 schedule+0
>
> the next one gets named schedule_1, schedule_2, etc.
>
> It would be nice to special-case the first one and name it 'schedule'.
> Most of the time people insert a single probe into a function, so the _0
> postfix is extra and in most cases unnecessary typing for them.

Sure, that's reasonable.

>
> Another small detail is that i dont think we should emit this line:
>
>   Could not open vmlinux/module file. Try to use symbols.
>
> when we can create a probe successfully - it's just unnecessary noise,
> the user does not care how we pulled it off, as long as we were able to
> get a reliable symbol address and the insertion worked fine.

OK, I'll make it a debug message.

> A third detail is this line:
>
>   Added new event: p:probe/schedule_0 schedule+0
>
> If that is pasted to perf stat directly it wont work because the syntax
> is probe:schedule_0. So i'd suggest to print something like:
>
>   Added new event: probe/schedule_0 (on schedule+0)

Sure, perf always use ':' for event group separator, so

Added new event: probe:schedule (on schedule+0 [with ...(args)])

>
> Perhaps even print another line:
>
>    You can now use it on all perf tools, such as:
>
>      perf probe -e probe/schedule_0 -a sleep 1
>      perf record -e probe/schedule_0 -a sleep 1

OK.

Thank you for good advice!

>
> ... to show people how to make use of it.
>
> Thanks,
>
> 	Ingo

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

