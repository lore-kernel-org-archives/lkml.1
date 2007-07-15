Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbXGOXhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbXGOXhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbXGOXg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:36:56 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:55162 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbXGOXgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:36:53 -0400
Date: Sun, 15 Jul 2007 19:36:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH] Text Edit Lock - i386 kerneldoc implementation
Message-ID: <20070715233651.GF22428@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012412.380213021@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012412.380213021@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:35:57 up 8 days, 13:41,  3 users,  load average: 0.74, 0.77, 0.46
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Text Edit Lock - i386 kerneldoc implementation

Add kerneldoc to text edit lock i386 API.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
---
 arch/i386/mm/init.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/arch/i386/mm/init.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/mm/init.c	2007-07-15 18:59:31.000000000 -0400
+++ linux-2.6-lttng/arch/i386/mm/init.c	2007-07-15 19:00:05.000000000 -0400
@@ -826,9 +826,13 @@ void mark_rodata_ro(void)
 	global_flush_tlb();
 }
 
-/*
- * Lock the kernel text for mutual write exclusion.
- * Make sure the pages are writable.
+/**
+ * kernel_text_mark_rw  -   Mark kernel text RW
+ * @address:                location of the code
+ * @len:                    size of code to mark
+ *
+ * Mark the kernel text pages writable so they can safely written to. This is
+ * useful for code patching.
  */
 void __kprobes kernel_text_mark_rw(unsigned long address, size_t len)
 {
@@ -846,6 +850,13 @@ void __kprobes kernel_text_mark_rw(unsig
 }
 EXPORT_SYMBOL_GPL(kernel_text_mark_rw);
 
+/**
+ * kernel_text_unmark  -    Mark kernel text back to its original flags
+ * @address:                location of the code
+ * @len:                    size of code to mark
+ *
+ * Mark the kernel text back to its original flags.
+ */
 void __kprobes kernel_text_unmark(unsigned long address, size_t len)
 {
 	if (kernel_text_is_ro && address >= PFN_ALIGN(_text)
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
