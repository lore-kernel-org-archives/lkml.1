Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYEJCLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYEJCLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 22:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYEJCKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 22:10:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54333 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752675AbYEJCKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 22:10:21 -0400
Message-Id: <20080510021020.997934627@sgi.com>
References: <20080510020947.803480649@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:09:51 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Cc: travis@sgi.com
Subject: [patch 4/6] x86: e820 unification: Common #ifdef __ASSEMBLY
Content-Disposition: inline; filename=x86_unify_e820_h_ifdef
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
