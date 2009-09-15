Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZIOKJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZIOKJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZIOKJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:09:43 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:62215 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZIOKJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:09:42 -0400
Message-ID: <4AAF6726.5090905@bk.jp.nec.com>
Date: Tue, 15 Sep 2009 19:06:30 +0900
From: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       "Frank Ch. Eigler" <fche@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, paulus@samba.org,
       systemtap@sources.redhat.com
Subject: [PATCH 1/2] tracing: Fix minor bugs for __unregister_ftrace_function_probe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the condition of strcmp for "*".
Also fix NULL pointer dereference when glob is NULL.

Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
---
 kernel/trace/ftrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8c804e2..5ef8f59 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2059,9 +2059,9 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
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
1.5.5.1




