Return-Path: <linux-kernel-owner+w=401wt.eu-S932257AbZJ0Umn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbZJ0Umn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932158AbZJ0Umm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:42:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbZJ0Uml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:42:41 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 00/10] x86 insn decoder bugfixes
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 27 Oct 2009 16:41:56 -0400
Message-ID: <20091027204156.30545.96425.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are bugfixes and some enhances of x86-insn decoder and perf-probe.
 - x86 insn decoder supports AVX and FMA.
 - perf-probe syntax change.
 - perf-probe supports function-relative line number.
 - minor bugfixes.

New perf-probe syntax is below:

  perf probe 'PROBE'

 or 

  perf probe --add 'PROBE'

 where, PROBE is

  <source>:<line-number>

 or

  <function>[:<rel-lineno>|+<byte-offset>|%return][@<source>]

 e.g.

  perf probe 'schedule:10@kernel/sched.c'

  puts a probe at 10th line from entry line of schedule() function
  in kernel/sched.c." and

  perf probe 'vmalloc%return'

  puts a return probe at the returning of vmalloc.

TODO:
 - Support --line option to show which lines user can probe.
 - Support lazy string matching.

Thank you,

---

Masami Hiramatsu (10):
      perf/probes: Support function entry relative line number
      perf/probes: Change probepoint syntax of perf-probe
      perf/probes: Change command-line option of perf-probe
      perf/probes: Exit searching after finding target function
      kprobe-tracer: Compare both of event-name and event-group to find probe
      x86: Add Intel FMA instructions to x86 opcode map
      x86: AVX instruction set decoder support
      x86: Add pclmulq to x86 opcode map
      x86: Merge INAT_REXPFX into INAT_PFX_*
      x86: Fix SSE opcode map bug


 arch/x86/include/asm/inat.h          |   68 ++++-
 arch/x86/include/asm/insn.h          |   43 +++
 arch/x86/lib/inat.c                  |   12 +
 arch/x86/lib/insn.c                  |   54 ++++
 arch/x86/lib/x86-opcode-map.txt      |  464 +++++++++++++++++++---------------
 arch/x86/tools/gen-insn-attr-x86.awk |  100 +++++--
 kernel/trace/trace_kprobe.c          |    8 -
 tools/perf/builtin-probe.c           |  201 +++++++++------
 tools/perf/util/probe-finder.c       |   93 +++++--
 tools/perf/util/probe-finder.h       |    4 
 10 files changed, 695 insertions(+), 352 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
