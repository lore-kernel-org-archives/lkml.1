Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbZEZSKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbZEZSKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbZEZSKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:10:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:44326 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756729AbZEZSKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:10:20 -0400
Date: Tue, 26 May 2009 18:09:42 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: add more debugging
Message-ID: <tip-f95f33e6d0e6ee55f8ed62f70e4febe23e4830dc@git.kernel.org>
Git-Commit-ID: f95f33e6d0e6ee55f8ed62f70e4febe23e4830dc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 18:09:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f95f33e6d0e6ee55f8ed62f70e4febe23e4830dc
Gitweb:     http://git.kernel.org/tip/f95f33e6d0e6ee55f8ed62f70e4febe23e4830dc
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 19:03:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 19:03:36 +0200

perf report: add more debugging

Add the offset of the file we are analyzing.

In case of problems it's easier to see where the parser lost track.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 4b5ccc5..1b16f81 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -709,7 +709,8 @@ more:
 		uint64_t ip = event->ip.ip;
 
 		if (dump_trace) {
-			fprintf(stderr, "PERF_EVENT (IP, %d): %d: %p\n",
+			fprintf(stderr, "%p: PERF_EVENT (IP, %d): %d: %p\n",
+				(void *)(offset + head),
 				event->header.misc,
 				event->ip.pid,
 				(void *)event->ip.ip);
@@ -753,7 +754,8 @@ more:
 		struct map *map = map__new(&event->mmap);
 
 		if (dump_trace) {
-			fprintf(stderr, "PERF_EVENT_MMAP: [%p(%p) @ %p]: %s\n",
+			fprintf(stderr, "%p: PERF_EVENT_MMAP: [%p(%p) @ %p]: %s\n",
+				(void *)(offset + head),
 				(void *)event->mmap.start,
 				(void *)event->mmap.len,
 				(void *)event->mmap.pgoff,
@@ -771,7 +773,8 @@ more:
 		struct thread *thread = threads__findnew(event->comm.pid);
 
 		if (dump_trace) {
-			fprintf(stderr, "PERF_EVENT_COMM: %s:%d\n",
+			fprintf(stderr, "%p: PERF_EVENT_COMM: %s:%d\n",
+				(void *)(offset + head),
 				event->comm.comm, event->comm.pid);
 		}
 		if (thread == NULL ||
@@ -783,7 +786,8 @@ more:
 		break;
 	}
 	default: {
-		fprintf(stderr, "skipping unknown header type: %d\n",
+		fprintf(stderr, "%p: skipping unknown header type: %d\n",
+			(void *)(offset + head),
 			event->header.type);
 		total_unknown++;
 	}
