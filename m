Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbZFYGEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbZFYGEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 02:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbZFYGEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 02:04:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55249 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbZFYGEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 02:04:36 -0400
Message-ID: <4A4313A7.7030105@cn.fujitsu.com>
Date: Thu, 25 Jun 2009 14:05:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: remove duplicate newline
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
  # echo 'sys_open:traceon:' > set_ftrace_filter
  # echo 'sys_close:traceoff:5' > set_ftrace_filter
  # cat set_ftrace_filter
  #### all functions enabled ####
  sys_open:traceon:unlimited

  sys_close:traceoff:count=0

After:
  # cat set_ftrace_filter
  #### all functions enabled ####
  sys_open:traceon:unlimited
  sys_close:traceoff:count=0

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_functions.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 90f1347..7402144 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -302,8 +302,7 @@ ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
 	if (count == -1)
 		seq_printf(m, ":unlimited\n");
 	else
-		seq_printf(m, ":count=%ld", count);
-	seq_putc(m, '\n');
+		seq_printf(m, ":count=%ld\n", count);
 
 	return 0;
 }
-- 
1.5.4.rc3


