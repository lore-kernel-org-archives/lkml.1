Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbZDFJqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbZDFJqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661AbZDFJol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:42346 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbZDFJog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:36 -0400
Message-Id: <20090406094518.211174347@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:08 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/15] perf_counter: comment the perf_event_type stuff
Content-Disposition: inline; filename=perf_counter-event-comment.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe the event format.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -207,6 +207,20 @@ struct perf_event_header {
 
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
 
@@ -216,6 +230,24 @@ enum perf_event_type {
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

-- 

