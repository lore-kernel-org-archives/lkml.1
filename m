Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZCWIbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZCWIbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbZCWIb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:31:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:51593 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705AbZCWIb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:31:27 -0400
Date: Mon, 23 Mar 2009 08:30:43 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
References: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/filters] tracing/events: make the filter files writable
Message-ID: <tip-9bd7d099ab3f10dd666da399c064999bae427cd9@git.kernel.org>
Git-Commit-ID: 9bd7d099ab3f10dd666da399c064999bae427cd9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 08:30:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9bd7d099ab3f10dd666da399c064999bae427cd9
Gitweb:     http://git.kernel.org/tip/9bd7d099ab3f10dd666da399c064999bae427cd9
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 22 Mar 2009 23:10:43 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 09:22:14 +0100

tracing/events: make the filter files writable

We need the filter files to be writable, the current
filter file permissions are only set readable.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 594d78a..19f61dd 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -706,7 +706,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 
 	system->preds = NULL;
 
-	entry = debugfs_create_file("filter", 0444, system->entry, system,
+	entry = debugfs_create_file("filter", 0644, system->entry, system,
 				    &ftrace_subsystem_filter_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
@@ -769,7 +769,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 		}
 	}
 
-	entry = debugfs_create_file("filter", 0444, call->dir, call,
+	entry = debugfs_create_file("filter", 0644, call->dir, call,
 				    &ftrace_event_filter_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
