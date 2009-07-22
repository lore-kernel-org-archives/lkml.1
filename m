Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZGVIkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZGVIkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 04:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZGVIkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 04:40:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62044 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbZGVIkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 04:40:05 -0400
Message-ID: <4A66D004.7020205@cn.fujitsu.com>
Date: Wed, 22 Jul 2009 16:38:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip 1/2] function-graph: fix the output of set_graph_function
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It always shows "ftrace_graph_funcs":

 # echo 'sys_open' > set_graph_function
 # cat set_graph_function
 ftrace_graph_funcs

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 24e3ff5..c6c0c07 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2505,7 +2505,7 @@ static int g_show(struct seq_file *m, void *v)
 		return 0;
 	}
 
-	seq_printf(m, "%pf\n", v);
+	seq_printf(m, "%pf\n", (void *)*ptr);
 
 	return 0;
 }
-- 
1.6.3

