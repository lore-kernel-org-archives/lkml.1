Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbZKBAvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbZKBAvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 19:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZKBAvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 19:51:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54794 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbZKBAvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 19:51:51 -0500
Message-ID: <4AEE2CEC.8040206@cn.fujitsu.com>
Date: Mon, 02 Nov 2009 08:50:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] compiler: Introduce __always_unused
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote some code which is used as compile-time checker, and the
code should be elided after compile.

So I need to annotate the code as "always unused", compared to
"maybe unused".

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
index d1cc9f0..1ccebf4 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -132,6 +132,10 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # define __maybe_unused		/* unimplemented */
 #endif
 
+#ifndef __always_unused
+# define __always_unused	/* unimplemented */
+#endif
+
 #ifndef noinline
 #define noinline
 #endif
-- 
1.6.3

