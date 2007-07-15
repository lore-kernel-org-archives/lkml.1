Return-Path: <linux-kernel-owner+w=401wt.eu-S932623AbXGOBa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbXGOBa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 21:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbXGOBaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 21:30:18 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:44234 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755658AbXGOBaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 21:30:16 -0400
Date: Sat, 14 Jul 2007 21:30:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, hch@infradead.org
Subject: [PATCH] Text Edit Lock - x86_64 kerneldoc
Message-ID: <20070715013014.GC23209@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012412.960272115@polymtl.ca> <20070714233201.GJ18674@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714233201.GJ18674@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:29:31 up 7 days, 15:34,  2 users,  load average: 0.19, 0.15, 0.12
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Text Edit Lock - x86_64 kerneldoc

Add kerneldoc to text edit lock x86_64 API.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
---
 include/asm-x86_64/cacheflush.h |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-x86_64/cacheflush.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86_64/cacheflush.h	2007-07-14 20:25:49.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86_64/cacheflush.h	2007-07-14 20:25:50.000000000 -0400
@@ -32,8 +32,25 @@ void clflush_cache_range(void *addr, int
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
 
-/* mark kernel text pages writable */
+/**
+ * kernel_text_mark_rw  -   Mark kernel text RW
+ * @address:                location of the code
+ * @len:                    size of code to mark
+ *
+ * Mark the kernel text pages writable so they can safely written to. This is
+ * useful for code patching.
+*/
+
 extern void kernel_text_mark_rw(unsigned long address, size_t len);
+
+/**
+ * kernel_text_unmark  -    Mark kernel text back to its original flags
+ * @address:                location of the code
+ * @len:                    size of code to mark
+ *
+ * Mark the kernel text back to its original flags.
+ */
+
 extern void kernel_text_unmark(unsigned long address, size_t len);
 #else
 static inline void kernel_text_mark_rw(unsigned long address, size_t len) { }
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
