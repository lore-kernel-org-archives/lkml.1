Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbZGRJvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbZGRJvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 05:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758055AbZGRJvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 05:51:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:42248 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273AbZGRJvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 05:51:03 -0400
Date: Sat, 18 Jul 2009 09:50:41 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090716104817.697698033@samba.org>
References: <20090716104817.697698033@samba.org>
Subject: [tip:perfcounters/urgent] perf_counter: Add perf record option to log addresses
Message-ID: <tip-4bba828dd9bb950ad1fe340ef148a5436a10f131@git.kernel.org>
Git-Commit-ID: 4bba828dd9bb950ad1fe340ef148a5436a10f131
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 09:50:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bba828dd9bb950ad1fe340ef148a5436a10f131
Gitweb:     http://git.kernel.org/tip/4bba828dd9bb950ad1fe340ef148a5436a10f131
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 11:21:32 +0200

perf_counter: Add perf record option to log addresses

Add the -d or --data option to log event addresses (eg page
faults).

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090716104817.697698033@samba.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 072aaf0..68a9be0 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -43,6 +43,7 @@ static int			call_graph			= 0;
 static int			verbose				= 0;
 static int			inherit_stat			= 0;
 static int			no_samples			= 0;
+static int			sample_address			= 0;
 
 static long			samples;
 static struct timeval		last_read;
@@ -405,6 +406,9 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	if (inherit_stat)
 		attr->inherit_stat = 1;
 
+	if (sample_address)
+		attr->sample_type	|= PERF_SAMPLE_ADDR;
+
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
@@ -649,6 +653,8 @@ static const struct option options[] = {
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('s', "stat", &inherit_stat,
 		    "per thread counts"),
+	OPT_BOOLEAN('d', "data", &sample_address,
+		    "Sample addresses"),
 	OPT_BOOLEAN('n', "no-samples", &no_samples,
 		    "don't sample"),
 	OPT_END()
