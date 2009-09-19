Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbZISRCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbZISRCV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 13:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZISRCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 13:02:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:36567 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbZISRCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 13:02:17 -0400
Date: Sat, 19 Sep 2009 17:01:54 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, arjan@infradead.org,
       hpa@zytor.com, mingo@redhat.com, arjan@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, arjan@infradead.org,
       paulus@samba.org, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090919133630.10533d3e@infradead.org>
References: <20090919133630.10533d3e@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf utils: Use a define for the maximum length of a trace event
Message-ID: <tip-ec60a3fe478c0fc6d109eb5840b435ecee4d132b@git.kernel.org>
Git-Commit-ID: ec60a3fe478c0fc6d109eb5840b435ecee4d132b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 17:01:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec60a3fe478c0fc6d109eb5840b435ecee4d132b
Gitweb:     http://git.kernel.org/tip/ec60a3fe478c0fc6d109eb5840b435ecee4d132b
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Sat, 19 Sep 2009 13:36:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 18:57:53 +0200

perf utils: Use a define for the maximum length of a trace event

As per Ingo's review: use a #define rather than an open coded constant
for the maximum length of a trace event for storing in the perf.data file.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: fweisbec@gmail.com
Cc: peterz@infradead.org
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090919133630.10533d3e@infradead.org>
[ add a few comments to nearby functions ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/header.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ef91145..bb4fca3 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -7,9 +7,8 @@
 #include "header.h"
 
 /*
- *
+ * Create new perf.data header attribute:
  */
-
 struct perf_header_attr *perf_header_attr__new(struct perf_counter_attr *attr)
 {
 	struct perf_header_attr *self = malloc(sizeof(*self));
@@ -43,9 +42,8 @@ void perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
 }
 
 /*
- *
+ * Create new perf.data header:
  */
-
 struct perf_header *perf_header__new(void)
 {
 	struct perf_header *self = malloc(sizeof(*self));
@@ -86,9 +84,11 @@ void perf_header__add_attr(struct perf_header *self,
 	self->attr[pos] = attr;
 }
 
+#define MAX_EVENT_NAME 64
+
 struct perf_trace_event_type {
 	u64	event_id;
-	char	name[64];
+	char	name[MAX_EVENT_NAME];
 };
 
 static int event_count;
@@ -96,7 +96,7 @@ static struct perf_trace_event_type *events;
 
 void perf_header__push_event(u64 id, const char *name)
 {
-	if (strlen(name) > 64)
+	if (strlen(name) > MAX_EVENT_NAME)
 		printf("Event %s will be truncated\n", name);
 
 	if (!events) {
@@ -110,7 +110,7 @@ void perf_header__push_event(u64 id, const char *name)
 	}
 	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
 	events[event_count].event_id = id;
-	strncpy(events[event_count].name, name, 63);
+	strncpy(events[event_count].name, name, MAX_EVENT_NAME - 1);
 	event_count++;
 }
 
