Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbZLNJr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbZLNJr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZLNJrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:47:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:48223 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbZLNJrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:47:17 -0500
Date: Mon, 14 Dec 2009 09:46:48 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4B1DC4E1.1060303@cn.fujitsu.com>
References: <4B1DC4E1.1060303@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] function-graph: Allow writing the same val to set_graph_function
Message-ID: <tip-91baf6285be7282cfa487de92f836c50749dffb9@git.kernel.org>
Git-Commit-ID: 91baf6285be7282cfa487de92f836c50749dffb9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91baf6285be7282cfa487de92f836c50749dffb9
Gitweb:     http://git.kernel.org/tip/91baf6285be7282cfa487de92f836c50749dffb9
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 8 Dec 2009 11:15:45 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 13 Dec 2009 18:37:26 +0100

function-graph: Allow writing the same val to set_graph_function

# echo 'do_open' > set_graph_function
 # echo 'do_open' >> set_graph_function
 bash: echo: write error: Invalid argument

Make it valid to write the same value to set_graph_function,
which is consistent with set_ftrace_filter interface.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-reference: <4B1DC4E1.1060303@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/ftrace.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ff8aecd..7968762 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2552,10 +2552,9 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 					exists = true;
 					break;
 				}
-			if (!exists) {
+			if (!exists)
 				array[(*idx)++] = rec->ip;
-				found = 1;
-			}
+			found = 1;
 		}
 	} while_for_each_ftrace_rec();
 
