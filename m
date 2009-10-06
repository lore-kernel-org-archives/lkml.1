Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZJFGBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZJFGBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbZJFGBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:01:36 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:49159 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432AbZJFGBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JQrR5X8tMv68hopcQS3KgBtMgj1DfgC2+DROgtoDUixD3AArbMcr5PoNwWx2otj14L
         K+ptUeAlrF2eVccUvn8mATkMWDwDjpAxnh/Zk20rnI/lcXXNEOZqBBuRtjameRI9tTVr
         tm+aTPA00yuCgOUKWgdrPPwL2obzLzd5qxzE8=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com
Subject: [PATCH 3/3] tracing/syscalls: Use long for syscall ret format and field definitions
Date: Tue,  6 Oct 2009 01:00:49 -0500
Message-Id: <1254808849-7829-4-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1254808849-7829-1-git-send-email-tzanussi@gmail.com>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syscall event definitions use long for the syscall exit ret value,
but unsigned long for the same thing in the format and field
definitions.  Change them all to long.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 kernel/trace/trace_syscalls.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 9fbce6c..527e17e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -166,7 +166,7 @@ int syscall_exit_format(struct ftrace_event_call *call, struct trace_seq *s)
 			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n"
 			       "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n",
 			       SYSCALL_FIELD(int, nr),
-			       SYSCALL_FIELD(unsigned long, ret));
+			       SYSCALL_FIELD(long, ret));
 	if (!ret)
 		return 0;
 
@@ -212,7 +212,7 @@ int syscall_exit_define_fields(struct ftrace_event_call *call)
 	if (ret)
 		return ret;
 
-	ret = trace_define_field(call, SYSCALL_FIELD(unsigned long, ret), 0,
+	ret = trace_define_field(call, SYSCALL_FIELD(long, ret), 0,
 				 FILTER_OTHER);
 
 	return ret;
-- 
1.6.4.GIT

