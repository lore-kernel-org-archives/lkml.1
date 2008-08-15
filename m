Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbYHOTIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbYHOTIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbYHOTI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:08:28 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:38942 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbYHOTI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=QLCxXOOtetP77rWR0SZF5jN+hVhiB6kBDkwXt5tVotNdfi/j2MmA9ckK5Ri1hMzNot
         Xn6+5TNL/97+5eKy63N8p9lnEUStMZHFd9bfPCX/Yjy49LmIrgCO5iYW3BaXVkN4Bnko
         G7Mf0NauJZZWzrZGQxcwKfeBimh3pC9+vkIz4=
Message-ID: <48A5D426.20703@gmail.com>
Date: Fri, 15 Aug 2008 21:08:22 +0200
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, srostedt@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace: Fix some mistakes in error messages
References: <48A0B82B.7090200@gmail.com> <20080815125937.GB30597@elte.hu>
In-Reply-To: <20080815125937.GB30597@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------020705020709030701070602"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020705020709030701070602
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit

Ingo Molnar a écrit :
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> 
>> This patch fixes some mistakes on the tracer in warning messages when 
>> debugfs fails to create tracing files. Kernel version: 2.6.27-rc1
> 
> hm, the patch is nice, but it is whitespace damaged. Please resend along 
> the lines of Documentation/email-clients.txt, or as an attachment.
> 
> 	Ingo


Sorry. Now it should be correct.

Pach V2
-------

This patch fixes some mistakes on the tracer in warning messages when 
debugfs fails to create tracing files.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---


--------------020705020709030701070602
Content-Type: text/x-patch;
 name="resend_debugfs_warns.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="resend_debugfs_warns.diff"

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8f3fb3d..943f278 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2881,12 +2881,12 @@ static __init void tracer_init_debugfs(void)
 	entry = debugfs_create_file("available_tracers", 0444, d_tracer,
 				    &global_trace, &show_traces_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs 'trace' entry\n");
+		pr_warning("Could not create debugfs 'available_tracers' entry\n");
 
 	entry = debugfs_create_file("current_tracer", 0444, d_tracer,
 				    &global_trace, &set_tracer_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs 'trace' entry\n");
+		pr_warning("Could not create debugfs 'current_tracer' entry\n");
 
 	entry = debugfs_create_file("tracing_max_latency", 0644, d_tracer,
 				    &tracing_max_latency,
@@ -2899,7 +2899,7 @@ static __init void tracer_init_debugfs(void)
 				    &tracing_thresh, &tracing_max_lat_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
-			   "'tracing_threash' entry\n");
+			   "'tracing_thresh' entry\n");
 	entry = debugfs_create_file("README", 0644, d_tracer,
 				    NULL, &tracing_readme_fops);
 	if (!entry)
@@ -2909,13 +2909,13 @@ static __init void tracer_init_debugfs(void)
 				    NULL, &tracing_pipe_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
-			   "'tracing_threash' entry\n");
+			   "'trace_pipe' entry\n");
 
 	entry = debugfs_create_file("trace_entries", 0644, d_tracer,
 				    &global_trace, &tracing_entries_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
-			   "'tracing_threash' entry\n");
+			   "'trace_entries' entry\n");
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 	entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,

--------------020705020709030701070602--
