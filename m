Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYEHP11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYEHP11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYEHP0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:26:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:30628 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbYEHP0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=pHIDSGQompJp6ekD5Mu5c6oSOrkDAmIcbvJRTamnhoScdZuab1YTPA81vUxeZjI8kKaz5pFxFK3e8oE2pHRAixB7c+RgW1YIRfzBj4gFbUhoyBK+rQP8voL8rzSVqB6bfDGnmLbh5CsDXWpZy3Kv3Zgo/M29yN0z7kBFxFv5U0E=
References: <20080508150756.053095824@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 08 May 2008 19:07:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/2] x86: compressed/head_64.S cleanup - use predefined flags from processor-flags.h
Content-Disposition: inline; filename=x86-compressed-head-64-S-pae
Message-ID: <48231ba6.1438560a.52f7.ffffa8b5@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should better use already defined flags from processor-flags.h instead
of defining own ones

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

[>>> object code check >>>]

original
md5sum: 129f24be6df396fb7d8bf998c01fc716  arch/x86/boot/compressed/head_64.o
   text    data     bss     dec     hex filename
    705      48   45056   45809    b2f1 arch/x86/boot/compressed/head_64.o

patched
md5sum: 129f24be6df396fb7d8bf998c01fc716  arch/x86/boot/compressed/head_64-new.o
   text    data     bss     dec     hex filename
    705      48   45056   45809    b2f1 arch/x86/boot/compressed/head_64-new.o

[<<< object code check <<<]

Index: linux-2.6.git/arch/x86/boot/compressed/head_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/boot/compressed/head_64.S	2008-04-29 21:20:57.000000000 +0400
+++ linux-2.6.git/arch/x86/boot/compressed/head_64.S	2008-05-08 18:37:32.000000000 +0400
@@ -30,6 +30,7 @@
 #include <asm/page.h>
 #include <asm/boot.h>
 #include <asm/msr.h>
+#include <asm/processor-flags.h>
 #include <asm/asm-offsets.h>
 
 .section ".text.head"
@@ -109,7 +110,7 @@ startup_32:
 
 	/* Enable PAE mode */
 	xorl	%eax, %eax
-	orl	$(1 << 5), %eax
+	orl	$(X86_CR4_PAE), %eax
 	movl	%eax, %cr4
 
  /*
@@ -170,7 +171,7 @@ startup_32:
 	pushl	%eax
 
 	/* Enter paged protected Mode, activating Long Mode */
-	movl	$0x80000001, %eax /* Enable Paging and Protected mode */
+	movl	$(X86_CR0_PG | X86_CR0_PE), %eax /* Enable Paging and Protected mode */
 	movl	%eax, %cr0
 
 	/* Jump from 32bit compatibility mode into 64bit mode. */

-- 
