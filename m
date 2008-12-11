Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbYLKQtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbYLKQtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbYLKQsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:48:43 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:45056 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbYLKQsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:48:42 -0500
X-BigFish: VPS1(zzzzzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KBQ1CR-01-7O1-01
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 10/10] ftrace: remove unused function arg in trace_iterator_increment()
Date: Thu, 11 Dec 2008 16:04:46 +0100
Message-ID: <1229007886-14362-11-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
References: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:26.0948 (UTC) FILETIME=[49EE1040:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the unused cpu function parameter.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d86e325..a96b335 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -914,7 +914,7 @@ enum trace_file_type {
 	TRACE_FILE_LAT_FMT	= 1,
 };
 
-static void trace_iterator_increment(struct trace_iterator *iter, int cpu)
+static void trace_iterator_increment(struct trace_iterator *iter)
 {
 	/* Don't allow ftrace to trace into the ring buffers */
 	ftrace_disable_cpu();
@@ -993,7 +993,7 @@ static void *find_next_entry_inc(struct trace_iterator *iter)
 	iter->ent = __find_next_entry(iter, &iter->cpu, &iter->ts);
 
 	if (iter->ent)
-		trace_iterator_increment(iter, iter->cpu);
+		trace_iterator_increment(iter);
 
 	return iter->ent ? iter : NULL;
 }
-- 
1.6.0.1


