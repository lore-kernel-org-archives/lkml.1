Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab0CEDIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 22:08:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:22892 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab0CEDIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 22:08:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JMNEsD/3ZUEeabvf5fahTH2o2AmXrU9Gxhq3mB41/MEHC7Vq40LW40KTQVkSgM100t
         jP4s11EEG7TFh+uvTYe0mvb/LN1Z0A51sVi4N/50tMmA4nS4d7JZ5Fd3PVjlx5i0jxpc
         2C5kg5KEXZ2sR2Lpdnxm2UsK4ig0CPdw/YELc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Archs <linux-arch@vger.kernel.org>
Subject: [PATCH 0/2] Perf hot regs snapshot for trace events
Date: Fri,  5 Mar 2010 04:08:04 +0100
Message-Id: <1267758486-30499-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267605529.25158.75.camel@laptop>
References: <1267605529.25158.75.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please tell me what you think about this new version.
I still can not fallback to save the ip for archs that
don't implement it as it can't be done in a generic way,
but more work has been made to implement this support
more easily.

No more assembly in this new version, it also uses
functions instead of macros and it implements the callers
level skipping. Then instead of starting the callchain from
perf/ftrace event callbacks, we start on the real event
source.

Thanks.

Frederic Weisbecker (2):
  perf: Introduce new perf_save_regs() for hot regs snapshot
  perf: Take a hot regs snapshot for trace events

 arch/x86/kernel/cpu/perf_event.c   |   12 ++++++++++
 arch/x86/kernel/dumpstack.h        |   15 ++++++++++++
 include/linux/ftrace_event.h       |    7 ++++-
 include/linux/perf_event.h         |   42 +++++++++++++++++++++++++++++++++++-
 include/trace/ftrace.h             |    6 ++++-
 kernel/perf_event.c                |   14 ++++++------
 kernel/trace/trace_event_profile.c |    3 +-
 kernel/trace/trace_kprobe.c        |    5 ++-
 kernel/trace/trace_syscalls.c      |    4 +-
 9 files changed, 92 insertions(+), 16 deletions(-)

