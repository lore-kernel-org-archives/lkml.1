Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbZGVRDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbZGVRDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZGVRDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:03:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:54115 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZGVRDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:03:03 -0400
Subject: [PULL] perf counter patches
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Jul 2009 19:04:00 +0200
Message-Id: <1248282240.27058.1687.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull these perf counter patches from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-perf.git perf-counters-for-linus

Thanks,

  Peter

---
Anton Blanchard (8):
      perf_counter tools: Rename cache events to remove $
      perf_counter: Make sure we dont leak kernel memory to userspace
      perf_counter: Synthesize VDSO mmap event
      perf_counter: Log vfork as a fork event
      perf_counter: Add perf record option to log addresses
      perf_counter: Make call graph option consistent
      perf_counter: Improve perf stat and perf record option parsing
      perf_counter: Fix throttle/unthrottle event logging

Arjan van de Ven (2):
      perf: Fix stack data leak
      perf: avoid structure size confusion by using a fixed size

Arnaldo Carvalho de Melo (7):
      perf report: Adjust column width to the values sampled
      perf report: Tidy up reporting of symbols not found
      strlist: Introduce strlist__entry and strlist__nr_entries methods
      perf report: Make the output more compact
      perf_counter tools: PLT info is stripped in -debuginfo packages
      perf report: Introduce -n/--show-nr-samples
      perf symbol: C++ demangling

Chris Wilson (1):
      perf_counter: Fix the tracepoint channel to perfcounters

Daniel Qarras (1):
      perf_counter, x86: Extend perf_counter Pentium M support

Jason Baron (2):
      perf_counter: Add tracepoint support to perf list, perf stat
      perf_counter: Detect debugfs location

Mike Galbraith (2):
      perf_counter tools: Fix vmlinux symbol generation breakage
      perf_counter tools: Give perf top inherit option

Peter Zijlstra (6):
      perf_counter: Fix up P6 PMU details
      perf_counter: Clean up global vs counter enable
      perf_counter: Stop open coding unclone_ctx
      perf_counter: Remove unused variables
      perf_counter: Plug more stack leaks
      perf_counter: PERF_SAMPLE_ID and inherited counters

Roel Kluin (1):
      perf_counter tools: Fix index boundary check

Vince Weaver (1):
      perf_counter: Add P6 PMU support

 arch/x86/kernel/cpu/perf_counter.c       |  253 +++++++++++++++++++++++++++---
 include/linux/perf_counter.h             |   15 +--
 init/Kconfig                             |    2 +-
 kernel/fork.c                            |    9 +-
 kernel/perf_counter.c                    |  186 +++++++++++-----------
 tools/perf/Documentation/perf-report.txt |   15 ++
 tools/perf/Makefile                      |    2 +-
 tools/perf/builtin-annotate.c            |   24 ---
 tools/perf/builtin-record.c              |   13 ++-
 tools/perf/builtin-report.c              |  255 +++++++++++++++++++++---------
 tools/perf/builtin-stat.c                |    3 +-
 tools/perf/builtin-top.c                 |    6 +-
 tools/perf/perf.c                        |   77 +++++++++-
 tools/perf/perf.h                        |    8 +-
 tools/perf/util/cache.h                  |    1 +
 tools/perf/util/header.h                 |    2 +-
 tools/perf/util/include/linux/kernel.h   |    8 +
 tools/perf/util/parse-events.c           |  182 +++++++++++++++++++++-
 tools/perf/util/parse-events.h           |    5 +
 tools/perf/util/string.h                 |    3 +
 tools/perf/util/strlist.c                |   20 ++-
 tools/perf/util/strlist.h                |   11 +-
 tools/perf/util/symbol.c                 |  145 +++++++++++-------
 tools/perf/util/symbol.h                 |    1 +
 tools/perf/util/util.h                   |    2 +
 25 files changed, 949 insertions(+), 299 deletions(-)

