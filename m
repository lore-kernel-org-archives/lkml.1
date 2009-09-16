Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbZIPS5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbZIPS5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbZIPS5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:57:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbZIPS5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:57:11 -0400
Message-Id: <20090916185714.155641288@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 14:55:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Subject: [PATCH 2/2] [PATCH 2/2] tracing: Fix minor bugs for __unregister_ftrace_function_probe
References: <20090916185546.986682049@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-minor-bugs-for-__unregister_ftrace_funct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>

Fix the condition of strcmp for "*".
Also fix NULL pointer dereference when glob is NULL.

Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
LKML-Reference: <4AAF6726.5090905@bk.jp.nec.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8b23d56..f7ab7fc 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2062,9 +2062,9 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	int i, len = 0;
 	char *search;
 
-	if (glob && (strcmp(glob, "*") || !strlen(glob)))
+	if (glob && (strcmp(glob, "*") == 0 || !strlen(glob)))
 		glob = NULL;
-	else {
+	else if (glob) {
 		int not;
 
 		type = ftrace_setup_glob(glob, strlen(glob), &search, &not);
-- 
1.6.3.3


