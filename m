Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZLOP1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZLOP1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZLOP1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:27:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbZLOP1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:27:14 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 00/14] perf-probe updates
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 15 Dec 2009 10:31:06 -0500
Message-ID: <20091215153106.17436.66584.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are several bugfixes and updates of perf-probe.
This updates includes below features.

  - Support checking kernel Build-ID
	Comparing vmlinux build-id and running kernel build-id
	can prevent user to set incorrect probes by using
	old/incorrect vmlinux.

  - Symbol search by libelf/kallsyms
	This allows to check probed symbol exists in the kernel
	even if debuginfo is not available.

  - Support glob expression with --del option (like --del '*')
	This allows users to use wildcard for specifying
	deleting events.

  - Reject adding same-name events
	Rejecting to add event which name already exists.

  - Support event name specifying for new events
	This allows users to set their own name to new
	events. Currently setting group name is not
	allowed, because it will conflict with other
	tracepoints and kmem event.

I think the glob expression (wildcard matching) can be
applied to other perf tools for choosing events, and it
will give user better experience :-)


Here are updated todo list.

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
  - Better support for probes on modules
  - Move onto libdw/libdwfl
  - Storing file name/line number information in the
    kernel for listing events
  

Thank you,

---

Masami Hiramatsu (14):
      perf probe: Fix to show which probe point is not found
      perf probe: Check symbols in symtab/kallsyms
      perf probe: Check build-id of vmlinux
      perf probe: Reject second attempt of adding same-name event
      perf probe: Support event name for --add option
      perf probe: Add glob matching support on --del
      perf probe: Use strlist__for_each macros in probe-event.c
      perf tools: Add for_each macros for strlist
      perf probe: Fix --del to update current event list
      perf probe: Fix --del to show info instead of warning
      perf probe: Show need-dwarf message only if it is really needed
      perf probe: Check hyphen only argument
      perf probe: Check the result of e_snprintf()
      perf probe: Cleanup struct session in builtin-probe.c


 tools/perf/Documentation/perf-probe.txt |    3 
 tools/perf/builtin-probe.c              |  145 ++++++++++++----------
 tools/perf/util/event.h                 |    2 
 tools/perf/util/map.c                   |   14 +-
 tools/perf/util/probe-event.c           |  208 +++++++++++++++++++++----------
 tools/perf/util/probe-event.h           |   11 +-
 tools/perf/util/probe-finder.c          |    4 -
 tools/perf/util/probe-finder.h          |    3 
 tools/perf/util/string.c                |   25 ++++
 tools/perf/util/string.h                |    2 
 tools/perf/util/strlist.c               |    6 -
 tools/perf/util/strlist.h               |   41 ++++++
 12 files changed, 318 insertions(+), 146 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
