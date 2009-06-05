Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbZFEQ6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbZFEQ6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZFEQ6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:58:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:60876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbZFEQ6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:58:13 -0400
Date: Fri, 5 Jun 2009 16:57:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Change PERF_SAMPLE_CONFIG into PERF_SAMPLE_ID
Message-ID: <tip-ac4bcf889469ffbca88f234d3184452886a47905@git.kernel.org>
Git-Commit-ID: ac4bcf889469ffbca88f234d3184452886a47905
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 16:57:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac4bcf889469ffbca88f234d3184452886a47905
Gitweb:     http://git.kernel.org/tip/ac4bcf889469ffbca88f234d3184452886a47905
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 5 Jun 2009 14:44:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 18:07:47 +0200

perf_counter: Change PERF_SAMPLE_CONFIG into PERF_SAMPLE_ID

The purpose of PERF_SAMPLE_CONFIG was to identify the counters,
since then we've added counter ids, use those instead.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 +-
 kernel/perf_counter.c        |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 40dc0e2..9cea32a 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -104,7 +104,7 @@ enum perf_counter_sample_format {
 	PERF_SAMPLE_ADDR		= 1U << 3,
 	PERF_SAMPLE_GROUP		= 1U << 4,
 	PERF_SAMPLE_CALLCHAIN		= 1U << 5,
-	PERF_SAMPLE_CONFIG		= 1U << 6,
+	PERF_SAMPLE_ID			= 1U << 6,
 	PERF_SAMPLE_CPU			= 1U << 7,
 };
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 37a5a24..e75b91a 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2392,8 +2392,8 @@ static void perf_counter_output(struct perf_counter *counter,
 		header.size += sizeof(u64);
 	}
 
-	if (sample_type & PERF_SAMPLE_CONFIG) {
-		header.type |= PERF_SAMPLE_CONFIG;
+	if (sample_type & PERF_SAMPLE_ID) {
+		header.type |= PERF_SAMPLE_ID;
 		header.size += sizeof(u64);
 	}
 
@@ -2439,8 +2439,8 @@ static void perf_counter_output(struct perf_counter *counter,
 	if (sample_type & PERF_SAMPLE_ADDR)
 		perf_output_put(&handle, addr);
 
-	if (sample_type & PERF_SAMPLE_CONFIG)
-		perf_output_put(&handle, counter->attr.config);
+	if (sample_type & PERF_SAMPLE_ID)
+		perf_output_put(&handle, counter->id);
 
 	if (sample_type & PERF_SAMPLE_CPU)
 		perf_output_put(&handle, cpu_entry);
