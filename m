Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbXGOXfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbXGOXfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbXGOXfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:35:43 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:55001 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbXGOXfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:35:42 -0400
Date: Sun, 15 Jul 2007 19:35:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH] Text Edit Lock - Architecture Independent Code for Implementation
Message-ID: <20070715233541.GE22428@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012411.845928928@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012411.845928928@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:34:45 up 8 days, 13:40,  3 users,  load average: 0.73, 0.81, 0.45
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Text Edit Lock - Architecture Independent Code - kerneldoc implementation

Add kerneldoc to text edit lock API.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
---
 mm/memory.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/mm/memory.c
===================================================================
--- linux-2.6-lttng.orig/mm/memory.c	2007-07-15 18:56:32.000000000 -0400
+++ linux-2.6-lttng/mm/memory.c	2007-07-15 18:57:18.000000000 -0400
@@ -2820,9 +2820,12 @@ int access_process_vm(struct task_struct
 }
 EXPORT_SYMBOL_GPL(access_process_vm);
 
-/*
- * Lock the kernel text for mutual write exclusion. Used for dynamic code
- * patching.
+/**
+ * kernel_text_lock     -   Take the kernel text modification lock
+ *
+ * Insures mutual write exclusion of kernel and modules text live text
+ * modification. Should be used for code patching.
+ * Users of this lock can sleep.
  */
 void __kprobes kernel_text_lock(void)
 {
@@ -2830,6 +2833,13 @@ void __kprobes kernel_text_lock(void)
 }
 EXPORT_SYMBOL_GPL(kernel_text_lock);
 
+/**
+ * kernel_text_unlock   -   Release the kernel text modification lock
+ *
+ * Insures mutual write exclusion of kernel and modules text live text
+ * modification. Should be used for code patching.
+ * Users of this lock can sleep.
+ */
 void __kprobes kernel_text_unlock(void)
 {
 	mutex_unlock(&text_mutex);
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
