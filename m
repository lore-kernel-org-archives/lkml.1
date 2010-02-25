Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab0BYDms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:42:48 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:49649 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758913Ab0BYDmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AjUpKL8oza4mOzX1t6J30ioC+nJpnqGmHXC7MaQWEZzlOcMihQcmbretFo9WUaItEF
         FBxiy0BlpZ45r1Zbzl9eEpxSgXnQ5OzIPoW1gety+Lj2Va8JtXDZoMT631A0lHHS+25P
         rb8/m8o3J6u6ptS6rXO+6nsk1isEHf86I48ng=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Keiichi KII <k-keiichi@bx.jp.nec.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL] Perf python scripting support
Date: Thu, 25 Feb 2010 04:42:31 +0100
Message-Id: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

I've left out the parts that deal with syscall nr to name
resolution as it would be nicer to implement it through events
injection instead of yet another debugfs file.

The reason I've made a separate patch to tag syscall_name()
helper as unavailable yet is that it makes it easily
revertable later, once it gets supported.

I've tested the whole and it works very well.

Thanks,
	Frederic
---

Tom Zanussi (9):
      perf/scripts: Fix supported language listing option
      perf/scripts: Fix bug in Util.pm
      perf/scripts: Move common code out of Perl-specific files
      perf/scripts: Move Perl scripting files to scripting-engines dir
      perf/scripts: Remove check-perf-trace from listed scripts
      perf/scripts: Add Python scripting engine
      perf/scripts: Add syscall tracing scripts
      perf/scripts: Remove unnecessary PyTuple resizes
      perf/scripts: Add perf-trace-python Documentation

Frederic Weisbecker (1):
      perf/scripts: Tag syscall_name helper as not yet available


 tools/perf/Documentation/perf-trace-perl.txt       |    2 +-
 tools/perf/Documentation/perf-trace-python.txt     |  625 ++++++++++++++++++
 tools/perf/Documentation/perf-trace.txt            |   15 +-
 tools/perf/Makefile                                |   33 +-
 tools/perf/builtin-trace.c                         |    5 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |    5 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    3 +-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |    2 +-
 .../perf/scripts/perl/bin/check-perf-trace-record  |    7 +-
 .../perf/scripts/perl/bin/check-perf-trace-report  |    6 -
 tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +
 tools/perf/scripts/perl/bin/failed-syscalls-report |    4 +
 tools/perf/scripts/perl/failed-syscalls.pl         |   38 ++
 .../perf/scripts/python/Perf-Trace-Util/Context.c  |   88 +++
 .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |   91 +++
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |   25 +
 .../python/bin/failed-syscalls-by-pid-record       |    2 +
 .../python/bin/failed-syscalls-by-pid-report       |    4 +
 .../python/bin/syscall-counts-by-pid-record        |    2 +
 .../python/bin/syscall-counts-by-pid-report        |    4 +
 .../perf/scripts/python/bin/syscall-counts-record  |    2 +
 .../perf/scripts/python/bin/syscall-counts-report  |    4 +
 tools/perf/scripts/python/check-perf-trace.py      |   83 +++
 .../perf/scripts/python/failed-syscalls-by-pid.py  |   68 ++
 tools/perf/scripts/python/syscall-counts-by-pid.py |   64 ++
 tools/perf/scripts/python/syscall-counts.py        |   58 ++
 .../perf/util/scripting-engines/trace-event-perl.c |  568 +++++++++++++++++
 .../util/scripting-engines/trace-event-python.c    |  573 +++++++++++++++++
 tools/perf/util/trace-event-parse.c                |   15 +
 tools/perf/util/trace-event-perl.c                 |  661 --------------------
 tools/perf/util/trace-event-perl.h                 |   55 --
 tools/perf/util/trace-event-scripting.c            |  167 +++++
 tools/perf/util/trace-event.h                      |   10 +-
 33 files changed, 2549 insertions(+), 742 deletions(-)
