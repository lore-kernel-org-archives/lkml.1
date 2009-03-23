Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZCWI0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZCWI0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZCWI0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:26:34 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:25360 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbZCWI0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:26:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=AX3KDXKx9gqoWLy7/F+/e1sVW8i8XpvsCy4nQ0/iWAxWMSjrLSJ3KBsygnDuvAswBa
         zXHWWDkkK7HyFr9ASQljAhwPO/EADkU+sN6DgsFpGwbS9KyWC71OQ50OVhQIuODZSO5h
         6XDSIOB0TuDjCiQJAMFa4mLHyy57/wJEOAtUw=
Subject: [PATCH] tracing/filters: use list_for_each_entry_safe
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 03:26:28 -0500
Message-Id: <1237796788.7527.35.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_for_each_entry_safe instead of list_for_each_entry in
find_event_field().

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Reported-by: Frederic Weisbecker <fweisbec@gmail.com>

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
-- 
1.5.6.3



