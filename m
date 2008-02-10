Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbYBJHWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbYBJHWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbYBJHUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:20:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56806 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893AbYBJHU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:20:29 -0500
Date: Sun, 10 Feb 2008 08:20:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: [06/19] tracing: add notrace to linkage.h
Message-ID: <20080210072018.GG4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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

From: Ingo Molnar <mingo@elte.hu>

notrace signals that a function should not be traced. Most of the
time this is used by tracers to annotate code that cannot be
traced - it's in a volatile state (such as in user vdso context
or NMI context) or it's in the tracer internals.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/linkage.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/include/linux/linkage.h
===================================================================
--- linux.orig/include/linux/linkage.h
+++ linux/include/linux/linkage.h
@@ -3,6 +3,8 @@
 
 #include <asm/linkage.h>
 
+#define notrace __attribute__((no_instrument_function))
+
 #ifdef __cplusplus
 #define CPP_ASMLINKAGE extern "C"
 #else
