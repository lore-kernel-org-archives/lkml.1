Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbZCXPtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbZCXPtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761644AbZCXPtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:49:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:38722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407AbZCXPtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:49:16 -0400
Date: Tue, 24 Mar 2009 15:48:27 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49C84D65.9050606@cn.fujitsu.com>
References: <49C84D65.9050606@cn.fujitsu.com>
Subject: [tip:tracing/ftrace] ftrace: show virtual PID
Message-ID: <tip-cc59c9e8d0165c632fd056c4a23e36f917507fb4@git.kernel.org>
Git-Commit-ID: cc59c9e8d0165c632fd056c4a23e36f917507fb4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 15:48:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc59c9e8d0165c632fd056c4a23e36f917507fb4
Gitweb:     http://git.kernel.org/tip/cc59c9e8d0165c632fd056c4a23e36f917507fb4
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 24 Mar 2009 11:03:01 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 16:42:49 +0100

ftrace: show virtual PID

Impact: fix PID output under namespaces

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
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49C84D65.9050606@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 02d2de9..bb37711 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2264,7 +2264,7 @@ ftrace_pid_read(struct file *file, char __user *ubuf,
 	if (ftrace_pid_trace == ftrace_swapper_pid)
 		r = sprintf(buf, "swapper tasks\n");
 	else if (ftrace_pid_trace)
-		r = sprintf(buf, "%u\n", pid_nr(ftrace_pid_trace));
+		r = sprintf(buf, "%u\n", pid_vnr(ftrace_pid_trace));
 	else
 		r = sprintf(buf, "no pid\n");
 
