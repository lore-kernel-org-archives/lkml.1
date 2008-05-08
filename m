Return-Path: <linux-kernel-owner+w=401wt.eu-S1762864AbYEHP06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864AbYEHP06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYEHP03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:26:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:30575 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYEHP01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=AB1v5DLVuZHlokptSqGz7SCW8p3qcRzSaax2yC2QKW5VJmGd8YqRQ0MSFTmamCA7BlV+B8sze4QVb/tTWqLZRlnq2o2HabII4oKpCgNUE0l95T6xl96cmLGVnQxkdMPrpot+qnFRSAy5n9UA1j4Vk/nWMEX6kreHRFi7POpvkEk=
References: <20080508150756.053095824@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 08 May 2008 19:07:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/2] x86: head_64.S cleanup - use predefined flags from processor-flags.h
Content-Disposition: inline; filename=x86-head-64-S-use-processor-flags
Message-ID: <48231ba0.1438560a.52b4.ffffb31c@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should better use already defined flags from processor-flags.h instead
of defining own ones

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

[>>> object code check >>>]

original
md5sum: 9cfa6dbf045a046bb5dfb85f8bcfe8c4  arch/x86/kernel/head_64.o
   text    data     bss     dec     hex filename
  37361    4432    8192   49985    c341 arch/x86/kernel/head_64.o

patched
md5sum: 9cfa6dbf045a046bb5dfb85f8bcfe8c4  arch/x86/kernel/head_64.o
   text    data     bss     dec     hex filename
  37361    4432    8192   49985    c341 arch/x86/kernel/head_64.o

[<<< object code check <<<]

Index: linux-2.6.git/arch/x86/kernel/head_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/head_64.S	2008-05-08 17:45:34.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/head_64.S	2008-05-08 17:47:29.000000000 +0400
@@ -18,6 +18,7 @@
 #include <asm/page.h>
 #include <asm/msr.h>
 #include <asm/cache.h>
+#include <asm/processor-flags.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/asm-offsets.h>
@@ -184,14 +185,10 @@ ENTRY(secondary_startup_64)
 1:	wrmsr				/* Make changes effective */
 
 	/* Setup cr0 */
-#define CR0_PM				1		/* protected mode */
-#define CR0_MP				(1<<1)
-#define CR0_ET				(1<<4)
-#define CR0_NE				(1<<5)
-#define CR0_WP				(1<<16)
-#define CR0_AM				(1<<18)
-#define CR0_PAGING 			(1<<31)
-	movl $CR0_PM|CR0_MP|CR0_ET|CR0_NE|CR0_WP|CR0_AM|CR0_PAGING,%eax
+#define CR0_STATE	(X86_CR0_PE | X86_CR0_MP | X86_CR0_ET | \
+			 X86_CR0_NE | X86_CR0_WP | X86_CR0_AM | \
+			 X86_CR0_PG)
+	movl	$CR0_STATE, %eax
 	/* Make changes effective */
 	movq	%rax, %cr0
 

-- 
