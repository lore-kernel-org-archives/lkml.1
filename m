Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbZHNKFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbZHNKFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 06:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbZHNKFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 06:05:12 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:37981 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZHNKFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 06:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SFCAwbGYaYlqBOqtBnDIbeVJpbnuuECMH8OWbCPPQ9cnIRLDcmX9xGnwJ9k459tE1G
         3D55KRF37x2y6kP2RUy/AYgF4/3/J/WQxdaDwU3TQkQk/O/EkmNBrU3CuTA9eCIU1DfU
         iIoN5BK24bNz0hS0bflTi4GKs8z2ITapOZDLk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH 2/2] perf tools: Add a general option to enable raw sample records
Date: Fri, 14 Aug 2009 12:05:00 +0200
Message-Id: <1250244300-6343-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250244300-6343-1-git-send-email-fweisbec@gmail.com>
References: <1250244300-6343-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we can enable the perf sample records per tracepoint counter,
we may also want to enable this option for every tracepoint
counters to open, so that we don't need to add a :record flag
for all of them.

Add the -R, --raw-samples options for this purpose.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/builtin-record.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3be0301..e67c4fa 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -35,6 +35,7 @@ static int			output;
 static const char		*output_name			= "perf.data";
 static int			group				= 0;
 static unsigned int		realtime_prio			= 0;
+static int			raw_samples			= 0;
 static int			system_wide			= 0;
 static int			profile_cpu			= -1;
 static pid_t			target_pid			= -1;
@@ -400,6 +401,8 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
+	if (raw_samples)
+		attr->sample_type	|= PERF_SAMPLE_RAW;
 
 	attr->mmap		= track;
 	attr->comm		= track;
@@ -632,6 +635,8 @@ static const struct option options[] = {
 		    "record events on existing pid"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
+	OPT_BOOLEAN('R', "raw-samples", &raw_samples,
+		    "collect raw sample records from all opened counters"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 			    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('A', "append", &append_file,
-- 
1.6.2.3

