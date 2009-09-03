Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZICO2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZICO2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZICO2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:28:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:55070 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445AbZICO2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:28:33 -0400
Date: Thu, 3 Sep 2009 14:28:03 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf trace: Print out in nanoseconds
Message-ID: <tip-00fc97863c21c41e257a941e83410c56341e2a5d@git.kernel.org>
Git-Commit-ID: 00fc97863c21c41e257a941e83410c56341e2a5d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 03 Sep 2009 14:28:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00fc97863c21c41e257a941e83410c56341e2a5d
Gitweb:     http://git.kernel.org/tip/00fc97863c21c41e257a941e83410c56341e2a5d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 3 Sep 2009 16:22:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Sep 2009 16:22:02 +0200

perf trace: Print out in nanoseconds

Print out more accurate timestamps - usecs does not cut it
anymore on fast enough boxes ;-)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/trace-event-parse.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 37b10c2..629e602 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2708,9 +2708,9 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 		return pretty_print_func_graph(data, size, event, cpu,
 					       pid, comm, secs, usecs);
 
-	printf("%16s-%-5d [%03d] %5lu.%06lu: %s: ",
+	printf("%16s-%-5d [%03d] %5lu.%09Lu: %s: ",
 	       comm, pid,  cpu,
-	       secs, usecs, event->name);
+	       secs, nsecs, event->name);
 
 	pretty_print(data, size, event);
 	printf("\n");
