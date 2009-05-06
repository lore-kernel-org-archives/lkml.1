Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbZEFMUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbZEFMUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759573AbZEFMUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:20:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:36007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759602AbZEFMUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:20:09 -0400
Date: Wed, 6 May 2009 12:19:11 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A00F6AD.2070008@cn.fujitsu.com>
References: <4A00F6AD.2070008@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: don't say hi when loading the trace event sample
Message-ID: <tip-fd6da10a617f483348ee32bcfe53fd20c302eca1@git.kernel.org>
Git-Commit-ID: fd6da10a617f483348ee32bcfe53fd20c302eca1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 12:19:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd6da10a617f483348ee32bcfe53fd20c302eca1
Gitweb:     http://git.kernel.org/tip/fd6da10a617f483348ee32bcfe53fd20c302eca1
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 6 May 2009 10:32:13 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 6 May 2009 10:38:18 +0200

tracing/events: don't say hi when loading the trace event sample

The sample is useful for testing, and I'm using it. But after
loading the module, it keeps saying hi every 10 seconds, this may
be disturbing.

Also Steven said commenting out the "hi" helped in causing races. :)

[ Impact: make testing a bit easier ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A00F6AD.2070008@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
