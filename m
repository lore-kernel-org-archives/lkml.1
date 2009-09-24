Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZIXTts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZIXTts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZIXTtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:49:46 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:54837 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbZIXTtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:49:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UG/Zwe+EHF4aMxCAeMRFqyjJB9myvj/FsMZ3lSkVtoRJ70TFhIAHGoDfwL06yr7RMm
         sPQmmE38UjRYdFA3ZpKt1rUH9NSBAAJHufdDJlRPrzkX7ZTODmIZgp0xNRyUn4lNE2Fj
         AgXSGuoBD9GG5mDHT8hSOnQGidjysCFbPj4Hw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/5 v2] tracing/event: Cleanup the useless dentry variable
Date: Thu, 24 Sep 2009 21:49:33 +0200
Message-Id: <1253821775-8618-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the useless dentry variable while creating a kernel
event set of files. trace_create_file() warns if it fails to
create the file anyway, and we don't store the dentry anywhere.

v2: Fix a small conflict in kernel/trace/trace_events.c

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 56c260b..8c91b7c 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -898,9 +898,9 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
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
@@ -912,7 +912,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		 const struct file_operations *filter,
 		 const struct file_operations *format)
 {
-	struct dentry *entry;
 	int ret;
 
 	/*
@@ -930,12 +929,12 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 	}
 
 	if (call->regfunc)
-		entry = trace_create_file("enable", 0644, call->dir, call,
-					  enable);
+		trace_create_file("enable", 0644, call->dir, call,
+				  enable);
 
 	if (call->id && call->profile_enable)
-		entry = trace_create_file("id", 0444, call->dir, call,
-					  id);
+		trace_create_file("id", 0444, call->dir, call,
+		 		  id);
 
 	if (call->define_fields) {
 		ret = call->define_fields(call);
@@ -944,16 +943,16 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
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

