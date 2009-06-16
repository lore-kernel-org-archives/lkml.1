Return-Path: <linux-kernel-owner+w=401wt.eu-S1761270AbZFPRyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270AbZFPRyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbZFPRx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:53:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34592 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFPRxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:53:23 -0400
Message-Id: <20090616175323.844879910@goodmis.org>
References: <20090616175133.317996432@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 16 Jun 2009 13:51:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/5] tracing/filters: free filter_string in destroy_preds()
Content-Disposition: inline; filename=0004-tracing-filters-free-filter_string-in-destroy_preds.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

filter->filter_string is not freed when unloading a module:

 # insmod trace-events-sample.ko
 # echo "bar < 100" > /mnt/tracing/events/sample/foo_bar/filter
 # rmmod trace-events-sample.ko

[ Impact: fix memory leak when unloading module ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A375A30.9060802@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index b24ab0e..d9f01c1 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -381,6 +381,7 @@ void destroy_preds(struct ftrace_event_call *call)
 			filter_free_pred(filter->preds[i]);
 	}
 	kfree(filter->preds);
+	kfree(filter->filter_string);
 	kfree(filter);
 	call->filter = NULL;
 }
-- 
1.6.3.1

-- 
