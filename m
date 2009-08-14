Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbZHNPCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbZHNPCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 11:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932390AbZHNPCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 11:02:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46997 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387AbZHNPCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 11:02:51 -0400
Message-ID: <4A857D49.3030705@redhat.com>
Date: Fri, 14 Aug 2009 11:05:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [RFD] Kprobes/Kretprobes perf support
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <4A82EEC5.8000603@redhat.com> <4A82F5A0.2090603@redhat.com> <20090812191305.GB5974@nowhere>
In-Reply-To: <20090812191305.GB5974@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Ftrace events are supported by perfcounter currently but Kprobes
> dynamic ftrace events are of a different nature: we must create them
> before any toggling.
>
> So a large part is already done through the ftrace events and the fact
> that you create one dynamically for each kprobes (we'll just need
> a little callback for perf sample submission but that's a small
> point).
>
> The largest work that remains is to port the current powerful interface
> to create these k{ret}probes (with requested  arguments, etc...) through
> ftrace but using perf open syscall.
>
> And I imagine it won't be trivial.
>
> Ingo, Peter do you have an idea on how we could do that?
> We should be able to choose between a kprobe and kretprobe (these can
> be two separate counters). And also one must be able to request the dump
> of random desired parameters (or return values in case of kretprobe)
> or registers...
>
> May be we should use the perf attr by passing a __user address to a buffer
> that contains all these options?
> Once we get that to the kernel, that can be passed to ftrace-kprobe that
> can parse it, create the desired trace event and rely on perf to create
> a counter for it.
>
> I guess that won't imply so much adds to Masami's patchset. Most of
> the work is on the perf tools (parsing the user request).
>
> ./perf kprobes -e (func|addr):(c|r):(a1,a2,a3,... | rax,rbx,rcx,...)
>                                ^  ^
>                             c = call = kprobe
>                             r = return = kretprobe

If it is possible that libdwarf can be linked to the perf tool, I think
it might be better to support 'C source line/local variable' style too,
because basic dwarf decoding logic has already been done in c2kpe which
I posted yesterday :-).

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

