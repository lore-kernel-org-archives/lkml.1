Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbZHRJkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbZHRJkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 05:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZHRJkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 05:40:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:32990 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbZHRJkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 05:40:35 -0400
Date: Tue, 18 Aug 2009 09:39:35 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       kyle@mcmartin.ca, fweisbec@gmail.com, tglx@linutronix.de, deller@gmx.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       kyle@mcmartin.ca, fweisbec@gmail.com, tglx@linutronix.de, deller@gmx.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter: Fix the PARISC build
Message-ID: <tip-f738eb1b63edf664da1b4ac76895d988749b2f07@git.kernel.org>
Git-Commit-ID: f738eb1b63edf664da1b4ac76895d988749b2f07
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 09:39:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f738eb1b63edf664da1b4ac76895d988749b2f07
Gitweb:     http://git.kernel.org/tip/f738eb1b63edf664da1b4ac76895d988749b2f07
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 18 Aug 2009 11:32:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 11:34:13 +0200

perf_counter: Fix the PARISC build

PARISC does not build:

/home/mingo/tip/kernel/perf_counter.c: In function 'perf_counter_index':
/home/mingo/tip/kernel/perf_counter.c:2016: error: 'PERF_COUNTER_INDEX_OFFSET' undeclared (first use in this function)
/home/mingo/tip/kernel/perf_counter.c:2016: error: (Each undeclared identifier is reported only once
/home/mingo/tip/kernel/perf_counter.c:2016: error: for each function it appears in.)

As PERF_COUNTER_INDEX_OFFSET is not defined.

Now, we could define it in the architecture - but lets also provide
a core default of 0 (which happens to be what all but one
architecture uses at the moment).

Architectures that need a different index offset should set this
value in their asm/perf_counter.h files.

Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index b8fe739..36f65e2 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2019,6 +2019,10 @@ int perf_counter_task_disable(void)
 	return 0;
 }
 
+#ifndef PERF_COUNTER_INDEX_OFFSET
+# define PERF_COUNTER_INDEX_OFFSET 0
+#endif
+
 static int perf_counter_index(struct perf_counter *counter)
 {
 	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
