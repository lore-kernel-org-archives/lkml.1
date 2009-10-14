Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbZJNTPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbZJNTPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932100AbZJNTPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:15:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:9787 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbZJNTPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F5Cgc7j75Mtu7SuIqFOJsXYPSRxxXkv1DyRHs9QPnOWdq/8JiBjo49Bu+ZGKvlIdmU
         Tf+0oCHUbr2O0Tlm3j0ObhPThaNTJDIe091sIC5gROJlgZVf8SURyvhEsJCWgtQHd4ld
         MzLc0x52l6RTYKbVrj97p/PCgrIeJagZneLrc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/4] ftrace: Copy ftrace_graph_filter boot param using strlcpy
Date: Wed, 14 Oct 2009 21:13:17 +0200
Message-Id: <1255547598-5294-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255547598-5294-1-git-send-email-fweisbec@gmail.com>
References: <1255547598-5294-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using strncpy in the wrong way to copy the ftrace_graph_filter
boot param because we pass the buffer size instead of the max string
size it can contain (buffer size - 1). The end result might not be
NULL terminated as we are abusing the max string size.

Lets use strlcpy() instead.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index aaea9cd..b10c0d9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2293,7 +2293,7 @@ __setup("ftrace_filter=", set_ftrace_filter);
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 static int __init set_graph_function(char *str)
 {
-	strncpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
+	strlcpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
 __setup("ftrace_graph_filter=", set_graph_function);
-- 
1.6.2.3

