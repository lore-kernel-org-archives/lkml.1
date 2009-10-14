Return-Path: <linux-kernel-owner+w=401wt.eu-S934075AbZJNUkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbZJNUkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759748AbZJNUkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:40:04 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:16445 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759741AbZJNUkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:40:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XuAbfZtE8QdMsPdHkjW/xk6r3TRO0hlC0IT0fzWu9vuuS+S2FjEyo0QBLm6BGHUeYi
         Vw/gUvOR5F/T9LEllCdQeD+Wuvmlj68F7fAey8RMAwlImvayhVOC3uRInkb46rYSrG6j
         rB9eWcoL9H7XNyIdTkRBTA3zmnMTlMT7u9Wiw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [GIT PULL] tracing: Fix misuse of strncpy to copy boot params
Date: Wed, 14 Oct 2009 22:38:52 +0200
Message-Id: <1255552732-5096-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull this fixlet for .32 that can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/fixes

Frederic Weisbecker (1):
      tracing: Fix misuse of strncpy to copy boot params

 kernel/trace/ftrace.c |    4 ++--
 kernel/trace/trace.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)
---
>From f44bec1286f516d921210a1bf843725f5d4b86ef Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 14 Oct 2009 21:17:00 +0200
Subject: [PATCH] tracing: Fix misuse of strncpy to copy boot params

While copying ftrace string boot parameters into buffers, we
use strncpy by passing the whole buffer size instead of the max
strlen the buffers can host (which is buffer size - 1), this might
lead to non-null terminated strings.

Fix that by simply using strlcpy instead.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |    4 ++--
 kernel/trace/trace.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 37ba67e..0f4803f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2300,14 +2300,14 @@ static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
 
 static int __init set_ftrace_notrace(char *str)
 {
-	strncpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
+	strlcpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
 __setup("ftrace_notrace=", set_ftrace_notrace);
 
 static int __init set_ftrace_filter(char *str)
 {
-	strncpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
+	strlcpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
 __setup("ftrace_filter=", set_ftrace_filter);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4506826..621d81e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -131,7 +131,7 @@ static char *default_bootup_tracer;
 
 static int __init set_ftrace(char *str)
 {
-	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
+	strlcpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
 	default_bootup_tracer = bootup_tracer_buf;
 	/* We are using ftrace early, expand it */
 	ring_buffer_expanded = 1;
-- 
1.6.2.3


