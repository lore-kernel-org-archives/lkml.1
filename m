Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbZCQWHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbZCQWHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbZCQWGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:06:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50351 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZCQWGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:06:14 -0400
Message-Id: <20090317220419.599556888@chello.nl>
References: <20090317215606.037073805@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 17 Mar 2009 22:56:09 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 03/11] ftrace: fix memory leak
Content-Disposition: inline; filename=ftrace_event-fix.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't return after an allocation without freeing -- fix it by moving the check
up a few lines.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/trace/trace_events.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/trace/trace_events.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_events.c
+++ linux-2.6/kernel/trace/trace_events.c
@@ -380,15 +380,15 @@ event_format_read(struct file *filp, cha
 	char *buf;
 	int r;
 
+	if (*ppos)
+		return 0;
+
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
 
 	trace_seq_init(s);
 
-	if (*ppos)
-		return 0;
-
 	/* If any of the first writes fail, so will the show_format. */
 
 	trace_seq_printf(s, "name: %s\n", call->name);

-- 

