Return-Path: <linux-kernel-owner+w=401wt.eu-S966537AbZLHV6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966537AbZLHV6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966254AbZLHV6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:58:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965722AbZLHV6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:58:41 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/8] perf-probe updates
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 08 Dec 2009 17:02:32 -0500
Message-ID: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I made several usability updates and added --del option
for perf-probe. I think most of basic functions are implemented.
I'm planning to support checking build-id next, because it
can prevent users to use old vmlinux for debuginfo analysis.

Here are the todo list I have (most of them had been requested
on LKML). I'd like to share this list with other developers
who are interested in.

Short-term TODOs:
  - Support checking kernel Build-ID

Long-term TODOs (future features):
  - Support --line option to show which lines user can probe
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
  - Support glob expression with --del option (like --del "*")
  - Support event/group name specifying for new events
  - Better support for probes on modules
  - Symbol search by libelf/kallsyms
  - Move onto libdw/libdwfl
  - Storing file name/line number information in the
    kernel for listing events
  

Thank you,

---

Masami Hiramatsu (8):
      perf probe: Update perf-probe document
      perf probe: Support --del option
      trace-kprobe: Support delete probe syntax
      perf probe: Support vmlinux on cwd by default
      perf probe: Remove event suffix number _0
      perf probe: Fix add-probe command syntax without --add option
      perf probe: Change probe-added message more user-friendly
      perf probe: Change event list format


 kernel/trace/trace_kprobe.c             |   37 +++++++--
 tools/perf/Documentation/perf-probe.txt |   21 ++++-
 tools/perf/builtin-probe.c              |   76 ++++++++++++++++---
 tools/perf/util/probe-event.c           |  122 ++++++++++++++++++++++++++++---
 tools/perf/util/probe-event.h           |    1 
 5 files changed, 217 insertions(+), 40 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
