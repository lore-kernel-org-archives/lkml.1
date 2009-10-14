Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbZJNTOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbZJNTOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZJNTOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:14:05 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:36525 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZJNTOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:14:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DeIkFlweA55veomHVw5T96ct8vEvMxI/FFh/gaxRcJE0gc1mdpBoVTeq+N2i3Oe4Ws
         nx8tMd00940taZhE815AuziHSApqpiwNYeFIH5ehpMUqQMxxujPrOBY16Sr5dBqQdAYn
         P04+QkEpr1aJqy7PRGuzm2kR6m76R7FJ3DgrU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/4] ftrace: Rename set_bootup_ftrace into set_cmdline_ftrace
Date: Wed, 14 Oct 2009 21:13:18 +0200
Message-Id: <1255547598-5294-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255547598-5294-1-git-send-email-fweisbec@gmail.com>
References: <1255547598-5294-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_cmdline_ftrace is a better match against what does this function:
apply a tracer name from the kernel command line.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4311ec3..026e715 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -129,7 +129,7 @@ static int tracing_set_tracer(const char *buf);
 static char bootup_tracer_buf[MAX_TRACER_SIZE] __initdata;
 static char *default_bootup_tracer;
 
-static int __init set_bootup_ftrace(char *str)
+static int __init set_cmdline_ftrace(char *str)
 {
 	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
 	default_bootup_tracer = bootup_tracer_buf;
@@ -137,7 +137,7 @@ static int __init set_bootup_ftrace(char *str)
 	ring_buffer_expanded = 1;
 	return 1;
 }
-__setup("ftrace=", set_bootup_ftrace);
+__setup("ftrace=", set_cmdline_ftrace);
 
 static int __init set_ftrace_dump_on_oops(char *str)
 {
-- 
1.6.2.3

