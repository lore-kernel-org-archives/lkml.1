Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbZLNVor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbZLNVor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZLNVoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:44:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61232 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZLNVop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:44:45 -0500
X-Authority-Analysis: v=1.0 c=1 a=BumbXsDs0-UA:10 a=7U3hwN5JcxgA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=yZRmKpSYK0p-MiPEGp8A:9 a=UQxRyR0zFLKh4Bh_pssA:7 a=rzWYwY72WEqOewSDwtrgQHhqpRQA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL] tracing: Fix return of trace_dump_stack()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20091214162713.GA31060@elte.hu>
References: <20091211184018.738768739@goodmis.org>
	 <20091214161257.GA20097@elte.hu>  <20091214162713.GA31060@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 14 Dec 2009 16:44:34 -0500
Message-ID: <1260827074.2146.424.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (1):
      tracing: Fix return of trace_dump_stack()

----
 include/linux/kernel.h |    1 +
 kernel/trace/trace.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)
---------------------------
commit aa43d935e677296088fb9b9c2060abbad0ccf648
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon Dec 14 15:58:33 2009 -0500

    tracing: Fix return of trace_dump_stack()
    
    The trace_dump_stack() returned a value for a void function.
    
    Also, added the missing stub for trace_dump_stack() when tracing is
    not configured.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    LKML-Reference: <20091214162713.GA31060@elte.hu>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 5ad4199..f1dc752 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -527,6 +527,7 @@ trace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
 static inline void ftrace_off_permanent(void) { }
+static inline void trace_dump_stack(void) { }
 static inline int
 trace_printk(const char *fmt, ...)
 {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f531301..1cf8734 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1159,7 +1159,7 @@ void trace_dump_stack(void)
 	unsigned long flags;
 
 	if (tracing_disabled || tracing_selftest_running)
-		return 0;
+		return;
 
 	local_save_flags(flags);
 


