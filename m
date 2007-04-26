Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbXDZHNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbXDZHNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933159AbXDZHNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:13:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20518 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068AbXDZHNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:13:05 -0400
Date: Thu, 26 Apr 2007 00:15:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: [PATCH -mm, v2] x86_64: kill 19000+ sparse warnings
Message-Id: <20070426001528.373958e9.randy.dunlap@oracle.com>
In-Reply-To: <20070425225516.8b573d34.akpm@linux-foundation.org>
References: <20070425224509.46153baa.randy.dunlap@oracle.com>
	<20070425225516.8b573d34.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> hm, the duplication is unfortunate.
> 
> I wonder if it's worth doing a cpp token-pasting trick to avoid having to
> do that.


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
 include/asm-x86_64/page.h    |    7 ++++---
 include/asm-x86_64/pgtable.h |   10 +++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

--- linux-2.6.21-rc7-mm1.orig/include/asm-x86_64/page.h
+++ linux-2.6.21-rc7-mm1/include/asm-x86_64/page.h
@@ -80,9 +80,10 @@ extern unsigned long phys_base;
 
 #define __PHYSICAL_START	CONFIG_PHYSICAL_START
 #define __KERNEL_ALIGN		0x200000
+
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
-#define __START_KERNEL_map	0xffffffff80000000
-#define __PAGE_OFFSET           0xffff810000000000
+#define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
+#define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
 
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
@@ -94,7 +95,7 @@ extern unsigned long phys_base;
 #define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
 
 #define KERNEL_TEXT_SIZE  (40*1024*1024)
-#define KERNEL_TEXT_START 0xffffffff80000000
+#define KERNEL_TEXT_START _AC(0xffffffff80000000, UL)
 
 #ifndef __ASSEMBLY__
 
--- linux-2.6.21-rc7-mm1.orig/include/asm-x86_64/pgtable.h
+++ linux-2.6.21-rc7-mm1/include/asm-x86_64/pgtable.h
@@ -134,11 +134,11 @@ static inline pte_t ptep_get_and_clear_f
 #define USER_PTRS_PER_PGD	((TASK_SIZE-1)/PGDIR_SIZE+1)
 #define FIRST_USER_ADDRESS	0
 
-#define MAXMEM		 0x3fffffffffff
-#define VMALLOC_START    0xffffc20000000000
-#define VMALLOC_END      0xffffe1ffffffffff
-#define MODULES_VADDR    0xffffffff88000000
-#define MODULES_END      0xfffffffffff00000
+#define MAXMEM		 _AC(0x3fffffffffff, UL)
+#define VMALLOC_START    _AC(0xffffc20000000000, UL)
+#define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
+#define MODULES_VADDR    _AC(0xffffffff88000000, UL)
+#define MODULES_END      _AC(0xfffffffffff00000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
 #define _PAGE_BIT_PRESENT	0
