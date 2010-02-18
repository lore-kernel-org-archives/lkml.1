Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab0BRXVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:21:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab0BRXVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:21:10 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/9] perf-probe updates - use elfutils and introduce lazy
	matching
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
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
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>,
       Mike Galbraith <efault@gmx.de>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Thu, 18 Feb 2010 18:27:01 -0500
Message-ID: <20100218232701.21679.5195.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are several bugfixes and updates of perf-probe.
This updates includes moving onto elfutils-libdw and
the lazy line matching support which you had mentioned :-)

elfutils library is developed closely with gcc team,
and it is simple and fast dwarf analysis library.

lazy-matching is similar to glob matching but ignoring
spaces in both of target and pattern.

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
 tools/perf/util/probe-finder.c          |  994 ++++++++++++++-----------------
 tools/perf/util/probe-finder.h          |   53 +-
 tools/perf/util/string.c                |   55 +-
 tools/perf/util/string.h                |    1 
 8 files changed, 639 insertions(+), 623 deletions(-)

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
