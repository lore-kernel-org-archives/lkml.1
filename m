Return-Path: <linux-kernel-owner+w=401wt.eu-S1761420AbZDQQLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761420AbZDQQLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761217AbZDQQLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:11:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:55361 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760065AbZDQQLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:11:31 -0400
Date: Fri, 17 Apr 2009 16:10:51 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49E7EAB6.4070605@cn.fujitsu.com>
References: <49E7EAB6.4070605@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing: fix file mode of trace and README
Message-ID: <tip-339ae5d3c3fc2025e3657637921495fd600027c7@git.kernel.org>
Git-Commit-ID: 339ae5d3c3fc2025e3657637921495fd600027c7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 16:10:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  339ae5d3c3fc2025e3657637921495fd600027c7
Gitweb:     http://git.kernel.org/tip/339ae5d3c3fc2025e3657637921495fd600027c7
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 17 Apr 2009 10:34:30 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 18:04:36 +0200

tracing: fix file mode of trace and README

trace is read-write and README is read-only.

[ Impact: fix /debug/tracing/ file permissions. ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <49E7EAB6.4070605@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 031c46f..f681f64 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4002,7 +4002,7 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("available_tracers", 0444, d_tracer,
 			&global_trace, &show_traces_fops);
 
-	trace_create_file("current_tracer", 0444, d_tracer,
+	trace_create_file("current_tracer", 0644, d_tracer,
 			&global_trace, &set_tracer_fops);
 
 	trace_create_file("tracing_max_latency", 0644, d_tracer,
@@ -4011,7 +4011,7 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("tracing_thresh", 0644, d_tracer,
 			&tracing_thresh, &tracing_max_lat_fops);
 
-	trace_create_file("README", 0644, d_tracer,
+	trace_create_file("README", 0444, d_tracer,
 			NULL, &tracing_readme_fops);
 
 	trace_create_file("trace_pipe", 0444, d_tracer,
