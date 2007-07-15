Return-Path: <linux-kernel-owner+w=401wt.eu-S1762720AbXGOXig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762720AbXGOXig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759823AbXGOXiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:38:19 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:38268 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759387AbXGOXiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:38:18 -0400
Date: Sun, 15 Jul 2007 19:38:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, hch@infradead.org
Subject: [PATCH] Text Edit Lock - x86_64 kerneldoc implementation
Message-ID: <20070715233816.GG22428@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012412.960272115@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012412.960272115@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:37:11 up 8 days, 13:42,  3 users,  load average: 2.06, 1.10, 0.60
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Text Edit Lock - x86_64 kerneldoc implementation

Add kerneldoc to text edit lock x86_64 API.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
CC: Andi Kleen <andi@firstfloor.org>
---
 arch/x86_64/mm/init.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/x86_64/mm/init.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/mm/init.c	2007-07-15 19:01:50.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/mm/init.c	2007-07-15 19:02:18.000000000 -0400
@@ -617,8 +617,13 @@ void mark_rodata_ro(void)
 	global_flush_tlb();
 }
 
-/*
- * Mark kernel text pages writable.
+/**
+ * kernel_text_mark_rw  -   Mark kernel text RW
+ * @address:                location of the code
+ * @len:                    size of code to mark
+ *
+ * Mark the kernel text pages writable so they can safely written to. This is
+ * useful for code patching.
  */
 void kernel_text_mark_rw(unsigned long address, size_t len)
 {
@@ -636,6 +641,13 @@ void kernel_text_mark_rw(unsigned long a
 }
 EXPORT_SYMBOL_GPL(kernel_text_mark_rw);
 
+/**
+ * kernel_text_unmark  -    Mark kernel text back to its original flags
+ * @address:                location of the code
+ * @len:                    size of code to mark
+ *
+ * Mark the kernel text back to its original flags.
+ */
 void kernel_text_unmark(unsigned long address, size_t len)
 {
 	if (kernel_text_is_ro && address >= PFN_ALIGN(_text)
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
