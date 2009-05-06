Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZEFCbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZEFCbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZEFCbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:31:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58697 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbZEFCbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:31:22 -0400
Message-ID: <4A00F6AD.2070008@cn.fujitsu.com>
Date: Wed, 06 May 2009 10:32:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] tracing/events: don't say hi when loading the trace event
 sample
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sample is useful for testing, and I'm using it. But after
loading the module, it keeps saying hi every 10 seconds, this may
be disturbing.

Also Steven said commenting out the "hi" helped in causing races. :)

[ Impact: make testing a bit easier ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 samples/trace_events/trace-events-sample.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/samples/trace_events/trace-events-sample.c b/samples/trace_events/trace-events-sample.c
index f33b3ba..aabc4e9 100644
--- a/samples/trace_events/trace-events-sample.c
+++ b/samples/trace_events/trace-events-sample.c
@@ -16,10 +16,6 @@ static void simple_thread_func(int cnt)
 	set_current_state(TASK_INTERRUPTIBLE);
 	schedule_timeout(HZ);
 	trace_foo_bar("hello", cnt);
-
-	if (!(cnt % 10))
-		/* It is really important that I say "hi!" */
-		printk(KERN_EMERG "hi!\n");
 }
 
 static int simple_thread(void *arg)
-- 
1.5.4.rc3


