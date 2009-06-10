Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbZFJJ6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbZFJJ6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZFJJ6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:58:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:35085 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZFJJ6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:58:05 -0400
Date: Wed, 10 Jun 2009 09:57:35 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A2F1520.8020003@cn.fujitsu.com>
References: <4A2F1520.8020003@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: convert block trace points to TRACE_EVENT(), fix !CONFIG_BLOCK
Message-ID: <tip-f1db457ce6e2f63cb01022f58c0c023838958bd1@git.kernel.org>
Git-Commit-ID: f1db457ce6e2f63cb01022f58c0c023838958bd1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 10 Jun 2009 09:57:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1db457ce6e2f63cb01022f58c0c023838958bd1
Gitweb:     http://git.kernel.org/tip/f1db457ce6e2f63cb01022f58c0c023838958bd1
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 10 Jun 2009 10:06:24 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Jun 2009 11:55:06 +0200

tracing/events: convert block trace points to TRACE_EVENT(), fix !CONFIG_BLOCK

Fix building failures when CONFIG_BLOCK == n.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A2F1520.8020003@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
