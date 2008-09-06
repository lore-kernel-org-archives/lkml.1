Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbYIFFJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbYIFFJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 01:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYIFFJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 01:09:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47350 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbYIFFJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 01:09:08 -0400
Message-Id: <20080906050905.931087594@goodmis.org>
References: <20080906050602.409299112@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 01:06:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] ftrace: use ftrace_release for all dynamic ftrace functions
Content-Disposition: inline; filename=ftrace-release-depend-on-ftrace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftrace_release is necessary for all uses of dynamic ftrace and not just
the archs that have CONFIG_FTRACE_MCOUNT_RECORD defined.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-09-05 16:04:34.000000000 -0700
+++ linux-tip.git/include/linux/ftrace.h	2008-09-05 20:10:47.000000000 -0700
@@ -77,8 +77,10 @@ extern void mcount_call(void);
 
 extern int skip_trace(unsigned long ip);
 
-void ftrace_disable_daemon(void);
-void ftrace_enable_daemon(void);
+extern void ftrace_release(void *start, unsigned long size);
+
+extern void ftrace_disable_daemon(void);
+extern void ftrace_enable_daemon(void);
 
 #else
 # define skip_trace(ip)				({ 0; })
@@ -86,6 +88,7 @@ void ftrace_enable_daemon(void);
 # define ftrace_set_filter(buf, len, reset)	do { } while (0)
 # define ftrace_disable_daemon()		do { } while (0)
 # define ftrace_enable_daemon()			do { } while (0)
+static inline void ftrace_release(void *start, unsigned long size) { }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /* totally disable ftrace - can not re-enable after this */
@@ -199,12 +202,10 @@ static inline void ftrace_dump(void) { }
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 extern void ftrace_init(void);
 extern void ftrace_init_module(unsigned long *start, unsigned long *end);
-extern void ftrace_release(void *start, unsigned long size);
 #else
 static inline void ftrace_init(void) { }
 static inline void
 ftrace_init_module(unsigned long *start, unsigned long *end) { }
-static inline void ftrace_release(void *start, unsigned long size) { }
 #endif
 
 

-- 
