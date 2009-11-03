Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZKCA55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZKCA55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 19:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbZKCA5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 19:57:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57665 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757547AbZKCA5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 19:57:54 -0500
Message-ID: <4AEF7FDC.2040200@cn.fujitsu.com>
Date: Tue, 03 Nov 2009 08:57:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] function-graph: Allow writing the same val to set_graph_function
References: <4AEF7F8A.3080300@cn.fujitsu.com>
In-Reply-To: <4AEF7F8A.3080300@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 # echo 'do_open' > set_graph_function
 # echo 'do_open' >> set_graph_function
 bash: echo: write error: Invalid argument

Make it valid to write the same value to set_graph_function.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e0184b7..eaf6a4d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2549,10 +2549,9 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
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
 
-- 
1.6.3
