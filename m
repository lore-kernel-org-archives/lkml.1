Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbZCXDFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbZCXDFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 23:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZCXDFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 23:05:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56179 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZCXDFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 23:05:07 -0400
Message-ID: <49C84D65.9050606@cn.fujitsu.com>
Date: Tue, 24 Mar 2009 11:03:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] ftrace: show virtual PID
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When current namespace is not the global namespace,
pid read from set_ftrace_pid is no correct.

# ~/newpid_namespace_run bash
# echo $$
1
# echo 1 > set_ftrace_pid
# cat set_ftrace_pid
3756

Since we write virtual PID to set_ftrace_pid, we need get
virtual PID when we read it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7847806..7d7f201 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2262,7 +2262,7 @@ ftrace_pid_read(struct file *file, char __user *ubuf,
 	if (ftrace_pid_trace == ftrace_swapper_pid)
 		r = sprintf(buf, "swapper tasks\n");
 	else if (ftrace_pid_trace)
-		r = sprintf(buf, "%u\n", pid_nr(ftrace_pid_trace));
+		r = sprintf(buf, "%u\n", pid_vnr(ftrace_pid_trace));
 	else
 		r = sprintf(buf, "no pid\n");
 

