Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbXGNXbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbXGNXbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 19:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764912AbXGNXbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 19:31:10 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:58416 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764706AbXGNXbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 19:31:09 -0400
Date: Sat, 14 Jul 2007 19:31:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Text Edit Lock - i386 Fix endif CONFIG_DEBUG_RODATA
Message-ID: <20070714233108.GI18674@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012412.380213021@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012412.380213021@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:30:01 up 7 days, 13:35,  2 users,  load average: 0.10, 0.19, 0.24
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Text Edit Lock - i386 fix endif CONFIG_DEBUG_RODATA

The #endif would also include kernel_text_unmark().
The replacement empty functions should be static inline.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/mm/init.c           |    2 +-
 include/asm-i386/cacheflush.h |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/arch/i386/mm/init.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/init.c	2007-07-14 19:24:27.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/init.c	2007-07-14 19:24:27.000000000 -0400
@@ -845,7 +845,6 @@ void __kprobes kernel_text_mark_rw(unsig
 	}
 }
 EXPORT_SYMBOL_GPL(kernel_text_mark_rw);
-#endif
 
 void __kprobes kernel_text_unmark(unsigned long address, size_t len)
 {
@@ -862,6 +861,7 @@ void __kprobes kernel_text_unmark(unsign
 	}
 }
 EXPORT_SYMBOL_GPL(kernel_text_unmark);
+#endif
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
Index: linux-2.6-lttng/include/asm-i386/cacheflush.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/cacheflush.h	2007-07-14 19:24:36.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/cacheflush.h	2007-07-14 19:25:04.000000000 -0400
@@ -34,15 +34,13 @@ void kernel_map_pages(struct page *page,
 
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
-#endif
 
-#if defined(CONFIG_DEBUG_RODATA)
 /* mark kernel text pages writable */
 extern void kernel_text_mark_rw(unsigned long address, size_t len);
 extern void kernel_text_unmark(unsigned long address, size_t len);
 #else
-void kernel_text_mark_rw(unsigned long address, size_t len) { }
-void kernel_text_unmark(unsigned long address, size_t len) { }
+static inline void kernel_text_mark_rw(unsigned long address, size_t len) { }
+static inline void kernel_text_unmark(unsigned long address, size_t len) { }
 #endif
 
 #endif /* _I386_CACHEFLUSH_H */
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
