Return-Path: <linux-kernel-owner+w=401wt.eu-S1764591AbYEETDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764591AbYEETDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763248AbYEETCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:02:53 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33413 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763237AbYEETCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:02:52 -0400
Message-Id: <20080505190242.254641759@sgi.com>
References: <20080505190213.714827651@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 May 2008 12:02:15 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
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

Index: linux-next/include/asm-x86/e820.h
===================================================================
--- linux-next.orig/include/asm-x86/e820.h	2008-05-04 23:03:30.799851792 -0700
+++ linux-next/include/asm-x86/e820.h	2008-05-04 23:04:37.939859869 -0700
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
@@ -79,18 +79,6 @@ static inline void e820_mark_nosave_regi
 
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
