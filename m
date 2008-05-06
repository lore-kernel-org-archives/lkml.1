Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbYEFTeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbYEFTeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbYEFTeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:34:05 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35644 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757139AbYEFTeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:34:03 -0400
Message-Id: <20080506193402.831140371@sgi.com>
References: <20080506193352.225379637@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 May 2008 12:33:55 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>
Subject: [patch 3/4] x86: e820 unification: Common #ifdef __ASSEMBLY
Content-Disposition: inline; filename=e820_1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both include files use #ifdef __ASSEMBLY__ which can be moved outside
of the #ifdef CONFIG_X86_32.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/e820.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h	2008-05-06 11:48:09.000000000 -0700
+++ linux-2.6/include/asm-x86/e820.h	2008-05-06 11:50:53.000000000 -0700
@@ -42,11 +42,11 @@ struct e820map {
  */
 #include <linux/ioport.h>
 
+#ifndef __ASSEMBLY__
+
 #ifdef CONFIG_X86_32
 #define HIGH_MEMORY	(1024*1024)
 
-#ifndef __ASSEMBLY__
-
 extern void setup_memory_map(void);
 extern void finish_e820_parsing(void);
 
@@ -77,10 +77,7 @@ static inline void e820_mark_nosave_regi
 }
 #endif
 
-
-#endif/*!__ASSEMBLY__*/
 #else /* X86_32 */
-#ifndef __ASSEMBLY__
 extern unsigned long find_e820_area(unsigned long start, unsigned long end,
 				    unsigned long size, unsigned long align);
 extern unsigned long find_e820_area_size(unsigned long start,
@@ -118,9 +115,8 @@ extern void reserve_early(unsigned long 
 extern void free_early(unsigned long start, unsigned long end);
 extern void early_res_to_bootmem(unsigned long start, unsigned long end);
 
+#endif /* X86_32 */
 #endif/*!__ASSEMBLY__*/
-
-#endif
 #endif /* __KERNEL__ */
 
 #endif  /* __ASM_E820_H */

-- 
