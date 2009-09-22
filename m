Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZIVFzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZIVFzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZIVFzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:55:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64665 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbZIVFzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:55:39 -0400
Message-ID: <4AB86694.4040803@cn.fujitsu.com>
Date: Tue, 22 Sep 2009 13:54:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] tracing: fix failure path in ftrace_regex_open()
References: <4AB865FA.5080801@cn.fujitsu.com>
In-Reply-To: <4AB865FA.5080801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't forget to free trace_parser if seq_open() returned failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.6.3
