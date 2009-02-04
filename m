Return-Path: <linux-kernel-owner+w=401wt.eu-S1764464AbZBDTIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764464AbZBDTIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759353AbZBDTIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:08:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37379 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764304AbZBDTIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:08:19 -0500
Date: Wed, 4 Feb 2009 20:08:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] tracing fixes
Message-ID: <20090204190809.GA14287@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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
Oleg Nesterov (1):
      ftrace: do_each_pid_task() needs rcu lock


 kernel/trace/ftrace.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7dcf6e9..9a236ff 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1737,9 +1737,12 @@ static void clear_ftrace_pid(struct pid *pid)
 {
 	struct task_struct *p;
 
+	rcu_read_lock();
 	do_each_pid_task(pid, PIDTYPE_PID, p) {
 		clear_tsk_trace_trace(p);
 	} while_each_pid_task(pid, PIDTYPE_PID, p);
+	rcu_read_unlock();
+
 	put_pid(pid);
 }
 
@@ -1747,9 +1750,11 @@ static void set_ftrace_pid(struct pid *pid)
 {
 	struct task_struct *p;
 
+	rcu_read_lock();
 	do_each_pid_task(pid, PIDTYPE_PID, p) {
 		set_tsk_trace_trace(p);
 	} while_each_pid_task(pid, PIDTYPE_PID, p);
+	rcu_read_unlock();
 }
 
 static void clear_ftrace_pid_task(struct pid **pid)
