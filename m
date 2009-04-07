Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZDGJKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZDGJKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZDGJJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:09:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:47068 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936AbZDGJJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:09:15 -0400
Date: Tue, 7 Apr 2009 09:08:37 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090406094518.211174347@chello.nl>
References: <20090406094518.211174347@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: comment the perf_event_type stuff
Message-ID: <tip-0c593b3411341e3a05a61f5527df36ab02bd11e8@git.kernel.org>
Git-Commit-ID: 0c593b3411341e3a05a61f5527df36ab02bd11e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:08:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c593b3411341e3a05a61f5527df36ab02bd11e8
Gitweb:     http://git.kernel.org/tip/0c593b3411341e3a05a61f5527df36ab02bd11e8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Apr 2009 11:45:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 10:48:59 +0200

perf_counter: comment the perf_event_type stuff

Describe the event format.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090406094518.211174347@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index ef4dcbf..8122018 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -208,6 +208,20 @@ struct perf_event_header {
 
 enum perf_event_type {
 
+	/*
+	 * The MMAP events record the PROT_EXEC mappings so that we can
+	 * correlate userspace IPs to code. They have the following structure:
+	 *
+	 * struct {
+	 * 	struct perf_event_header	header;
+	 *
+	 * 	u32				pid, tid;
+	 * 	u64				addr;
+	 * 	u64				len;
+	 * 	u64				pgoff;
+	 * 	char				filename[];
+	 * };
+	 */
 	PERF_EVENT_MMAP			= 1,
 	PERF_EVENT_MUNMAP		= 2,
 
@@ -217,6 +231,24 @@ enum perf_event_type {
 	 *
 	 * These events will have types of the form:
 	 *   PERF_EVENT_COUNTER_OVERFLOW { | __PERF_EVENT_* } *
+	 *
+	 * struct {
+	 * 	struct perf_event_header	header;
+	 *
+	 * 	{ u64			ip;	  } && __PERF_EVENT_IP
+	 * 	{ u32			pid, tid; } && __PERF_EVENT_TID
+	 *
+	 * 	{ u64			nr;
+	 * 	  { u64 event, val; } 	cnt[nr];  } && __PERF_EVENT_GROUP
+	 *
+	 * 	{ u16			nr,
+	 * 				hv,
+	 * 				kernel,
+	 * 				user;
+	 * 	  u64			ips[nr];  } && __PERF_EVENT_CALLCHAIN
+	 *
+	 * 	{ u64			time;     } && __PERF_EVENT_TIME
+	 * };
 	 */
 	PERF_EVENT_COUNTER_OVERFLOW	= 1UL << 31,
 	__PERF_EVENT_IP			= PERF_RECORD_IP,
