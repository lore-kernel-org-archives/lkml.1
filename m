Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYJ2QZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYJ2QZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYJ2QY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:24:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43393 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637AbYJ2QY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:24:57 -0400
Date: Wed, 29 Oct 2008 17:24:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] tracing fixlets
Message-ID: <20081029162450.GA13351@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      ftrace: perform an initialization for ftrace to enable it

Steven Rostedt (1):
      ftrace: fix trace_nop config select


 kernel/trace/Kconfig  |    2 +-
 kernel/trace/ftrace.c |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index e0cea28..b58f43b 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -8,7 +8,6 @@ config NOP_TRACER
 
 config HAVE_FUNCTION_TRACER
 	bool
-	select NOP_TRACER
 
 config HAVE_DYNAMIC_FTRACE
 	bool
@@ -28,6 +27,7 @@ config TRACING
 	select RING_BUFFER
 	select STACKTRACE
 	select TRACEPOINTS
+	select NOP_TRACER
 
 menu "Tracers"
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7618c52..4a39d24 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1339,6 +1339,14 @@ void __init ftrace_init(void)
 }
 
 #else
+
+static int __init ftrace_nodyn_init(void)
+{
+	ftrace_enabled = 1;
+	return 0;
+}
+device_initcall(ftrace_nodyn_init);
+
 # define ftrace_startup()		do { } while (0)
 # define ftrace_shutdown()		do { } while (0)
 # define ftrace_startup_sysctl()	do { } while (0)
