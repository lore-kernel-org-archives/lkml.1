Return-Path: <linux-kernel-owner+w=401wt.eu-S932532AbXGNXcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbXGNXcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 19:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765047AbXGNXcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 19:32:04 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:58511 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764955AbXGNXcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 19:32:03 -0400
Date: Sat, 14 Jul 2007 19:32:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] Text Edit Lock - x86_64 Fix !CONFIG_DEBUG_RODATA
Message-ID: <20070714233201.GJ18674@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012412.960272115@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012412.960272115@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:31:12 up 7 days, 13:36,  2 users,  load average: 0.03, 0.15, 0.22
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Text Edit Lock - x86_64 Fix !CONFIG_DEBUG_RODATA

Same fix as for i386: declare remplacement empty functions as static inline.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-x86_64/cacheflush.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/include/asm-x86_64/cacheflush.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86_64/cacheflush.h	2007-07-14 19:26:12.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86_64/cacheflush.h	2007-07-14 19:26:52.000000000 -0400
@@ -31,15 +31,13 @@ void clflush_cache_range(void *addr, int
 
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
 
 #endif /* _X8664_CACHEFLUSH_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
