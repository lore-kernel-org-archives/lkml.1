Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZDBMFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZDBMFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZDBMEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:04:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:51760 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344AbZDBMEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:04:47 -0400
Date: Thu, 2 Apr 2009 12:03:58 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090402091319.407283141@chello.nl>
References: <20090402091319.407283141@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: kerneltop: update to new ABI
Message-ID: <tip-373b153677f26a263ef297d77a5e045a31f6486c@git.kernel.org>
Git-Commit-ID: 373b153677f26a263ef297d77a5e045a31f6486c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 12:04:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  373b153677f26a263ef297d77a5e045a31f6486c
Gitweb:     http://git.kernel.org/tip/373b153677f26a263ef297d77a5e045a31f6486c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 2 Apr 2009 11:12:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Apr 2009 13:53:00 +0200

perf_counter: kerneltop: update to new ABI

Update to reflect the new record_type ABI changes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090402091319.407283141@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/kerneltop.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/perf_counter/kerneltop.c b/Documentation/perf_counter/kerneltop.c
index 33b4fcf..4f8d791 100644
--- a/Documentation/perf_counter/kerneltop.c
+++ b/Documentation/perf_counter/kerneltop.c
@@ -442,7 +442,7 @@ static void create_perfstat_counter(int counter)
 
 	memset(&hw_event, 0, sizeof(hw_event));
 	hw_event.config		= event_id[counter];
-	hw_event.record_type	= PERF_RECORD_SIMPLE;
+	hw_event.record_type	= 0;
 	hw_event.nmi		= 0;
 	if (scale)
 		hw_event.read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
@@ -1277,8 +1277,8 @@ static void mmap_read(struct mmap_data *md)
 		old += size;
 
 		switch (event->header.type) {
-		case PERF_EVENT_OVERFLOW | __PERF_EVENT_IP:
-		case PERF_EVENT_OVERFLOW | __PERF_EVENT_IP | __PERF_EVENT_TID:
+		case PERF_EVENT_COUNTER_OVERFLOW | __PERF_EVENT_IP:
+		case PERF_EVENT_COUNTER_OVERFLOW | __PERF_EVENT_IP | __PERF_EVENT_TID:
 			process_event(event->ip.ip, md->counter);
 			break;
 
@@ -1337,9 +1337,8 @@ int main(int argc, char *argv[])
 			memset(&hw_event, 0, sizeof(hw_event));
 			hw_event.config		= event_id[counter];
 			hw_event.irq_period	= event_count[counter];
-			hw_event.record_type	= PERF_RECORD_IRQ;
+			hw_event.record_type	= PERF_RECORD_IP | PERF_RECORD_TID;
 			hw_event.nmi		= nmi;
-			hw_event.include_tid	= 1;
 			hw_event.mmap		= use_mmap;
 			hw_event.munmap		= use_munmap;
 
