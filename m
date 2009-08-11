Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZHKTWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZHKTWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 15:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbZHKTWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 15:22:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46942 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZHKTWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 15:22:08 -0400
Date: Tue, 11 Aug 2009 16:21:38 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/3] perf report: Show the tid too in -D
Message-ID: <20090811192138.GE18061@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2357c66..ccd5766 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1540,11 +1540,11 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		more_data += sizeof(u64);
 	}
 
-	dprintf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d: %p period: %Ld\n",
+	dprintf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->header.misc,
-		event->ip.pid,
+		event->ip.pid, event->ip.tid,
 		(void *)(long)ip,
 		(long long)period);
 
@@ -1626,10 +1626,11 @@ process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
 	struct thread *thread = threads__findnew(event->mmap.pid);
 	struct map *map = map__new(&event->mmap);
 
-	dprintf("%p [%p]: PERF_EVENT_MMAP %d: [%p(%p) @ %p]: %s\n",
+	dprintf("%p [%p]: PERF_EVENT_MMAP %d/%d: [%p(%p) @ %p]: %s\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->mmap.pid,
+		event->mmap.tid,
 		(void *)(long)event->mmap.start,
 		(void *)(long)event->mmap.len,
 		(void *)(long)event->mmap.pgoff,
-- 
1.6.2.5

