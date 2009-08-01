Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbZHAHYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbZHAHYV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 03:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZHAHYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 03:24:20 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46120 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZHAHXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 03:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=I9LPFnY1NIfvMBBnfCEnUv+8Fep6BNyJtzhTaXYqP/xzoBRLYC20ZzrNH2iOwiyqdC
         Hg1N92F8OAmV6+lNOlCUjXDGI3TEqKWTVFMBQGg6X5GLmi7SEmVvh8/L0BM1EU/l+Qfe
         GXXbVN+v9LwXmQ4j6dke8SQL1zsv5rp5t8gCw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 2/5] tracing/event: Cleanup the useless dentry variable
Date: Sat,  1 Aug 2009 09:23:25 +0200
Message-Id: <1249111408-8657-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1249111408-8657-1-git-send-email-fweisbec@gmail.com>
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the useless dentry variable while creating a kernel
event set of files. trace_create_file() warns if it fails to
create the file anyway, and we don't store the dentry anywhere.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 90cf936..d8d8434 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -901,9 +901,9 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 			   "'%s/filter' entry\n", name);
 	}
 
-	entry = trace_create_file("enable", 0644, system->entry,
-				  (void *)system->name,
-				  &ftrace_system_enable_fops);
+	trace_create_file("enable", 0644, system->entry,
+			  (void *)system->name,
+			  &ftrace_system_enable_fops);
 
 	return system->entry;
 }
@@ -941,7 +941,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		 const struct file_operations *filter,
 		 const struct file_operations *format)
 {
-	struct dentry *entry;
 	int ret;
 
 	/*
@@ -968,12 +967,12 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 	}
 
 	if (call->regfunc)
-		entry = trace_create_file("enable", 0644, call->dir, call,
-					  enable);
+		trace_create_file("enable", 0644, call->dir, call,
+				  enable);
 
 	if (call->id)
-		entry = trace_create_file("id", 0444, call->dir, call,
-					  id);
+		trace_create_file("id", 0444, call->dir, call,
+		 		  id);
 
 	if (call->define_fields) {
 		ret = call->define_fields();
@@ -982,16 +981,16 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 				   " events/%s\n", call->name);
 			return ret;
 		}
-		entry = trace_create_file("filter", 0644, call->dir, call,
-					  filter);
+		trace_create_file("filter", 0644, call->dir, call,
+				  filter);
 	}
 
 	/* A trace may not want to export its format */
 	if (!call->show_format)
 		return 0;
 
-	entry = trace_create_file("format", 0444, call->dir, call,
-				  format);
+	trace_create_file("format", 0444, call->dir, call,
+			  format);
 
 	return 0;
 }
-- 
1.6.2.3

