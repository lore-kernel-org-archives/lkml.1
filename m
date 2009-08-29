Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbZH2LCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbZH2LCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 07:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZH2LCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 07:02:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46157 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbZH2LCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 07:02:45 -0400
Date: Sat, 29 Aug 2009 13:02:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL v2] tracing/kprobes: v1 + two fixes
Message-ID: <20090829110236.GB6812@elte.hu>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251344087-28719-1-git-send-email-fweisbec@gmail.com> <20090827152438.GA32553@elte.hu> <4A96B074.8060909@redhat.com> <20090827163533.GA30268@elte.hu> <4A96B9BC.7080800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A96B9BC.7080800@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Ingo Molnar wrote:
>>
>> * Masami Hiramatsu<mhiramat@redhat.com>  wrote:
>>
>>>
>>>
>>> Ingo Molnar wrote:
>>>>
>>>> * Frederic Weisbecker<fweisbec@gmail.com>   wrote:
>>>>
>>>>> Ingo,
>>>>>
>>>>> This v2 can be either pulled after tracing/kprobes (the v1) or can
>>>>> be pulled alone, it is based on the previous one and addresses
>>>>> reviews from Li Zefan.
>>>>>
>>>>> Thanks,
>>>>> Frederic.
>>>>>
>>>>> The following changes since commit 24851d2447830e6cba4c4b641cb73e713f312373:
>>>>>     Frederic Weisbecker (1):
>>>>>           tracing/kprobes: Dump the culprit kprobe in case of kprobe recursion
>>>>>
>>>>> are available in the git repository at:
>>>>>
>>>>>     git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
>>>>> 	tracing/kprobes-2
>>>>>
>>>>> Frederic Weisbecker (2):
>>>>>         tracing: Restore the const qualifier for field names and types definition
>>>>>         tracing: Remove unneeded pointer casts
>>>>>
>>>>>    include/linux/ftrace_event.h  |    6 +++---
>>>>>    kernel/trace/trace_events.c   |    4 ++--
>>>>>    kernel/trace/trace_syscalls.c |    8 ++++----
>>>>>    3 files changed, 9 insertions(+), 9 deletions(-)
>>>>
>>>> I've pulled it into a staging branch (not yet in tip:master either
>>>> and not yet on the road to upstream either), thanks guys!
>>>>
>>>> I have done some brief testing. One hickup is this build failure on
>>>> x86, caused by the kprobes instruction decoder self-test:
>>>>
>>>>      CHK     include/linux/compile.h
>>>>      TEST    posttest
>>>>    Error: 41001024:        a1 08 30 c9 41          mov
>>>>    0x41c93008,%eax
>>>>    Error: objdump says 5 bytes, but insn_get_length() says 9 (attr:40000)
>>>
>>> Oops, it should be fixed. Hmm, it seems that addr_bytes or
>>> opnd_bytes is broken, would you did a cross compiling? (compiling
>>> x86-32 on x86-64)
>>
>> yeah, i did that.
>
> I see, so current selftest is not enough supporting the cross 
> compiling yet. I think I can fix that. Could you tell me how you 
> did that? make ARCH=i386 ?

Yeah, make ARCH=i386 and a CROSS= pointer to the cross-build 
toolchain.

	Ingo
