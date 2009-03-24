Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZCXH2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZCXH2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZCXH2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:28:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:37689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbZCXH2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:28:19 -0400
Date: Tue, 24 Mar 2009 07:27:38 GMT
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237878841.8339.57.camel@charm-linux>
References: <1237878841.8339.57.camel@charm-linux>
Subject: [tip:tracing/filters] tracing/filters: use list_for_each_entry
Message-ID: <tip-1fc2d5c11918082536acf261ce6abb1f5511053f@git.kernel.org>
Git-Commit-ID: 1fc2d5c11918082536acf261ce6abb1f5511053f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 07:27:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1fc2d5c11918082536acf261ce6abb1f5511053f
Gitweb:     http://git.kernel.org/tip/1fc2d5c11918082536acf261ce6abb1f5511053f
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 24 Mar 2009 02:14:01 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 08:26:51 +0100

tracing/filters: use list_for_each_entry

Impact: cleanup

No need to use the safe version here, so use list_for_each_entry instead
of list_for_each_entry_safe in find_event_field().

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237878841.8339.57.camel@charm-linux>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events_filter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 4117c2e..3f0b79f 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -147,9 +147,9 @@ int filter_print_preds(struct filter_pred **preds, char *buf)
 static struct ftrace_event_field *
 find_event_field(struct ftrace_event_call *call, char *name)
 {
-	struct ftrace_event_field *field, *next;
+	struct ftrace_event_field *field;
 
-	list_for_each_entry_safe(field, next, &call->fields, link) {
+	list_for_each_entry(field, &call->fields, link) {
 		if (!strcmp(field->name, name))
 			return field;
 	}
