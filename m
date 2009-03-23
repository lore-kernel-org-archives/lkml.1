Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbZCWId0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbZCWId0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757952AbZCWIcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:32:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:51638 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757946AbZCWIb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:31:58 -0400
Date: Mon, 23 Mar 2009 08:31:19 GMT
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237796788.7527.35.camel@charm-linux>
References: <1237796788.7527.35.camel@charm-linux>
Subject: [tip:tracing/filters] tracing/filters: use list_for_each_entry_safe
Message-ID: <tip-75c8b417526529d0a7072e4d93ec99dbd483a6f4@git.kernel.org>
Git-Commit-ID: 75c8b417526529d0a7072e4d93ec99dbd483a6f4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 08:31:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75c8b417526529d0a7072e4d93ec99dbd483a6f4
Gitweb:     http://git.kernel.org/tip/75c8b417526529d0a7072e4d93ec99dbd483a6f4
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Mon, 23 Mar 2009 03:26:28 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 09:28:07 +0100

tracing/filters: use list_for_each_entry_safe

Impact: cleanup

Use list_for_each_entry_safe instead of list_for_each_entry in
find_event_field().

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1237796788.7527.35.camel@charm-linux>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events_filter.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 1ab20ce..c4a413b 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -147,11 +147,9 @@ int filter_print_preds(struct filter_pred **preds, char *buf)
 static struct ftrace_event_field *
 find_event_field(struct ftrace_event_call *call, char *name)
 {
-	struct ftrace_event_field *field;
-	struct list_head *entry, *tmp;
+	struct ftrace_event_field *field, *next;
 
-	list_for_each_safe(entry, tmp, &call->fields) {
-		field = list_entry(entry, struct ftrace_event_field, link);
+	list_for_each_entry_safe(field, next, &call->fields, link) {
 		if (!strcmp(field->name, name))
 			return field;
 	}
