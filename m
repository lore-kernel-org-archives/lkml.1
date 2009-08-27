Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbZH0DfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbZH0DfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZH0Dex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:34:53 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:50461 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZH0Dev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=odZv+6ZhJQWo/s4nvw1zfA+osjUazm5YdD6LghunwTcGKrusvm6lasja1PaUPfomjD
         my4eh4kiUyg79snNnE466jPbJwkmfI3I9E/8R6N06LJZo3tqYksuNxViiiuz0NfYXrSU
         zdOINkys6r97MydkftgZ7ObKW38C/yXD4d5pA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 20/18] tracing: Remove unneeded pointer casts
Date: Thu, 27 Aug 2009 05:34:47 +0200
Message-Id: <1251344087-28719-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaup uneeded casts from void * to char * in syscalls tracing file.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index a928dd0..e7c676e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -324,7 +324,7 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 	int num;
 	char *name;
 
-	name = (char *)call->data;
+	name = call->data;
 	num = syscall_name_to_nr(name);
 	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
 		return -ENOSYS;
@@ -347,7 +347,7 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 	int num;
 	char *name;
 
-	name = (char *)call->data;
+	name = call->data;
 	num = syscall_name_to_nr(name);
 	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
 		return;
-- 
1.6.2.3

