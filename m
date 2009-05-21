Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbZEUXBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbZEUXBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbZEUXAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:00:30 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2552 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbZEUXA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:00:26 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, x86@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [PATCH 3/3] kernel.h: Remove unused printk_once
Date: Thu, 21 May 2009 16:00:24 -0700
Message-Id: <7122ba0c9a4964039f58763df2378b245851e5ac.1242943463.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1242943463.git.joe@perches.com>
References: <cover.1242943463.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index a5520c9..5e37171 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -243,18 +243,6 @@ extern int printk_ratelimit(void);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 
-/*
- * Print a one-time message (analogous to WARN_ONCE() et al):
- */
-#define printk_once(x...) ({			\
-	static int __print_once = 1;		\
-						\
-	if (__print_once) {			\
-		__print_once = 0;		\
-		printk(x);			\
-	}					\
-})
-
 void log_buf_kexec_setup(void);
 #else
 static inline int vprintk(const char *s, va_list args)
@@ -268,9 +256,6 @@ static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
 					  unsigned int interval_msec)	\
 		{ return false; }
 
-/* No effect, but we still get type checking even in the !PRINTK case: */
-#define printk_once(x...) printk(x)
-
 static inline void log_buf_kexec_setup(void)
 {
 }
-- 
1.6.3.1.10.g659a0.dirty

