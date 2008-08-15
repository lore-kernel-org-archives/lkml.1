Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbYHOPtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbYHOPtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYHOPtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:49:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41223 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbYHOPtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:49:31 -0400
Date: Fri, 15 Aug 2008 17:49:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: build fix
Message-ID: <20080815154913.GA13985@elte.hu>
References: <20080801162639.175407419@goodmis.org> <20080815150059.GB10029@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080815150059.GB10029@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 00968bd78e3346f35dc809f7a7c811a3d88cf07c Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 15 Aug 2008 17:48:02 +0200
Subject: [PATCH] ftrace: build fix
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix:

 In file included from init/main.c:65:
 include/linux/ftrace.h:166: error: expected ‘,' or ‘;' before ‘{' token
 make[1]: *** [init/main.o] Error 1
 make: *** [init/main.o] Error 2

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f0d8e48..0d19aab 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -162,7 +162,10 @@ extern void ftrace_dump(void);
 static inline void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
 static inline int
-ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 0)))
+ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 0)));
+
+static inline int
+ftrace_printk(const char *fmt, ...)
 {
 	return 0;
 }
