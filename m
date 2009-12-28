Return-Path: <linux-kernel-owner+w=401wt.eu-S1751989AbZL1Ivb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbZL1Ivb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZL1Iva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:51:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbZL1Iv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:51:29 -0500
Message-ID: <4B387122.7090801@cn.fujitsu.com>
Date: Mon, 28 Dec 2009 16:49:38 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 3/3] perf trace: fix forgetting close file/dir
References: <4B383DE3.3070702@cn.fujitsu.com> <20091228074426.GA20039@elte.hu> <4B386615.7000207@cn.fujitsu.com> <20091228080615.GC28652@elte.hu> <4B387090.7080407@cn.fujitsu.com> <4B3870DE.7090500@cn.fujitsu.com>
In-Reply-To: <4B3870DE.7090500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix forgetting close file/dir

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/util/trace-event-info.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 5dd5c81..2c84fb6 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -252,6 +252,8 @@ static void read_header_files(void)
 	write_or_die("header_page", 12);
 	write_or_die(&size, 8);
 	check_size = copy_file_fd(fd);
+	close(fd);
+
 	if (size != check_size)
 		die("wrong size for '%s' size=%lld read=%lld",
 		    path, size, check_size);
@@ -270,6 +272,7 @@ static void read_header_files(void)
 	if (size != check_size)
 		die("wrong size for '%s'", path);
 	put_tracing_file(path);
+	close(fd);
 }
 
 static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
@@ -334,6 +337,7 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 
 		free(format);
 	}
+	closedir(dir);
 }
 
 static void read_ftrace_files(struct tracepoint_path *tps)
@@ -411,6 +415,7 @@ static void read_event_files(struct tracepoint_path *tps)
 		free(sys);
 	}
 
+	closedir(dir);
 	put_tracing_file(path);
 }
 
-- 
1.6.1.2


