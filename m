Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbXDZFne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbXDZFne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbXDZFne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:43:34 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58833 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbXDZFnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:43:33 -0400
Date: Wed, 25 Apr 2007 22:45:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: ak@suse.de, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] x86_64: kill 19000+ sparse warnings
Message-Id: <20070425224509.46153baa.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Eliminate 19439 (!!) sparse warnings like:
include/linux/mm.h:321:22: warning: constant 0xffff810000000000 is so big it is unsigned long

Eliminate 56 sparse warnings like:
arch/x86_64/kernel/setup.c:248:16: warning: constant 0xffffffff80000000 is so big it is unsigned long

Eliminate 5 sparse warnings like:
arch/x86_64/kernel/module.c:49:13: warning: constant 0xfffffffffff00000 is so big it is unsigned long

Eliminate 23 sparse warnings like:
arch/x86_64/mm/init.c:551:37: warning: constant 0xffffc20000000000 is so big it is unsigned long

Eliminate 6 sparse warnings like:
arch/x86_64/kernel/module.c:49:13: warning: constant 0xffffffff88000000 is so big it is unsigned long

Eliminate 23 sparse warnings like:
arch/x86_64/mm/init.c:552:6: warning: constant 0xffffe1ffffffffff is so big it is unsigned long

Eliminate 3 sparse warnings like:
arch/x86_64/kernel/e820.c:186:17: warning: constant 0x3fffffffffff is so big it is long

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/asm-x86_64/page.h    |   11 +++++++++++
 include/asm-x86_64/pgtable.h |    9 +++++++++
 2 files changed, 20 insertions(+)

--- linux-2.6.21-rc7-mm1.orig/include/asm-x86_64/page.h
+++ linux-2.6.21-rc7-mm1/include/asm-x86_64/page.h
@@ -80,9 +80,16 @@ extern unsigned long phys_base;
 
 #define __PHYSICAL_START	CONFIG_PHYSICAL_START
 #define __KERNEL_ALIGN		0x200000
+
+#ifdef __ASSEMBLY__
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	0xffffffff80000000
 #define __PAGE_OFFSET           0xffff810000000000
+#else
+#define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
+#define __START_KERNEL_map	0xffffffff80000000UL
+#define __PAGE_OFFSET           0xffff810000000000UL
+#endif
 
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
@@ -94,7 +101,11 @@ extern unsigned long phys_base;
 #define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
 
 #define KERNEL_TEXT_SIZE  (40*1024*1024)
+#ifdef __ASSEMBLY__
 #define KERNEL_TEXT_START 0xffffffff80000000
+#else
+#define KERNEL_TEXT_START 0xffffffff80000000UL
+#endif
 
 #ifndef __ASSEMBLY__
 
--- linux-2.6.21-rc7-mm1.orig/include/asm-x86_64/pgtable.h
+++ linux-2.6.21-rc7-mm1/include/asm-x86_64/pgtable.h
@@ -134,12 +134,21 @@ static inline pte_t ptep_get_and_clear_f
 #define USER_PTRS_PER_PGD	((TASK_SIZE-1)/PGDIR_SIZE+1)
 #define FIRST_USER_ADDRESS	0
 
+#ifdef __ASSEMBLY__
 #define MAXMEM		 0x3fffffffffff
 #define VMALLOC_START    0xffffc20000000000
 #define VMALLOC_END      0xffffe1ffffffffff
 #define MODULES_VADDR    0xffffffff88000000
 #define MODULES_END      0xfffffffffff00000
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
+#else
+#define MAXMEM		 0x3fffffffffffUL
+#define VMALLOC_START    0xffffc20000000000UL
+#define VMALLOC_END      0xffffe1ffffffffffUL
+#define MODULES_VADDR    0xffffffff88000000UL
+#define MODULES_END      0xfffffffffff00000UL
+#define MODULES_LEN   (MODULES_END - MODULES_VADDR)
+#endif
 
 #define _PAGE_BIT_PRESENT	0
 #define _PAGE_BIT_RW		1
