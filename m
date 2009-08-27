Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZH0QJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZH0QJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 12:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZH0QJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 12:09:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbZH0QJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:09:38 -0400
Message-ID: <4A96B074.8060909@redhat.com>
Date: Thu, 27 Aug 2009 12:12:36 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL v2] tracing/kprobes: v1 + two fixes
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251344087-28719-1-git-send-email-fweisbec@gmail.com> <20090827152438.GA32553@elte.hu>
In-Reply-To: <20090827152438.GA32553@elte.hu>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> 
> * Frederic Weisbecker<fweisbec@gmail.com>  wrote:
> 
>> Ingo,
>>
>> This v2 can be either pulled after tracing/kprobes (the v1) or can
>> be pulled alone, it is based on the previous one and addresses
>> reviews from Li Zefan.
>>
>> Thanks,
>> Frederic.
>>
>> The following changes since commit 24851d2447830e6cba4c4b641cb73e713f312373:
>>    Frederic Weisbecker (1):
>>          tracing/kprobes: Dump the culprit kprobe in case of kprobe recursion
>>
>> are available in the git repository at:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
>> 	tracing/kprobes-2
>>
>> Frederic Weisbecker (2):
>>        tracing: Restore the const qualifier for field names and types definition
>>        tracing: Remove unneeded pointer casts
>>
>>   include/linux/ftrace_event.h  |    6 +++---
>>   kernel/trace/trace_events.c   |    4 ++--
>>   kernel/trace/trace_syscalls.c |    8 ++++----
>>   3 files changed, 9 insertions(+), 9 deletions(-)
> 
> I've pulled it into a staging branch (not yet in tip:master either
> and not yet on the road to upstream either), thanks guys!
> 
> I have done some brief testing. One hickup is this build failure on
> x86, caused by the kprobes instruction decoder self-test:
> 
>     CHK     include/linux/compile.h
>     TEST    posttest
>   Error: 41001024:        a1 08 30 c9 41          mov
>   0x41c93008,%eax
>   Error: objdump says 5 bytes, but insn_get_length() says 9 (attr:40000)

Oops, it should be fixed. Hmm, it seems that addr_bytes or opnd_bytes
is broken, would you did a cross compiling? (compiling x86-32 on x86-64)


Thank you,

> another one is this build warning:
> 
>   In file included from include/trace/events/napi.h:5,
>                    from net/core/net-traces.c:28:
>   include/linux/tracepoint.h:285:1: warning: "TRACE_EVENT_FN" redefined
>   In file included from include/trace/define_trace.h:61,
>                    from include/trace/events/skb.h:40,
>                    from net/core/net-traces.c:27:
>   include/trace/ftrace.h:50:1: warning: this is the location of the previous definition
> 
> config attached.
> 
> 	Ingo

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

