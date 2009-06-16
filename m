Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZFPIhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZFPIhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZFPIhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:37:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51968 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbZFPIhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:37:36 -0400
Message-ID: <4A375A30.9060802@cn.fujitsu.com>
Date: Tue, 16 Jun 2009 16:39:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/filters: free filter_string in destroy_preds()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

filter->filter_string is not freed when unloading a module:

 # insmod trace-events-sample.ko
 # echo "bar < 100" > /mnt/tracing/events/sample/foo_bar/filter
 # rmmod trace-events-sample.ko

[ Impact: fix memory leak when unloading module ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.5.4.rc3

