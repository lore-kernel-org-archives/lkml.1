Return-Path: <linux-kernel-owner+w=401wt.eu-S1752249AbZL1KMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbZL1KMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbZL1KMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:12:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:48150 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbZL1KM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:12:29 -0500
Date: Mon, 28 Dec 2009 10:09:52 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, jkacur@redhat.com, williams@redhat.com,
       peterz@infradead.org, xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, williams@redhat.com,
       peterz@infradead.org, xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B387122.7090801@cn.fujitsu.com>
References: <4B387122.7090801@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Fix forgotten close of file/dir
Message-ID: <tip-9967411e5b324a908e344d6ce66b77bd5d372c3e@git.kernel.org>
Git-Commit-ID: 9967411e5b324a908e344d6ce66b77bd5d372c3e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9967411e5b324a908e344d6ce66b77bd5d372c3e
Gitweb:     http://git.kernel.org/tip/9967411e5b324a908e344d6ce66b77bd5d372c3e
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Mon, 28 Dec 2009 16:49:38 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 10:36:36 +0100

perf trace: Fix forgotten close of file/dir

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <4B387122.7090801@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/trace-event-info.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 535176d..407fd65 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -253,6 +253,8 @@ static void read_header_files(void)
 	write_or_die("header_page", 12);
 	write_or_die(&size, 8);
 	check_size = copy_file_fd(fd);
+	close(fd);
+
 	if (size != check_size)
 		die("wrong size for '%s' size=%lld read=%lld",
 		    path, size, check_size);
@@ -271,6 +273,7 @@ static void read_header_files(void)
 	if (size != check_size)
 		die("wrong size for '%s'", path);
 	put_tracing_file(path);
+	close(fd);
 }
 
 static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
@@ -337,6 +340,7 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 
 		free(format);
 	}
+	closedir(dir);
 }
 
 static void read_ftrace_files(struct tracepoint_path *tps)
@@ -407,6 +411,7 @@ static void read_event_files(struct tracepoint_path *tps)
 		free(sys);
 	}
 
+	closedir(dir);
 	put_tracing_file(path);
 }
 
