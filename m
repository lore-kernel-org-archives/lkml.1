Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbZIKD3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbZIKD3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 23:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZIKD3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 23:29:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1099 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbZIKD3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 23:29:41 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] include/linux/logging.h: Reduce data usage of printk_once
Date: Thu, 10 Sep 2009 20:29:41 -0700
Message-Id: <0657138fc813c32c20a38949b5646f4c61790cad.1252639196.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1252639195.git.joe@perches.com>
References: <cover.1252639195.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bool for int
Don't initialize __printk_once, invert test

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/logging.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/logging.h b/include/linux/logging.h
index 361d5ed..d76ccfa 100644
--- a/include/linux/logging.h
+++ b/include/linux/logging.h
@@ -91,10 +91,10 @@ extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
  */
 #define printk_once(fmt, ...) \
 ({						\
-	static int __print_once = 1;		\
+	static bool __print_once;		\
 						\
-	if (__print_once) {			\
-		__print_once = 0;		\
+	if (!__print_once) {			\
+		__print_once = true;		\
 		printk(fmt, ##__VA_ARGS__);	\
 	}					\
 })
-- 
1.6.3.1.10.g659a0.dirty

