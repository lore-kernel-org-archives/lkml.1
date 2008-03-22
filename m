Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYCVVEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYCVVEp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbYCVVDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:03:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:63877 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbYCVVDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:03:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=opljBTFT8Hl0KYRt1AohWapxRd8uTS5nNbzP0PAcgmMv//jnf2bypQhTmTjvNdY7hlmq5pIu0kQTwDqEc9xYRDXPhE+F1/OSu7xk/LLJI07aFdMe71Sm3XoLqWEqi9cIiUzqg/hbs9Xtm0iMo0zQiCi3zSzNU4iE6tDNjScO3Hs=
Message-Id: <20080322210311.454621432@gmail.com>
References: <20080322210005.117475478@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 23 Mar 2008 00:00:09 +0300
From: gorcunov@gmail.com
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, gorcunov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [patch 4/4] x86: relocate_kernel - use predefined macroses for page attributes
Content-Disposition: inline; filename=x86-page-attr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/relocate_kernel_32.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/relocate_kernel_32.S	2008-03-22 22:22:16.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/relocate_kernel_32.S	2008-03-22 22:22:17.000000000 +0300
@@ -10,14 +10,15 @@
 #include <asm/page.h>
 #include <asm/kexec.h>
 #include <asm/processor-flags.h>
+#include <asm/pgtable.h>
 
 /*
  * Must be relocatable PIC code callable as a C function
  */
 
 #define PTR(x) (x << 2)
-#define PAGE_ATTR 0x63 /* _PAGE_PRESENT|_PAGE_RW|_PAGE_ACCESSED|_PAGE_DIRTY */
-#define PAE_PGD_ATTR 0x01 /* _PAGE_PRESENT */
+#define PAGE_ATTR (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
+#define PAE_PGD_ATTR (_PAGE_PRESENT)
 
 	.text
 	.align PAGE_SIZE
Index: linux-2.6.git/arch/x86/kernel/relocate_kernel_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/relocate_kernel_64.S	2008-03-22 22:22:16.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/relocate_kernel_64.S	2008-03-22 22:22:17.000000000 +0300
@@ -10,13 +10,14 @@
 #include <asm/page.h>
 #include <asm/kexec.h>
 #include <asm/processor-flags.h>
+#include <asm/pgtable.h>
 
 /*
  * Must be relocatable PIC code callable as a C function
  */
 
 #define PTR(x) (x << 3)
-#define PAGE_ATTR 0x63 /* _PAGE_PRESENT|_PAGE_RW|_PAGE_ACCESSED|_PAGE_DIRTY */
+#define PAGE_ATTR (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
 
 	.text
 	.align PAGE_SIZE

-- 
