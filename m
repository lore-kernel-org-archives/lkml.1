Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbYLXDt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbYLXDt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 22:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYLXDtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 22:49:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55309 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYLXDtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 22:49:49 -0500
Message-ID: <4951B09A.4070803@cn.fujitsu.com>
Date: Wed, 24 Dec 2008 11:46:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: enable format arguments checking
References: <494CB7A2.1070603@cn.fujitsu.com> <alpine.DEB.1.10.0812232242010.21172@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0812232242010.21172@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Sat, 20 Dec 2008, Lai Jiangshan wrote:
> 
> Could you resubmit with a "Impact" line.
> 
> Thanks,
> 

Impact: check format for ftrace_printk() when CONFIG_TRACING=n

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

