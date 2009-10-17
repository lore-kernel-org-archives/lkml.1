Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbZJQIC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbZJQIC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 04:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZJQIC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 04:02:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41509 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZJQICy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 04:02:54 -0400
Date: Sat, 17 Oct 2009 10:02:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf
	probe and kprobe-tracer bugfixes
Message-ID: <20091017080203.GA4155@elte.hu>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi Ingo and Frederic,
> 
> Here are the bugfix and update (mostly cleanup) patches for
> previous patchset.
> 
> > I hope it's part of the last family of instruction set we
> > are missing.
> 
> I added missing SSE opcodes and 3DNow! support too.
> However, near future, x86 decoder may need AVX support.
> (AFAIK, currently, there are no code using it.)
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (9):
>       perf: Add perf-probe document
>       perf: Add DIE_IF() macro for error checking
>       perf: Use eprintf() for debug messages in perf-probe
>       perf: Use die() for error cases in perf-probe
>       perf: Check libdwarf APIs for perf probe
>       x86: Add AMD prefetch and 3DNow! opcodes to opcode map
>       x86: Add MMX/SSE opcode groups to opcode map
>       tracing/kprobes: Add failure messages for debugging
>       tracing/kprobes: Update kprobe-tracer selftest against new syntax
> 
> 
>  arch/x86/lib/x86-opcode-map.txt         |   23 ++++-
>  kernel/trace/trace_kprobe.c             |   39 ++++++--
>  tools/perf/Documentation/perf-probe.txt |   48 ++++++++++
>  tools/perf/Makefile                     |    5 +
>  tools/perf/builtin-probe.c              |   70 ++++++---------
>  tools/perf/command-list.txt             |    1 
>  tools/perf/util/probe-finder.c          |  149 ++++++++++++++-----------------
>  tools/perf/util/probe-finder.h          |   17 ----
>  tools/perf/util/util.h                  |    9 ++
>  9 files changed, 206 insertions(+), 155 deletions(-)
>  create mode 100644 tools/perf/Documentation/perf-probe.txt

Looks really nice, thanks Masami!

Note, i've created a new topic tree for this work: tip:perf/probes, and 
have put all the commits there - since i expect most of the 
enabling/completion work for this feature to happen on the perf events 
side.

I also merged this tree upto v2.6.32-rc5 and resolved a conflict with 
recent tracing fixes. Please base future patches on this new tree.

Thanks,

	Ingo
