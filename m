Return-Path: <linux-kernel-owner+w=401wt.eu-S1760838AbYHOQ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838AbYHOQ1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYHOQ1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:27:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45270 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbYHOQ1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:27:06 -0400
Date: Fri, 15 Aug 2008 18:26:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ftrace: ftrace_kill_atomic() build fix
Message-ID: <20080815162649.GA16356@elte.hu>
References: <alpine.DEB.1.10.0807302227320.20785@gandalf.stny.rr.com> <20080815154014.GD27955@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815154014.GD27955@elte.hu>
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


>From 62aa63382a5b20a6441f665c423a39f2f01e9b5e Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 15 Aug 2008 18:22:09 +0200
Subject: [PATCH] ftrace: ftrace_kill_atomic() build fix

fix:

 kernel/built-in.o: In function `ftrace_dump':
 (.text+0x2e2ea): undefined reference to `ftrace_kill_atomic'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 0d19aab..f46804f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -36,6 +36,7 @@ extern void ftrace_stub(unsigned long a0, unsigned long a1);
 # define register_ftrace_function(ops) do { } while (0)
 # define unregister_ftrace_function(ops) do { } while (0)
 # define clear_ftrace_function(ops) do { } while (0)
+static inline void ftrace_kill_atomic(void) { }
 #endif /* CONFIG_FTRACE */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
