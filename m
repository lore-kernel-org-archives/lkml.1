Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbXGOBeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbXGOBeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 21:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbXGOBeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 21:34:11 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:39883 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759065AbXGOBeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 21:34:10 -0400
Date: Sat, 14 Jul 2007 21:29:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH] Text Edit Lock - i386 kerneldoc
Message-ID: <20070715012905.GB23209@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012412.380213021@polymtl.ca> <20070714233108.GI18674@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714233108.GI18674@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:28:27 up 7 days, 15:33,  2 users,  load average: 0.03, 0.12, 0.12
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Text Edit Lock - i386 kerneldoc

Add kerneldoc to text edit lock i386 API.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
---
 include/asm-i386/cacheflush.h |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-i386/cacheflush.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/cacheflush.h	2007-07-14 20:23:01.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/cacheflush.h	2007-07-14 20:24:17.000000000 -0400
@@ -35,8 +35,25 @@ void kernel_map_pages(struct page *page,
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
