Return-Path: <linux-kernel-owner+w=401wt.eu-S1765565AbYEFTfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765565AbYEFTfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761136AbYEFTeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:34:06 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35643 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757144AbYEFTeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:34:03 -0400
Message-Id: <20080506193402.583527337@sgi.com>
References: <20080506193352.225379637@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 May 2008 12:33:54 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>
Subject: [patch 2/4] x86: e820 unification: Extract shared comments
Content-Disposition: inline; filename=e820_comments
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comments are basically the same. Take the 64 bit version as the common
comments.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/e820.h |   26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h	2008-05-06 11:46:45.000000000 -0700
+++ linux-2.6/include/asm-x86/e820.h	2008-05-06 11:48:09.000000000 -0700
@@ -29,20 +29,20 @@ struct e820map {
 #define BIOS_END		0x00100000
 
 #ifdef __KERNEL__
-#ifdef CONFIG_X86_32
+
 /*
  * structures and definitions for the int 15, ax=e820 memory map
  * scheme.
  *
- * In a nutshell, arch/i386/boot/setup.S populates a scratch table
- * in the empty_zero_block that contains a list of usable address/size
- * duples.   In arch/i386/kernel/setup.c, this information is
- * transferred into the e820map, and in arch/i386/mm/init.c, that
- * new information is used to mark pages reserved or not.
- *
+ * In a nutshell, setup.S populates a scratch table in the
+ * empty_zero_block that contains a list of usable address/size
+ * duples.  setup.c, this information is transferred into the e820map,
+ * and in init.c/numa.c, that new information is used to mark pages
+ * reserved or not.
  */
 #include <linux/ioport.h>
 
+#ifdef CONFIG_X86_32
 #define HIGH_MEMORY	(1024*1024)
 
 #ifndef __ASSEMBLY__
@@ -80,18 +80,6 @@ static inline void e820_mark_nosave_regi
 
 #endif/*!__ASSEMBLY__*/
 #else /* X86_32 */
-/*
- * structures and definitions for the int 15, ax=e820 memory map
- * scheme.
- *
- * In a nutshell, setup.S populates a scratch table in the
- * empty_zero_block that contains a list of usable address/size
- * duples.  setup.c, this information is transferred into the e820map,
- * and in init.c/numa.c, that new information is used to mark pages
- * reserved or not.
- */
-#include <linux/ioport.h>
-
 #ifndef __ASSEMBLY__
 extern unsigned long find_e820_area(unsigned long start, unsigned long end,
 				    unsigned long size, unsigned long align);

-- 
