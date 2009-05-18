Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZERO3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZERO3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZERO3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:29:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46108 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbZERO3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:29:37 -0400
Date: Mon, 18 May 2009 16:29:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20090518142903.GA25110@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
GeunSik Lim (1):
      tracing: Append prompt in /debug/tracing/README file

Steven Rostedt (1):
      x86/function-graph: fix constraint for recording old return value


 arch/x86/kernel/ftrace.c |    2 +-
 kernel/trace/trace.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 18dfa30..b79c553 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -442,7 +442,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		_ASM_EXTABLE(1b, 4b)
 		_ASM_EXTABLE(2b, 4b)
 
-		: [old] "=r" (old), [faulted] "=r" (faulted)
+		: [old] "=&r" (old), [faulted] "=r" (faulted)
 		: [parent] "r" (parent), [return_hooker] "r" (return_hooker)
 		: "memory"
 	);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a884c09..cda81ec 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2380,7 +2380,7 @@ static const char readme_msg[] =
 	"# echo print-parent > /debug/tracing/trace_options\n"
 	"# echo 1 > /debug/tracing/tracing_enabled\n"
 	"# cat /debug/tracing/trace > /tmp/trace.txt\n"
-	"echo 0 > /debug/tracing/tracing_enabled\n"
+	"# echo 0 > /debug/tracing/tracing_enabled\n"
 ;
 
 static ssize_t
