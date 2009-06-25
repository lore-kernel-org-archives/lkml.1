Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZFYIcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZFYIcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZFYIcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:32:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:59524 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbZFYIcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:32:07 -0400
Date: Thu, 25 Jun 2009 08:31:22 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A4313A7.7030105@cn.fujitsu.com>
References: <4A4313A7.7030105@cn.fujitsu.com>
Subject: [tip:tracing/urgent] ftrace: Remove duplicate newline
Message-ID: <tip-00e54d087afb3867b0b461aef6c1ff433d0df564@git.kernel.org>
Git-Commit-ID: 00e54d087afb3867b0b461aef6c1ff433d0df564
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 08:31:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00e54d087afb3867b0b461aef6c1ff433d0df564
Gitweb:     http://git.kernel.org/tip/00e54d087afb3867b0b461aef6c1ff433d0df564
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 25 Jun 2009 14:05:27 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 10:28:36 +0200

ftrace: Remove duplicate newline

Before:
  # echo 'sys_open:traceon:' > set_ftrace_filter
  # echo 'sys_close:traceoff:5' > set_ftrace_filter
  # cat set_ftrace_filter
  #### all functions enabled ####
  sys_open:traceon:unlimited

  sys_close:traceoff:count=0

After:
  # cat set_ftrace_filter
  #### all functions enabled ####
  sys_open:traceon:unlimited
  sys_close:traceoff:count=0

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A4313A7.7030105@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_functions.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 90f1347..7402144 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -302,8 +302,7 @@ ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
 	if (count == -1)
 		seq_printf(m, ":unlimited\n");
 	else
-		seq_printf(m, ":count=%ld", count);
-	seq_putc(m, '\n');
+		seq_printf(m, ":count=%ld\n", count);
 
 	return 0;
 }
