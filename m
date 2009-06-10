Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZFJCFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZFJCFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 22:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbZFJCE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 22:04:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62677 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbZFJCE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 22:04:59 -0400
Message-ID: <4A2F1520.8020003@cn.fujitsu.com>
Date: Wed, 10 Jun 2009 10:06:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tracing/events: convert block trace points to TRACE_EVENT(),
 fix
References: <20090609163657.557589106@goodmis.org> <20090609234655.GA24118@elte.hu> <4A2F0C4A.8020109@cn.fujitsu.com> <alpine.DEB.2.00.0906092131190.30552@gandalf.stny.rr.com> <4A2F0E26.9010203@cn.fujitsu.com> <alpine.DEB.2.00.0906092140350.30552@gandalf.stny.rr.com> <4A2F1126.5010306@cn.fujitsu.com>
In-Reply-To: <4A2F1126.5010306@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building failures when CONFIG_BLOCK == n.

[ Impact: build fix ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.5.4.rc3
