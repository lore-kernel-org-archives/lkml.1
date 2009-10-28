Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbZJ1BqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbZJ1BqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 21:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbZJ1BqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 21:46:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55357 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbZJ1BqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 21:46:04 -0400
Message-ID: <4AE7A217.8030008@cn.fujitsu.com>
Date: Wed, 28 Oct 2009 09:44:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: Fix to use unused attribute
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

____ftrace_check_##name() is used for compile-time check
on F_printk() only, so it should be marked as __unused
instead of __used.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

I'm thinking about introducing __always_unused, comparing
to __maybe_unused.

---
 kernel/trace/trace_export.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 934d81f..85309fc 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -48,11 +48,12 @@
 struct ____ftrace_##name {					\
 	tstruct							\
 };								\
-static void __used ____ftrace_check_##name(void)		\
+static void __attribute__((unused))				\
+____ftrace_check_##name(void)					\
 {								\
 	struct ____ftrace_##name *__entry = NULL;		\
 								\
-	/* force cmpile-time check on F_printk() */		\
+	/* force compile-time check on F_printk() */		\
 	printk(print);						\
 }
 
-- 
1.6.3

