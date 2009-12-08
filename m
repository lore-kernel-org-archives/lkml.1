Return-Path: <linux-kernel-owner+w=401wt.eu-S935780AbZLHDQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935780AbZLHDQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 22:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935057AbZLHDQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 22:16:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57163 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935021AbZLHDQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 22:16:03 -0500
Message-ID: <4B1DC4E1.1060303@cn.fujitsu.com>
Date: Tue, 08 Dec 2009 11:15:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/13] function-graph: Allow writing the same val to set_graph_function
References: <4B1DC476.3030700@cn.fujitsu.com>
In-Reply-To: <4B1DC476.3030700@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 # echo 'do_open' > set_graph_function
 # echo 'do_open' >> set_graph_function
 bash: echo: write error: Invalid argument

Make it valid to write the same value to set_graph_function,
which is consistent with set_ftrace_filter interface.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
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
 
-- 
1.6.3

