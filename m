Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZKDARq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZKDARq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZKDARn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:17:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbZKDARm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:17:42 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 0/5] perf-probe and kprobe-tracer updates
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 03 Nov 2009 19:12:04 -0500
Message-ID: <20091104001204.3454.75999.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are some updates according to previous LKML threads.
 - Update perf-probe document.
 - Improve error messages.
 - Fall back to non-dwarf mode if possible.
 - Change group name to probe.
 - Rename kprobe-tracer to kprobe-event.

BTW, I think perf-probe and kprobe-event might better share
similar syntax for not confusing users. And for that purpose,
perf-probe syntax should introduce event/group specifier,
for example,

 perf probe "newgroup:newevnt=func:10 arg1 arg2"

adds the newevent under newgroup. On the other hand, ftrace
users can also add a new event as below;

 echo 'newgroup:newevent=func+0x18 arg1=$a1 arg2=$a2' > kprobe_events

Any thoughts?

TODO:
 - Support --list option to show probes.
 - Support --del option to remove probes.
 - Simplify probe names.
 - Support --line option to show which lines user can probe.
 - Support lazy string matching.

Thank you,

---

Masami Hiramatsu (5):
      tracing/kprobes: Rename Kprobe-tracer to kprobe-event
      perf/probes: Rename perf probe events group name
      perf/probes: Fall back to non-dwarf if possible
      perf/probes: Improve error messages
      perf/probe: Update Documentation/perf-probe.txt


 Documentation/trace/kprobetrace.txt     |   34 ++++++-------
 kernel/trace/Kconfig                    |   19 ++++---
 kernel/trace/Makefile                   |    2 -
 kernel/trace/trace_kprobe.c             |    6 +-
 tools/perf/Documentation/perf-probe.txt |   17 +++---
 tools/perf/builtin-probe.c              |   84 ++++++++++++++++++-------------
 tools/perf/util/probe-finder.c          |    7 ++-
 7 files changed, 95 insertions(+), 74 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
