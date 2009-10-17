Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZJQAHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZJQAHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 20:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZJQAHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 20:07:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZJQAG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 20:06:59 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes,
	perf: perf probe and kprobe-tracer bugfixes
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Fri, 16 Oct 2009 20:07:12 -0400
Message-ID: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and Frederic,

Here are the bugfix and update (mostly cleanup) patches for
previous patchset.

> I hope it's part of the last family of instruction set we
> are missing.

I added missing SSE opcodes and 3DNow! support too.
However, near future, x86 decoder may need AVX support.
(AFAIK, currently, there are no code using it.)

Thank you,

---

Masami Hiramatsu (9):
      perf: Add perf-probe document
      perf: Add DIE_IF() macro for error checking
      perf: Use eprintf() for debug messages in perf-probe
      perf: Use die() for error cases in perf-probe
      perf: Check libdwarf APIs for perf probe
      x86: Add AMD prefetch and 3DNow! opcodes to opcode map
      x86: Add MMX/SSE opcode groups to opcode map
      tracing/kprobes: Add failure messages for debugging
      tracing/kprobes: Update kprobe-tracer selftest against new syntax


 arch/x86/lib/x86-opcode-map.txt         |   23 ++++-
 kernel/trace/trace_kprobe.c             |   39 ++++++--
 tools/perf/Documentation/perf-probe.txt |   48 ++++++++++
 tools/perf/Makefile                     |    5 +
 tools/perf/builtin-probe.c              |   70 ++++++---------
 tools/perf/command-list.txt             |    1 
 tools/perf/util/probe-finder.c          |  149 ++++++++++++++-----------------
 tools/perf/util/probe-finder.h          |   17 ----
 tools/perf/util/util.h                  |    9 ++
 9 files changed, 206 insertions(+), 155 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-probe.txt

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
