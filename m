Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbZDQCdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbZDQCdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 22:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbZDQCdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 22:33:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61165 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbZDQCdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 22:33:41 -0400
Message-ID: <49E7EAB6.4070605@cn.fujitsu.com>
Date: Fri, 17 Apr 2009 10:34:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: fix file mode of trace and README
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace is read-write and README is read-only.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.5.4.rc3

