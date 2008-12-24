Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbYLXAnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbYLXAnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 19:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYLXAnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 19:43:31 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:54027 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYLXAna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 19:43:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=sQuxSQbQVkMRpwfldpop4JtUnbUMNFBJhglxqvtAoHiB3yxS9h3edMoyuXZaeHJcf/
         3dBhYDjagSbHt+TfQSepEATElitqjPuStYNPCp3QEdvNDt9kzzyJ32lR9sgJT+ftKXsl
         lXo/qmONz+ldpjutRBTn+VYF7EmzlqA6pWnLc=
Message-ID: <495185AD.2060604@gmail.com>
Date: Wed, 24 Dec 2008 01:43:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2 v2] tracing/function-graph-tracer: strip ending newlines
 on comments
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: trivial output improvement

Ending newlines are appended automatically on comments by the function graph tracer
because the newline needs to be placed after the "*/" characters.
So if the user puts an ending whitespace, we want to strip it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_functions_graph.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 4bf39fc..bc7d908 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -592,6 +592,12 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
 	if (ent->flags & TRACE_FLAG_CONT)
 		trace_seq_print_cont(s, iter);
 
+	/* Strip ending newline */
+	if (s->buffer[s->len - 1] == '\n') {
+		s->buffer[s->len - 1] = '\0';
+		s->len--;
+	}
+
 	ret = trace_seq_printf(s, " */\n");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
-- 
1.6.0.4

