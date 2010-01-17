Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210Ab0AQHAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab0AQHAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 02:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846Ab0AQHAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 02:00:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:46608 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab0AQHAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 02:00:48 -0500
Date: Sun, 17 Jan 2010 06:58:37 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, efault@gmx.de, fweisbec@gmail.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100116125319.34ac3edd@infradead.org>
References: <20100116125319.34ac3edd@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf timechart: Use tid not pid for COMM change
Message-ID: <tip-8f06d7e6e1bbfb32698d6d455583ab7460c090e2@git.kernel.org>
Git-Commit-ID: 8f06d7e6e1bbfb32698d6d455583ab7460c090e2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 17 Jan 2010 06:58:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f06d7e6e1bbfb32698d6d455583ab7460c090e2
Gitweb:     http://git.kernel.org/tip/8f06d7e6e1bbfb32698d6d455583ab7460c090e2
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sat, 16 Jan 2010 12:53:19 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 17 Jan 2010 07:16:36 +0100

perf timechart: Use tid not pid for COMM change

A process that changes its comm field, does this on a per kernel
task struct basis. The timechart tool used, incorrectly, the pid
to track this, and should have used the tid instead...

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
CC: <stable@kernel.org>
LKML-Reference: <20100116125319.34ac3edd@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-timechart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index a589a43..3f8bbcf 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -280,7 +280,7 @@ static u64 cpus_pstate_state[MAX_CPUS];
 
 static int process_comm_event(event_t *event, struct perf_session *session __used)
 {
-	pid_set_comm(event->comm.pid, event->comm.comm);
+	pid_set_comm(event->comm.tid, event->comm.comm);
 	return 0;
 }
 
