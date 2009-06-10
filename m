Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbZFJFnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbZFJFnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbZFJFmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:42:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51715 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZFJFmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:42:51 -0400
Message-Id: <20090610054252.794233110@goodmis.org>
References: <20090610054206.510574695@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 01:42:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 01/11] tracing/events: convert block trace points to TRACE_EVENT(), fix
Content-Disposition: inline; filename=0001-tracing-events-convert-block-trace-points-to-TRACE_E.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Fix building failures when CONFIG_BLOCK == n.

[ Impact: build fix ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A2F1520.8020003@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/blktrace_api.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index c7ec31d..7e4350e 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -218,7 +218,7 @@ static inline int blk_trace_init_sysfs(struct device *dev)
 
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
 
-#ifdef CONFIG_EVENT_TRACING
+#if defined(CONFIG_EVENT_TRACING) && defined(CONFIG_BLOCK)
 
 static inline int blk_cmd_buf_len(struct request *rq)
 {
@@ -229,7 +229,7 @@ extern void blk_dump_cmd(char *buf, struct request *rq);
 extern void blk_fill_rwbs(char *rwbs, u32 rw, int bytes);
 extern void blk_fill_rwbs_rq(char *rwbs, struct request *rq);
 
-#endif /* CONFIG_EVENT_TRACING */
+#endif /* CONFIG_EVENT_TRACING && CONFIG_BLOCK */
 
 #endif /* __KERNEL__ */
 #endif
-- 
1.6.3.1

-- 
