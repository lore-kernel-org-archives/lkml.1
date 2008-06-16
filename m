Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbYFPWHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbYFPWHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 18:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbYFPWHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 18:07:24 -0400
Received: from gw.goop.org ([64.81.55.164]:56360 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbYFPWHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:07:23 -0400
Message-ID: <4856E3D3.2010207@goop.org>
Date: Mon, 16 Jun 2008 15:06:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: the arch/x86 maintainers <x86@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make asm/asm.h work for asm code.
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful for unifying some pieces of asm code.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/asm.h |   56 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 16 deletions(-)

===================================================================
--- a/include/asm-x86/asm.h
+++ b/include/asm-x86/asm.h
@@ -1,33 +1,57 @@
 #ifndef _ASM_X86_ASM_H
 #define _ASM_X86_ASM_H
+
+#include <linux/stringify.h>
 
 #ifdef CONFIG_X86_32
 /* 32 bits */
 
-# define _ASM_PTR	" .long "
-# define _ASM_ALIGN	" .balign 4 "
-# define _ASM_MOV_UL	" movl "
+# define __ASM_PTR	.long
+# define __ASM_ALIGN	.balign 4
+# define __ASM_MOV_UL	movl
 
-# define _ASM_INC	" incl "
-# define _ASM_DEC	" decl "
-# define _ASM_ADD	" addl "
-# define _ASM_SUB	" subl "
-# define _ASM_XADD	" xaddl "
+# define __ASM_INC	incl
+# define __ASM_DEC	decl
+# define __ASM_ADD	addl
+# define __ASM_SUB	subl
+# define __ASM_XADD	xaddl
 
 #else
 /* 64 bits */
 
-# define _ASM_PTR	" .quad "
-# define _ASM_ALIGN	" .balign 8 "
-# define _ASM_MOV_UL	" movq "
+# define __ASM_PTR	.quad
+# define __ASM_ALIGN	.balign 8
+# define __ASM_MOV_UL	movq
 
-# define _ASM_INC	" incq "
-# define _ASM_DEC	" decq "
-# define _ASM_ADD	" addq "
-# define _ASM_SUB	" subq "
-# define _ASM_XADD	" xaddq "
+# define __ASM_INC	incq
+# define __ASM_DEC	decq
+# define __ASM_ADD	addq
+# define __ASM_SUB	subq
+# define __ASM_XADD	xaddq
 
 #endif /* CONFIG_X86_32 */
+
+#ifdef __ASSEMBLER__
+#define _ASM_PTR	__ASM_PTR
+#define _ASM_ALIGN	__ASM_ALIGN
+#define _ASM_MOV_UL	__ASM_MOV_UL
+
+#define _ASM_INC	__ASM_INC
+#define _ASM_DEC	__ASM_DEC
+#define _ASM_ADD	__ASM_ADD
+#define _ASM_SUB	__ASM_SUB
+#define _ASM_XADD	__ASM_XADD
+#else  /* !ASSEMBLER */
+#define _ASM_PTR	" " __stringify(__ASM_PTR) " "
+#define _ASM_ALIGN	" " __stringify(__ASM_ALIGN) " "
+#define _ASM_MOV_UL	" " __stringify(__ASM_MOV_UL) " "
+
+#define _ASM_INC	" " __stringify(__ASM_INC) " "
+#define _ASM_DEC	" " __stringify(__ASM_DEC) " "
+#define _ASM_ADD	" " __stringify(__ASM_ADD) " "
+#define _ASM_SUB	" " __stringify(__ASM_SUB) " "
+#define _ASM_XADD	" " __stringify(__ASM_XADD) " "
+#endif	/* __ASSEMBLER__ */
 
 /* Exception table entry */
 # define _ASM_EXTABLE(from,to) \


