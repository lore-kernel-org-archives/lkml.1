Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZLAATl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZLAATl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZLAATj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:19:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbZLAATh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:19:37 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/9] perf-probe updates
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Mon, 30 Nov 2009 19:19:13 -0500
Message-ID: <20091201001912.10235.79411.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are bugfixes and updates for perf-probe and kprobe-tracer.
I've fixed some minor bugs and added --list option and simple
probe naming.

TODO:
 - Support build-id checking.
 - Support --del option to remove probes.
 - Support --line option to show which lines user can probe.
 - Support lazy string matching.

Thank you,

---

Masami Hiramatsu (9):
      perf probe: Simplify event naming
      perf probe: Add --list option for listing current probe events
      perf probe: Add argv_split() from lib/argv_split.c
      perf probe: Move probe event utility functions to probe-event.c
      perf probe: Fix probe array index for multiple probe point
      perf probe: Fix argv array size in probe parser
      perf probe: Fix to add probe-finder.h without libdwarf
      perf probe: Fix to change a debugging message from pr_info to pr_debug
      trace_kprobes: Fix a memory leak bug and check kstrdup return value


 kernel/trace/trace_kprobe.c   |   26 ++
 tools/perf/Makefile           |    4 
 tools/perf/builtin-probe.c    |  236 ++------------------
 tools/perf/util/probe-event.c |  484 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-event.h |   18 ++
 tools/perf/util/string.c      |  101 +++++++++
 tools/perf/util/string.h      |    2 
 7 files changed, 647 insertions(+), 224 deletions(-)
 create mode 100644 tools/perf/util/probe-event.c
 create mode 100644 tools/perf/util/probe-event.h

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
