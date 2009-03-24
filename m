Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbZCXHOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbZCXHOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZCXHOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:14:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:16513 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZCXHOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mnXoRcHUG6Rwq/Gnfl1YmTNNKdP47dogxsv34PXGzkedj8UX9koIy0PDN+z60Kh4WZ
         Xn5yIb16jtwAvG1B8eWClZewvMxHyo1duKPKnq69K4NzqpkOeuJndtV5Wo8T6z+FEASW
         Vqkv8AS9XCLQkI3X429mZnI2EbCQAB9oUHzYc=
Subject: [PATCH] tracing/filters: use list_for_each_entry
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 02:14:01 -0500
Message-Id: <1237878841.8339.57.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to use the safe version here, so use list_for_each_entry instead
of list_for_each_entry_safe in find_event_field().

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

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
-- 
1.5.6.3



