Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbYHKWGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbYHKWGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYHKWGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:06:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:45261 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbYHKWGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=QTLaRCQ+iHwVV4CSjCmaefqAYl9gCjovCw8yKJX9FjN8lniG9C4RJTQc3DhpCeyKS9
         5drfuijBVODL3yeNhwS8ljczw9yn9rbnNMV6pXgeOoYDuJlNIcI7E9SJGetyv6v9lAGZ
         3/1ZVN8eZLYoawvzU+9XQtHo6wSxdz9C6kuZg=
Message-ID: <48A0B7ED.2010705@gmail.com>
Date: Tue, 12 Aug 2008 00:06:37 +0200
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: mingo@redhat.com, srostedt@redhat.com
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace: Fix some mistakes in error messages
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some mistakes on the tracer in warning messages when 
debugfs fails to create tracing files.
Kernel version: 2.6.27-rc1

Regards.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff -rup a/kernel/trace/trace.c b/kernel/trace/trace.c
--- a/kernel/trace/trace.c    2008-08-11 22:44:25.000000000 +0200
+++ b/kernel/trace/trace.c    2008-08-11 23:10:39.000000000 +0200
@@ -2881,12 +2881,12 @@ static __init void tracer_init_debugfs(v
     entry = debugfs_create_file("available_tracers", 0444, d_tracer,
                     &global_trace, &show_traces_fops);
     if (!entry)
-        pr_warning("Could not create debugfs 'trace' entry\n");
+        pr_warning("Could not create debugfs 'available_tracers' entry\n");
 
     entry = debugfs_create_file("current_tracer", 0444, d_tracer,
                     &global_trace, &set_tracer_fops);
     if (!entry)
-        pr_warning("Could not create debugfs 'trace' entry\n");
+        pr_warning("Could not create debugfs 'current_tracer' entry\n");
 
     entry = debugfs_create_file("tracing_max_latency", 0644, d_tracer,
                     &tracing_max_latency,
@@ -2899,7 +2899,7 @@ static __init void tracer_init_debugfs(v
                     &tracing_thresh, &tracing_max_lat_fops);
     if (!entry)
         pr_warning("Could not create debugfs "
-               "'tracing_threash' entry\n");
+               "'tracing_thresh' entry\n");
     entry = debugfs_create_file("README", 0644, d_tracer,
                     NULL, &tracing_readme_fops);
     if (!entry)
@@ -2909,13 +2909,13 @@ static __init void tracer_init_debugfs(v
                     NULL, &tracing_pipe_fops);
     if (!entry)
         pr_warning("Could not create debugfs "
-               "'tracing_threash' entry\n");
+               "'trace_pipe' entry\n");
 
     entry = debugfs_create_file("trace_entries", 0644, d_tracer,
                     &global_trace, &tracing_entries_fops);
     if (!entry)
         pr_warning("Could not create debugfs "
-               "'tracing_threash' entry\n");
+               "'trace_entries' entry\n");
 
 #ifdef CONFIG_DYNAMIC_FTRACE
     entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
