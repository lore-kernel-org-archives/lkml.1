Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbZIVIkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbZIVIkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZIVIku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:40:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:42245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbZIVIks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:40:48 -0400
Date: Tue, 22 Sep 2009 08:40:18 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, jolsa@redhat.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, jolsa@redhat.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AB86694.4040803@cn.fujitsu.com>
References: <4AB86694.4040803@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Fix failure path in ftrace_regex_open()
Message-ID: <tip-79fe249c8368be35c9ca05982e80c68e959505e1@git.kernel.org>
Git-Commit-ID: 79fe249c8368be35c9ca05982e80c68e959505e1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 08:40:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79fe249c8368be35c9ca05982e80c68e959505e1
Gitweb:     http://git.kernel.org/tip/79fe249c8368be35c9ca05982e80c68e959505e1
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 22 Sep 2009 13:54:28 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 10:28:57 +0200

tracing: Fix failure path in ftrace_regex_open()

Don't forget to free trace_parser if seq_open() returned failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4AB86694.4040803@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ftrace.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5c5cb9b..e70af98 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1621,8 +1621,10 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 		if (!ret) {
 			struct seq_file *m = file->private_data;
 			m->private = iter;
-		} else
+		} else {
+			trace_parser_put(&iter->parser);
 			kfree(iter);
+		}
 	} else
 		file->private_data = iter;
 	mutex_unlock(&ftrace_regex_lock);
