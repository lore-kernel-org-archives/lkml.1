Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbZJLW00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbZJLW00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbZJLW0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:26:23 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:4094 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600AbZJLW0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sFnHkmzhXkDiEfQE0ZCIjDVDiVboT5JmkmIS8FDj0uf65PZiKItDrgLQIw3MkCrSa+
         WlyvvUV2oDcxSzsOuH4z9vbrDRGSBTU0AK7Kf+VUu16pihGotDmDvQ5ILj8OX7o2sgGm
         6REHHdy5K0ghRwHfiV9wSBK575hEnMgzUEJck=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch . Eigler" <fche@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [GIT PULL] tracing/kprobes: Syntax updates, introduce perf probe
Date: Tue, 13 Oct 2009 00:25:01 +0200
Message-Id: <1255386309-4992-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I've tested a little this set and it seems to work well. I can't test
the C expression parser (need some libdwarf cross-version compatiblity),
but I can create kprobes via low-level parameters, then launch
perf record and perf trace successfully. I'll need to update
perf trace to handle variables that start with '$' characters though.

Anyway, it's still unstable but I guess pulling it would
help Masami to continue without the need to handle the
whole batch.

Please pull the tracing/kprobes branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/kprobes

Thanks,
	Frederic.

Masami Hiramatsu (7):
      tracing/kprobes: Add $ prefix to special variables
      tracing/kprobes: Remove '$ra' special variable
      tracing/kprobes: Make special variable names more self-explainable
      tracing/kprobes: Avoid field name confliction
      tracing/kprobes: Robustify fixed field names against variable field names conflicts
      perf: Add perf probe subcommand, a kprobe-event setup helper
      perf probe: Add perf probe command support without libdwarf

 Documentation/trace/kprobetrace.txt |   27 +-
 kernel/trace/trace_kprobe.c         |  160 +++++---
 tools/perf/Makefile                 |   10 +
 tools/perf/builtin-probe.c          |  386 +++++++++++++++++++
 tools/perf/builtin.h                |    1 +
 tools/perf/perf.c                   |    1 +
 tools/perf/util/probe-finder.c      |  690 +++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-finder.h      |   70 ++++
 8 files changed, 1271 insertions(+), 74 deletions(-)
 create mode 100644 tools/perf/builtin-probe.c
 create mode 100644 tools/perf/util/probe-finder.c
 create mode 100644 tools/perf/util/probe-finder.h
