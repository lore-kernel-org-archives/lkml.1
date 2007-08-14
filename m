Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbXHNWBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbXHNWBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbXHNVk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:40:59 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:42225 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934469AbXHNVkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:40:45 -0400
Date: Tue, 14 Aug 2007 17:40:21 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 8/14] UML - Remove __u64 usage from physical memory subsystem
Message-ID: <20070814214021.GA17305@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate some uses of __u64 in the physical memory support.  It's
hard to get a definition of __u64 in both kernel and userspace code on
x86_64, so this changes them to unsigned long long.

There are also a copyright update and formatting comment removal from
the affected header.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/mem.h           |   21 ++-------------------
 arch/um/kernel/physmem.c        |    2 +-
 arch/um/os-Linux/skas/process.c |    6 +++---
 3 files changed, 6 insertions(+), 23 deletions(-)

Index: linux-2.6.22/arch/um/include/mem.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/mem.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22/arch/um/include/mem.h	2007-08-14 13:27:12.000000000 -0400
@@ -1,18 +1,12 @@
 /* 
- * Copyright (C) 2002, 2003 Jeff Dike (jdike@addtoit.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #ifndef __MEM_H__
 #define __MEM_H__
 
-#include "linux/types.h"
-
-extern int phys_mapping(unsigned long phys, __u64 *offset_out);
-extern int physmem_subst_mapping(void *virt, int fd, __u64 offset, int w);
-extern int is_remapped(void *virt);
-extern int physmem_remove_mapping(void *virt);
-extern void physmem_forget_descriptor(int fd);
+extern int phys_mapping(unsigned long phys, unsigned long long *offset_out);
 
 extern unsigned long uml_physmem;
 static inline unsigned long to_phys(void *virt)
@@ -26,14 +20,3 @@ static inline void *to_virt(unsigned lon
 }
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
Index: linux-2.6.22/arch/um/kernel/physmem.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/physmem.c	2007-08-14 13:25:59.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/physmem.c	2007-08-14 13:27:12.000000000 -0400
@@ -115,7 +115,7 @@ void __init setup_physmem(unsigned long 
 		     len - bootmap_size - reserve);
 }
 
-int phys_mapping(unsigned long phys, __u64 *offset_out)
+int phys_mapping(unsigned long phys, unsigned long long *offset_out)
 {
 	int fd = -1;
 
Index: linux-2.6.22/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/skas/process.c	2007-08-14 13:25:59.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/skas/process.c	2007-08-14 13:27:12.000000000 -0400
@@ -382,7 +382,7 @@ int copy_context_skas0(unsigned long new
 	unsigned long current_stack = current_stub_stack();
 	struct stub_data *data = (struct stub_data *) current_stack;
 	struct stub_data *child_data = (struct stub_data *) new_stack;
-	__u64 new_offset;
+	unsigned long long new_offset;
 	int new_fd = phys_mapping(to_phys((void *)new_stack), &new_offset);
 
 	/*
@@ -444,7 +444,7 @@ void map_stub_pages(int fd, unsigned lon
 {
 	struct proc_mm_op mmop;
 	int n;
-	__u64 code_offset;
+	unsigned long long code_offset;
 	int code_fd = phys_mapping(to_phys((void *) &__syscall_stub_start),
 				   &code_offset);
 
@@ -469,7 +469,7 @@ void map_stub_pages(int fd, unsigned lon
 	}
 
 	if (stack) {
-		__u64 map_offset;
+		unsigned long long map_offset;
 		int map_fd = phys_mapping(to_phys((void *)stack), &map_offset);
 		mmop = ((struct proc_mm_op)
 				{ .op        = MM_MMAP,
