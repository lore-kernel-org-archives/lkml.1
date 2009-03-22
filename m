Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZCVTmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZCVTmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbZCVTmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:42:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:40917 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbZCVTmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:42:09 -0400
Date: Sun, 22 Mar 2009 19:40:37 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237710639.7703.46.camel@charm-linux>
References: <1237710639.7703.46.camel@charm-linux>
Subject: [tip:tracing/filters] tracing: add run-time field descriptions for event filtering, kfree fix
Message-ID: <tip-fe9f57f250ab4d781b99504caeb218ca2db14c1a@git.kernel.org>
Git-Commit-ID: fe9f57f250ab4d781b99504caeb218ca2db14c1a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 22 Mar 2009 19:40:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe9f57f250ab4d781b99504caeb218ca2db14c1a
Gitweb:     http://git.kernel.org/tip/fe9f57f250ab4d781b99504caeb218ca2db14c1a
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 22 Mar 2009 18:41:59 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Mar 2009 18:43:25 +0100

tracing: add run-time field descriptions for event filtering, kfree fix

Impact: fix potential kfree of random data in (rare) failure path

Zero-initialize the field structure.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <1237710639.7703.46.camel@charm-linux>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 97d4daa..594d78a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -24,26 +24,31 @@ int trace_define_field(struct ftrace_event_call *call, char *type,
 {
 	struct ftrace_event_field *field;
 
-	field = kmalloc(sizeof(*field), GFP_KERNEL);
+	field = kzalloc(sizeof(*field), GFP_KERNEL);
 	if (!field)
 		goto err;
+
 	field->name = kstrdup(name, GFP_KERNEL);
 	if (!field->name)
 		goto err;
+
 	field->type = kstrdup(type, GFP_KERNEL);
 	if (!field->type)
 		goto err;
+
 	field->offset = offset;
 	field->size = size;
 	list_add(&field->link, &call->fields);
 
 	return 0;
+
 err:
 	if (field) {
 		kfree(field->name);
 		kfree(field->type);
 	}
 	kfree(field);
+
 	return -ENOMEM;
 }
 
