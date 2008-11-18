Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYKQN1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYKQN1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYKQN0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:26:34 -0500
Received: from ozlabs.org ([203.10.76.45]:39448 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbYKQN0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:26:32 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon Nov 17 23:48:27 CST 2008
CC: akpm@linux-foundation.org
Subject: [PATCH 5/7] Improve alloc_percpu: documentation
Cc: Christoph Lameter <cl@linux-foundation.org>
Message-Id: <20081117132631.3F127DDE04@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since we can now endorse this interface without wincing, we should
document it.   Nothing has changed API-wise, but it's a nice cleanup.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/asm-generic/percpu.h |    8 ++++++++
 include/linux/percpu.h       |   10 ++++++++++
 mm/allocpercpu.c             |   13 +++++++++++++
 3 files changed, 31 insertions(+)

diff -r cf4fb53a413e include/asm-generic/percpu.h
--- a/include/asm-generic/percpu.h	Mon Nov 17 22:19:33 2008 +1030
+++ b/include/asm-generic/percpu.h	Mon Nov 17 22:19:40 2008 +1030
@@ -61,6 +61,14 @@
 	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset))
 
 /* Use RELOC_HIDE: some arch's SHIFT_PERCPU_PTR really want an identifier. */
+/**
+ * per_cpu_ptr - get a pointer to a particular cpu's allocated memory
+ * @ptr: the pointer returned from alloc_percpu
+ * @cpu: the cpu whose memory you want to access
+ *
+ * Similar to per_cpu(), except for dynamic memory.
+ * cpu_possible(@cpu) must be true.
+ */
 #define per_cpu_ptr(ptr, cpu) \
 	RELOC_HIDE((ptr), (per_cpu_offset(cpu)))
 
diff -r cf4fb53a413e include/linux/percpu.h
--- a/include/linux/percpu.h	Mon Nov 17 22:19:33 2008 +1030
+++ b/include/linux/percpu.h	Mon Nov 17 22:19:40 2008 +1030
@@ -72,6 +72,16 @@
 }
 #endif /* CONFIG_SMP */
 
+/**
+ * alloc_percpu - allocate memory on every possible cpu.
+ * @type: the type to allocate
+ *
+ * Allocates memory for use with per_cpu_ptr/get_cpu_ptr/__get_cpu_ptr.
+ * The memory is always zeroed.  Returns NULL on failure.
+ *
+ * Note that percpu memory is a limited resource; it's usually used for small
+ * allocations.
+ */
 #define alloc_percpu(type) \
 	(type *)__alloc_percpu(sizeof(type), __alignof__(type))
 
diff -r cf4fb53a413e mm/allocpercpu.c
--- a/mm/allocpercpu.c	Mon Nov 17 22:19:33 2008 +1030
+++ b/mm/allocpercpu.c	Mon Nov 17 22:19:40 2008 +1030
@@ -45,6 +45,13 @@
 	return val;
 }
 
+/**
+ * __alloc_percpu - allocate dynamic percpu memory
+ * @size: bytes to allocate
+ * @align: bytes to align (< PAGE_SIZE)
+ *
+ * See alloc_percpu().
+ */
 void *__alloc_percpu(unsigned long size, unsigned long align)
 {
 	unsigned long extra;
@@ -91,6 +98,12 @@
 }
 EXPORT_SYMBOL_GPL(__alloc_percpu);
 
+/**
+ * free_percpu - free memory allocated with alloc_percpu.
+ * @pcpuptr: the pointer returned from alloc_percpu.
+ *
+ * Like kfree(), the argument can be NULL.
+ */
 void free_percpu(void *freeme)
 {
 	unsigned int i;

