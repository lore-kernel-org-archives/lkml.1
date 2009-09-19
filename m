Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbZISLhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbZISLhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 07:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZISLhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 07:37:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:50805 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619AbZISLgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 07:36:33 -0400
Date: Sat, 19 Sep 2009 13:36:30 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, peterz@infradead.org,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf: Use a define for the maximum length of a trace event
Message-ID: <20090919133630.10533d3e@infradead.org>
In-Reply-To: <20090919133410.7b23e270@infradead.org>
References: <20090919133410.7b23e270@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From e5f5037ae4423c188aa68ee6ba239708bb720722 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 19 Sep 2009 13:21:20 +0200
Subject: [PATCH] perf: Use a define for the maximum length of a trace event

As per Ingo's review: use a #define rather than an open coded constant
for the maximum length of a trace event for storing in the perf.data file.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 tools/perf/util/header.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ef91145..ed6b553 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -86,9 +86,10 @@ void perf_header__add_attr(struct perf_header *self,
 	self->attr[pos] = attr;
 }
 
+#define MAX_EVENT_NAME 64
 struct perf_trace_event_type {
 	u64	event_id;
-	char	name[64];
+	char	name[MAX_EVENT_NAME];
 };
 
 static int event_count;
@@ -96,7 +97,7 @@ static struct perf_trace_event_type *events;
 
 void perf_header__push_event(u64 id, const char *name)
 {
-	if (strlen(name) > 64)
+	if (strlen(name) > MAX_EVENT_NAME)
 		printf("Event %s will be truncated\n", name);
 
 	if (!events) {
@@ -110,7 +111,7 @@ void perf_header__push_event(u64 id, const char *name)
 	}
 	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
 	events[event_count].event_id = id;
-	strncpy(events[event_count].name, name, 63);
+	strncpy(events[event_count].name, name, MAX_EVENT_NAME - 1);
 	event_count++;
 }
 
-- 
1.6.0.6




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
