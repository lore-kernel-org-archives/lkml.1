Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZHMIkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZHMIkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZHMIkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:40:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:33445 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbZHMIkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:40:51 -0400
Date: Thu, 13 Aug 2009 08:40:18 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250152039-7284-2-git-send-email-fweisbec@gmail.com>
References: <1250152039-7284-2-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf tools: Add a general option to enable raw sample records
Message-ID: <tip-daac07b2e6b77f1bd44104aa2f0593e5505f27d4@git.kernel.org>
Git-Commit-ID: daac07b2e6b77f1bd44104aa2f0593e5505f27d4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Aug 2009 08:40:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  daac07b2e6b77f1bd44104aa2f0593e5505f27d4
Gitweb:     http://git.kernel.org/tip/daac07b2e6b77f1bd44104aa2f0593e5505f27d4
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 13 Aug 2009 10:27:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 13 Aug 2009 10:37:25 +0200

perf tools: Add a general option to enable raw sample records

While we can enable the perf sample records per tracepoint
counter, we may also want to enable this option for every
tracepoint counters to open, so that we don't need to add a
:record flag for all of them.

Add the -R, --raw-samples options for this purpose.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1250152039-7284-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 78adc47..3d051b9 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -34,6 +34,7 @@ static int			output;
 static const char		*output_name			= "perf.data";
 static int			group				= 0;
 static unsigned int		realtime_prio			= 0;
+static int			raw_samples			= 0;
 static int			system_wide			= 0;
 static int			profile_cpu			= -1;
 static pid_t			target_pid			= -1;
@@ -418,6 +419,8 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
+	if (raw_samples)
+		attr->sample_type	|= PERF_SAMPLE_RAW;
 
 	attr->mmap		= track;
 	attr->comm		= track;
@@ -650,6 +653,8 @@ static const struct option options[] = {
 		    "record events on existing pid"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
+	OPT_BOOLEAN('R', "raw-samples", &raw_samples,
+		    "collect raw sample records from all opened counters"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 			    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('A', "append", &append_file,
