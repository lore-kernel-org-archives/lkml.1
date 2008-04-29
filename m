Return-Path: <linux-kernel-owner+w=401wt.eu-S1761262AbYD2WPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262AbYD2WPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbYD2WPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:15:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34818 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbYD2WPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:15:45 -0400
Date: Wed, 30 Apr 2008 00:15:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch] inlining: do not allow gcc below version 4 to optimize
	inlining
Message-ID: <20080429221530.GA11398@elte.hu>
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


fix the condition to match intention: always use the old inlining 
behavior on all gcc versions below 4.

this should solve the UML build problem.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/compiler-gcc.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-x86.q/include/linux/compiler-gcc.h
===================================================================
--- linux-x86.q.orig/include/linux/compiler-gcc.h
+++ linux-x86.q/include/linux/compiler-gcc.h
@@ -29,10 +29,11 @@
   BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
 
 /*
- * Force always-inline if the user requests it so via the .config:
+ * Force always-inline if the user requests it so via the .config,
+ * or if gcc is too old:
  */
 #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
-    !defined(CONFIG_OPTIMIZE_INLINING) && (__GNUC__ >= 4)
+    !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
 # define inline		inline		__attribute__((always_inline))
 # define __inline__	__inline__	__attribute__((always_inline))
 # define __inline	__inline	__attribute__((always_inline))
