Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbYLTJTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbYLTJTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 04:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYLTJTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 04:19:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57125 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbYLTJTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 04:19:01 -0500
Message-ID: <494CB7A2.1070603@cn.fujitsu.com>
Date: Sat, 20 Dec 2008 17:15:14 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: enable format arguments checking
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


format arguments checking for ftrace_printk() is __printf(1, 2),
not __printf(1, 0).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9c5bc6b..0c71788 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -210,7 +210,7 @@ extern void ftrace_dump(void);
 static inline void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
 static inline int
-ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 0)));
+ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
 
 static inline int
 ftrace_printk(const char *fmt, ...)


