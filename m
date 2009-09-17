Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbZIQHsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbZIQHsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbZIQHsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:48:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:48547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZIQHsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:48:53 -0400
Date: Thu, 17 Sep 2009 07:48:36 GMT
From: tip-bot for Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, a-tsuji@bk.jp.nec.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, a-tsuji@bk.jp.nec.com, tglx@linutronix.de
In-Reply-To: <4AAF6726.5090905@bk.jp.nec.com>
References: <4AAF6726.5090905@bk.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Fix minor bugs for __unregister_ftrace_function_probe
Message-ID: <tip-b36461da2a0389149d7f88f3cbc05a30d1db9faa@git.kernel.org>
Git-Commit-ID: b36461da2a0389149d7f88f3cbc05a30d1db9faa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 07:48:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b36461da2a0389149d7f88f3cbc05a30d1db9faa
Gitweb:     http://git.kernel.org/tip/b36461da2a0389149d7f88f3cbc05a30d1db9faa
Author:     Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
AuthorDate: Tue, 15 Sep 2009 19:06:30 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 16 Sep 2009 09:08:54 -0400

tracing: Fix minor bugs for __unregister_ftrace_function_probe

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
