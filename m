Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbZCVWLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbZCVWLJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 18:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbZCVWKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 18:10:53 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:51615 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZCVWKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 18:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FKU6oLuG4+lhF9RBEBqteDYmmHgOwE60HEYOj2oIq1pYdPEGij1dZE/591+z28wn3X
         xc5rY3x3dXoIV6FEYHwX5w3pk6xv7K2bgOn8SsPEk99GZSqcAocpsgnkg1UK5iYkDMZ0
         LpRUOrctZk+e8rSUwyp5FU5XfvoE+IeZVdEtA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/5] tracing/events: make the filter files writable
Date: Sun, 22 Mar 2009 23:10:43 +0100
Message-Id: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need the filter files to be writable, the current
filter file permissions make are only set readable.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
-- 
1.6.1

