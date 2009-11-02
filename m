Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbZKBQRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbZKBQRC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:17:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbZKBQRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:17:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:53608 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbZKBQRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:17:00 -0500
Date: Mon, 2 Nov 2009 16:15:52 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AEE2CEC.8040206@cn.fujitsu.com>
References: <4AEE2CEC.8040206@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] compiler: Introduce __always_unused
Message-ID: <tip-7b2a35132ad0a70902dcd2844c27ed64cda0ce9b@git.kernel.org>
Git-Commit-ID: 7b2a35132ad0a70902dcd2844c27ed64cda0ce9b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b2a35132ad0a70902dcd2844c27ed64cda0ce9b
Gitweb:     http://git.kernel.org/tip/7b2a35132ad0a70902dcd2844c27ed64cda0ce9b
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 2 Nov 2009 08:50:52 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 15:47:54 +0100

compiler: Introduce __always_unused

I wrote some code which is used as compile-time checker, and the
code should be elided after compile.

So I need to annotate the code as "always unused", compared to
"maybe unused".

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4AEE2CEC.8040206@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/compiler-gcc.h |    1 +
 include/linux/compiler.h     |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index a3ed7cb..73dcf80 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -79,6 +79,7 @@
 #define  noinline			__attribute__((noinline))
 #define __attribute_const__		__attribute__((__const__))
 #define __maybe_unused			__attribute__((unused))
+#define __always_unused			__attribute__((unused))
 
 #define __gcc_header(x) #x
 #define _gcc_header(x) __gcc_header(linux/compiler-gcc##x.h)
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 04fb513..7947f4f 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -213,6 +213,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __maybe_unused		/* unimplemented */
 #endif
 
+#ifndef __always_unused
+# define __always_unused	/* unimplemented */
+#endif
+
 #ifndef noinline
 #define noinline
 #endif
