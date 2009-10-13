Return-Path: <linux-kernel-owner+w=401wt.eu-S1759768AbZJMM7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768AbZJMM7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759639AbZJMM7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:59:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759530AbZJMM7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:59:23 -0400
Message-ID: <4AD479D9.90202@redhat.com>
Date: Tue, 13 Oct 2009 09:00:09 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch . Eigler" <fche@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/kprobes: Syntax updates, introduce perf	probe
References: <1255386309-4992-1-git-send-email-fweisbec@gmail.com> <20091013061323.GE3215@elte.hu> <20091013062227.GA8051@elte.hu>
In-Reply-To: <20091013062227.GA8051@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>>>  tools/perf/Makefile                 |   10 +
>>>  tools/perf/builtin-probe.c          |  386 +++++++++++++++++++
>>>  tools/perf/builtin.h                |    1 +
>>>  tools/perf/perf.c                   |    1 +
>>>  tools/perf/util/probe-finder.c      |  690 +++++++++++++++++++++++++++++++++++
>>>  tools/perf/util/probe-finder.h      |   70 ++++
>>>  8 files changed, 1271 insertions(+), 74 deletions(-)
>>>  create mode 100644 tools/perf/builtin-probe.c
>>>  create mode 100644 tools/perf/util/probe-finder.c
>>>  create mode 100644 tools/perf/util/probe-finder.h
>>
>> Hm, there's no x86 decoder change here - does this lot fixes the 
>> instruction decoder bug i reported some time ago? That is which keeps 
>> tracing/kprobes out of tip:master.
> 
> See my previous report below.
> 
> 	Ingo
> 
> ----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----
> 
> Date: Sat, 3 Oct 2009 12:49:23 +0200
> From: Ingo Molnar <mingo@elte.hu>
> To: Frederic Weisbecker <fweisbec@gmail.com>
> Subject: Re: [GIT PULL] tracing/kprobes: kprobes fixes
> Cc: LKML <linux-kernel@vger.kernel.org>,
> 	Steven Rostedt <rostedt@goodmis.org>,
> 	Li Zefan <lizf@cn.fujitsu.com>
> 
> 
> ok, -tip testing found this new failure:
> 
>   TEST    posttest
> Error: ffffffff8106ac00:        66 0f 73 fd 04          pslldq $0x4,%xmm5
> Error: objdump says 5 bytes, but insn_get_length() says 4 (attr:8000)
> make[1]: *** [posttest] Error 2
> make: *** [bzImage] Error 2
> 
> 	Ingo
> 

Hmm, thank you for reporting, I've missed some group opcode...

Thank you again,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

