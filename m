Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab0BRQUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:20:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758539Ab0BRQUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:20:05 -0500
Message-ID: <4B7D68AA.8060105@redhat.com>
Date: Thu, 18 Feb 2010 11:19:54 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Mike Frysinger <vapier.adi@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com> <1266491616-6270-3-git-send-regression-fweisbec@gmail.com> <8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com> <20100218120944.GA2406@osiris.boeblingen.de.ibm.com> <8bd0f97a1002180412x6cc4f280u5444f013c6e3b670@mail.gmail.com> <20100218123453.GA5136@nowhere> <20100218132521.GB2406@osiris.boeblingen.de.ibm.com> <8bd0f97a1002180601i60c5eaa4p7639091c5b617702@mail.gmail.com> <20100218145055.GB855@nowhere>
In-Reply-To: <20100218145055.GB855@nowhere>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Feb 18, 2010 at 09:01:12AM -0500, Mike Frysinger wrote:
>>> --- a/arch/Kconfig
>>> +++ b/arch/Kconfig
>>> @@ -123,6 +123,10 @@ config USE_GENERIC_SMP_HELPERS
>>>
>>>  config HAVE_REGS_AND_STACK_ACCESS_API
>>>        bool
>>> +       help
>>> +         This symbol should be selected by an architecure if it supports
>>> +         the API needed to access registers and stack entries from pt_regs.
>>> +         For example the kprobes-based event tracer needs this API.
>>
>> a bit vague ... arent there headers/functions people could look at ?
>> perhaps you're talking about the regset functions (which is an API to
>> access registers in pt_regs) ?  or you're talking about asm/syscall.h
>> (which is an API to access registers in pt_regs) ?
>>
>> i'm not asking to be a pain, i'm asking because i really havent a
>> clue.  if i wanted to add support for this stuff to the Blackfin arch,
>> i wouldnt know where to start.  even after reading this help i'd fall
>> back to grepping arch/x86/ and trying to divine a starting point from
>> there.
> 
> 
> If an arch support kprobes, it just needs to select
> HAVE_REGS_AND_STACK_ACCESS_API to figure out quickly what is missing,
> as gcc will barf every missing clues you need.

These APIs are needed for kprobe-tracer on ftrace(kernel/trace/trace_kprobe.c), 
which is just a consumer of kprobes (so depends on CONFIG_KPROBES).

I mean, if you wanna figure out that, you have to select CONFIG_KPROBE_EVENT too :)
And then, gcc tries to compile trace_kprobe.c and quickly dumps error messages
what APIs are not found :)

> For now it is stored is asm/ptrace.h, but that might be split in
> the future, especially as ptrace has initially nothing related to
> that. A documentation that deals with filenames or API enumerations
> tend to be incidentally async with API evolutions.

yeah, now those APIs depend on pt_regs, so I put it in ptrace.h.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

