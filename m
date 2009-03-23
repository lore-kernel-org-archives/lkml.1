Return-Path: <linux-kernel-owner+w=401wt.eu-S1759820AbZCWQnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820AbZCWQnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbZCWQnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:43:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:40045 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757435AbZCWQnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:43:05 -0400
Date: Mon, 23 Mar 2009 16:42:27 GMT
From: Daniel Mack <daniel@caiaq.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, daniel@caiaq.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       daniel@caiaq.de, mingo@elte.hu
In-Reply-To: <1237824637-28190-1-git-send-email-daniel@caiaq.de>
References: <1237824637-28190-1-git-send-email-daniel@caiaq.de>
Subject: [tip:tracing/ftrace] kernel/trace/trace_functions_graph.c: fix nsecs_str buffer size
Message-ID: <tip-603b9b9081ae0a1af986b9059a0a5055876ddea9@git.kernel.org>
Git-Commit-ID: 603b9b9081ae0a1af986b9059a0a5055876ddea9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 16:42:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  603b9b9081ae0a1af986b9059a0a5055876ddea9
Gitweb:     http://git.kernel.org/tip/603b9b9081ae0a1af986b9059a0a5055876ddea9
Author:     Daniel Mack <daniel@caiaq.de>
AuthorDate: Mon, 23 Mar 2009 17:10:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 17:40:51 +0100

kernel/trace/trace_functions_graph.c: fix nsecs_str buffer size

Impact: fix currently inactive buffer-overflow

In kernel/trace/trace_functions_graph.c, print_graph_duration(),
len can be as low as 1 or 2, which could make snprintf() write
beyond the buffer bounds. (Found by cppcheck, no real-world bug
occured)

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237824637-28190-1-git-send-email-daniel@caiaq.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_functions_graph.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index e876816..a305472 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -430,7 +430,7 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s)
 	unsigned long nsecs_rem = do_div(duration, 1000);
 	/* log10(ULONG_MAX) + '\0' */
 	char msecs_str[21];
-	char nsecs_str[5];
+	char nsecs_str[8];
 	int ret, len;
 	int i;
 
