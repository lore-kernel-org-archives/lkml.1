Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZKBAwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZKBAwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 19:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbZKBAwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 19:52:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63651 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbZKBAwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 19:52:07 -0500
Message-ID: <4AEE2D01.4010305@cn.fujitsu.com>
Date: Mon, 02 Nov 2009 08:51:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] tracing: Fix to use __always_unused attribute
References: <4AEE2CEC.8040206@cn.fujitsu.com>
In-Reply-To: <4AEE2CEC.8040206@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

____ftrace_check_##name() is used for compile-time check on
F_printk() only, so it should be marked as __unused instead
of __used.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_export.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 934d81f..dff8c84 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -48,11 +48,11 @@
 struct ____ftrace_##name {					\
 	tstruct							\
 };								\
-static void __used ____ftrace_check_##name(void)		\
+static void __always_unused ____ftrace_check_##name(void)	\
 {								\
 	struct ____ftrace_##name *__entry = NULL;		\
 								\
-	/* force cmpile-time check on F_printk() */		\
+	/* force compile-time check on F_printk() */		\
 	printk(print);						\
 }
 
-- 
1.6.3

