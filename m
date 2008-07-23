Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYGWMea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYGWMea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYGWMdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:33:51 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:56401 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbYGWMdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:33:50 -0400
Message-ID: <488722E7.8040906@miraclelinux.com>
Date: Wed, 23 Jul 2008 21:24:07 +0900
From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: menage@google.com
Subject: [RFC][PATCH][2/3] move lnames from fs/proc/base.c to include/linux/resource.h
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2008.7.23.121701
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
---
 fs/proc/base.c           |   24 ------------------------
 include/linux/resource.h |   24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

--- linux-2.6.26-rc8-mm1.orig/fs/proc/base.c	2008-07-22 15:14:42.000000000 +0900
+++ linux-2.6.26-rc8-mm1/fs/proc/base.c	2008-07-22 15:14:47.000000000 +0900
@@ -431,30 +431,6 @@ static int proc_oom_score(struct task_st
 	return sprintf(buffer, "%lu\n", points);
 }

-struct limit_names {
-	char *name;
-	char *unit;
-};
-
-static const struct limit_names lnames[RLIM_NLIMITS] = {
-	[RLIMIT_CPU] = {"Max cpu time", "ms"},
-	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
-	[RLIMIT_DATA] = {"Max data size", "bytes"},
-	[RLIMIT_STACK] = {"Max stack size", "bytes"},
-	[RLIMIT_CORE] = {"Max core file size", "bytes"},
-	[RLIMIT_RSS] = {"Max resident set", "bytes"},
-	[RLIMIT_NPROC] = {"Max processes", "processes"},
-	[RLIMIT_NOFILE] = {"Max open files", "files"},
-	[RLIMIT_MEMLOCK] = {"Max locked memory", "bytes"},
-	[RLIMIT_AS] = {"Max address space", "bytes"},
-	[RLIMIT_LOCKS] = {"Max file locks", "locks"},
-	[RLIMIT_SIGPENDING] = {"Max pending signals", "signals"},
-	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
-	[RLIMIT_NICE] = {"Max nice priority", NULL},
-	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
-	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
-};
-
 /* Display limits for a process */
 static int proc_pid_limits(struct task_struct *task, char *buffer)
 {
--- linux-2.6.26-rc8-mm1.orig/include/linux/resource.h	2008-07-22 15:14:42.000000000 +0900
+++ linux-2.6.26-rc8-mm1/include/linux/resource.h	2008-07-22 15:14:47.000000000 +0900
@@ -70,6 +70,30 @@ struct rlimit {
  */
 #include <asm/resource.h>

+struct limit_names {
+	char *name;
+	char *unit;
+};
+
+static const struct limit_names lnames[RLIM_NLIMITS] = {
+	[RLIMIT_CPU] = {"Max cpu time", "ms"},
+	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
+	[RLIMIT_DATA] = {"Max data size", "bytes"},
+	[RLIMIT_STACK] = {"Max stack size", "bytes"},
+	[RLIMIT_CORE] = {"Max core file size", "bytes"},
+	[RLIMIT_RSS] = {"Max resident set", "bytes"},
+	[RLIMIT_NPROC] = {"Max processes", "processes"},
+	[RLIMIT_NOFILE] = {"Max open files", "files"},
+	[RLIMIT_MEMLOCK] = {"Max locked memory", "bytes"},
+	[RLIMIT_AS] = {"Max address space", "bytes"},
+	[RLIMIT_LOCKS] = {"Max file locks", "locks"},
+	[RLIMIT_SIGPENDING] = {"Max pending signals", "signals"},
+	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
+	[RLIMIT_NICE] = {"Max nice priority", NULL},
+	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
+	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
+};
+
 int getrusage(struct task_struct *p, int who, struct rusage __user *ru);

 #endif




