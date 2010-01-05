Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980Ab0AEWmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0AEWmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601Ab0AEWmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:42:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab0AEWmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:42:20 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/8] perf-probe updates
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 05 Jan 2010 17:46:35 -0500
Message-ID: <20100105224634.19431.3259.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are several bugfixes and updates of perf-probe and
kprobe-tracer.
This updates includes --line option support which you are
waiting for :-).

For kprobe-tracer, I decided to drop $argN support, because
the ABI for each function strongly depends on not only the
architecture but also the API of the function and gcc options.
Anyway, we already have perf-probe which allows us to find
register/memory assignment of each arguments.


Here are updated todo list.

Long-term TODOs (future features):
  - Support lazy string matching(glob?) for selecting probing
    line
  - Support sys_perf_counter_open (for non-root users)
  - Support tracing static variables (non global)
  - Support variable types from debuginfo (e.g. char, int, ...)
  - Support fields of data structures (var->field)
  - Support array (var[N])
  - Support dynamic array-indexing (var[var2])
  - Support string/dynamic arrays (*var, var[N..M])
  - Support force type-casting ((type)var)
  - Support the type of return value

Miscs:
  - Better support for probes on modules
  - Move onto libdw/libdwfl
  - Storing file name/line number information in the
    kernel for listing events
  

Thank you,

---

Masami Hiramatsu (8):
      perf probe: Support --line option to show probable source-code lines
      perf tools: Enhance glob string matching
      perf tools: Support tracepoint glob matching
      perf probe: Show probe list in pager
      [CLEANUP] perf probe: Remove newline from die()
      x86/ptrace: Remove unused regs_get_argument_nth API
      tracing/kprobe: Drop function argument access syntax
      tracing/kprobe: Update example output in documentation


 Documentation/trace/kprobetrace.txt     |   48 ++++---
 arch/x86/include/asm/ptrace.h           |    4 -
 arch/x86/kernel/ptrace.c                |   24 ----
 kernel/trace/trace_kprobe.c             |   18 ---
 tools/perf/Documentation/perf-probe.txt |   20 +++
 tools/perf/builtin-probe.c              |   80 ++++++++++--
 tools/perf/util/parse-events.c          |   11 +-
 tools/perf/util/probe-event.c           |  103 ++++++++++++++++
 tools/perf/util/probe-event.h           |    2 
 tools/perf/util/probe-finder.c          |  203 +++++++++++++++++++++++++++++--
 tools/perf/util/probe-finder.h          |   31 +++++
 tools/perf/util/string.c                |   65 +++++++++-
 12 files changed, 507 insertions(+), 102 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
