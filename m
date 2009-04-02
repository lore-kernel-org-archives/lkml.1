Return-Path: <linux-kernel-owner+w=401wt.eu-S932090AbZDBJNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbZDBJNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760845AbZDBJMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:12:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59147 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293AbZDBJMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:12:51 -0400
Message-Id: <20090402091319.407283141@chello.nl>
References: <20090402091158.291810516@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 11:12:02 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/6] perf_counter: kerneltop: update to new ABI
Content-Disposition: inline; filename=kerneltop-new-abi.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update to reflect the new record_type ABI changes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/kerneltop.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6/Documentation/perf_counter/kerneltop.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/kerneltop.c
+++ linux-2.6/Documentation/perf_counter/kerneltop.c
@@ -442,7 +442,7 @@ static void create_perfstat_counter(int 
 
 	memset(&hw_event, 0, sizeof(hw_event));
 	hw_event.config		= event_id[counter];
-	hw_event.record_type	= PERF_RECORD_SIMPLE;
+	hw_event.record_type	= 0;
 	hw_event.nmi		= 0;
 	if (scale)
 		hw_event.read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
@@ -1277,8 +1277,8 @@ static void mmap_read(struct mmap_data *
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
 

-- 

