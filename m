Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYHODBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYHODBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 23:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYHODAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 23:00:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40088 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbYHODAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 23:00:49 -0400
Message-Id: <20080815030047.364367343@goodmis.org>
References: <20080815024716.480118113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 14 Aug 2008 22:47:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, srostedt@redhat.com
Subject: [PATCH 2/3] ftrace: move notrace to compiler.h
Content-Disposition: inline; filename=ftrace-move-notrace-to-compiler.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The notrace define belongs in compiler.h so that it can be used in
init.h

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/compiler.h |    2 ++
 include/linux/linkage.h  |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-tip.git/include/linux/compiler.h
===================================================================
--- linux-tip.git.orig/include/linux/compiler.h	2008-08-14 22:42:59.000000000 -0400
+++ linux-tip.git/include/linux/compiler.h	2008-08-14 22:43:16.000000000 -0400
@@ -44,6 +44,8 @@ extern void __chk_io_ptr(const volatile 
 # error Sorry, your compiler is too old/not recognized.
 #endif
 
+#define notrace __attribute__((no_instrument_function))
+
 /* Intel compiler defines __GNUC__. So we will overwrite implementations
  * coming from above header files here
  */
Index: linux-tip.git/include/linux/linkage.h
===================================================================
--- linux-tip.git.orig/include/linux/linkage.h	2008-08-14 22:42:59.000000000 -0400
+++ linux-tip.git/include/linux/linkage.h	2008-08-14 22:43:16.000000000 -0400
@@ -4,8 +4,6 @@
 #include <linux/compiler.h>
 #include <asm/linkage.h>
 
-#define notrace __attribute__((no_instrument_function))
-
 #ifdef __cplusplus
 #define CPP_ASMLINKAGE extern "C"
 #else

-- 
