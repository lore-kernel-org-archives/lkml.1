Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab0BWCEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:04:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab0BWCEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:04:41 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3 0/9] perf-probe updates - use elfutils and introduce
	lazy matching
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Mon, 22 Feb 2010 21:08:18 -0500
Message-ID: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are several bugfixes and updates of perf-probe (v3).
This updates includes moving onto elfutils-libdw and
the lazy line matching support which you had mentioned :-)

elfutils library is developed closely with gcc team,
and it is simple and fast dwarf analysis library.

lazy-matching is similar to glob matching but ignoring
spaces in both of target and pattern.


Changes in v3:
 - Cast Dwarf_Addr/Dwarf_Word to uintmax_t for printf-formats.
 - Recover a sign-prefix which was removed in v2 by mistake.

Changes in v2:
 (Fixed bugs on x86-64)
 - Fix a type-casting bug in Makefile.
 - Cast Dwarf_Addr/Dwarf_Word to unsigned long long for
   printf-formats.


This is updated todo list. Most of them are related
to the 'type' support.

Long-term TODOs (future features):
  - Enhance probe-finder to decode call frame instructions.
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
  - --list option shows the file-name/line-number of each events.
  - More debugger like enhancements(%next, --disasm, etc.)


Thank you,

---

Masami Hiramatsu (9):
      perf probe: Add lazy line matching support
      perf probe: show more lines after last line
      perf probe: Check function address range strictly in line finder
      perf probe: Use libdw callback routines
      perf probe: Use elfutils-libdw for analyzing debuginfo
      perf probe: Rename probe finder functions
      perf probe: Fix bugs in line range finder
      perf probe: Update perf probe document
      perf probe: Do not show --line option without dwarf support


 tools/perf/Documentation/perf-probe.txt |   58 ++
 tools/perf/Makefile                     |   10 
 tools/perf/builtin-probe.c              |   36 +
 tools/perf/util/probe-event.c           |   55 +-
 tools/perf/util/probe-finder.c          | 1002 ++++++++++++++-----------------
 tools/perf/util/probe-finder.h          |   53 +-
 tools/perf/util/string.c                |   55 +-
 tools/perf/util/string.h                |    1 
 8 files changed, 644 insertions(+), 626 deletions(-)

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
