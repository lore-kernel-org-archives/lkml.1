Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbZBMVyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbZBMVyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZBMVyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:54:12 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:59512 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZBMVyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:54:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=P6jRbg6167gzGAwInGd2wxU7s7uVfQ9wf5qRJ7wI97XqVYeng++yjrcTX2Nn3Q73cf
         rZNvf/te4rrj94LhCFqBgejhtjJF2jBQJE8aJJN9fER1VeLqZriyCz5h5h3ikAei0Msj
         mSf7CeITeyTEG+JM7X/USAE7fD7aaaHTX6Y8Y=
Message-Id: <20090213215404.569727138@gmail.com>
User-Agent: quilt/0.47-1
Date: Sat, 14 Feb 2009 00:50:21 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, heukelum@fastmail.fm
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 4/6] x86: pmjump - use GLOBAL,ENDPROC macros
References: <20090213215017.959278111@gmail.com>
Content-Disposition: inline; filename=x86-boot-pmjump-linkage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

We are in setup stage so we use GLOBAL
instead of ENTRY and do not increase code
size.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/boot/pmjump.S |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

Index: linux-2.6.git/arch/x86/boot/pmjump.S
===================================================================
--- linux-2.6.git.orig/arch/x86/boot/pmjump.S
+++ linux-2.6.git/arch/x86/boot/pmjump.S
@@ -15,18 +15,15 @@
 #include <asm/boot.h>
 #include <asm/processor-flags.h>
 #include <asm/segment.h>
+#include <linux/linkage.h>
 
 	.text
-
-	.globl	protected_mode_jump
-	.type	protected_mode_jump, @function
-
 	.code16
 
 /*
  * void protected_mode_jump(u32 entrypoint, u32 bootparams);
  */
-protected_mode_jump:
+GLOBAL(protected_mode_jump)
 	movl	%edx, %esi		# Pointer to boot_params table
 
 	xorl	%ebx, %ebx
@@ -47,12 +44,10 @@ protected_mode_jump:
 	.byte	0x66, 0xea		# ljmpl opcode
 2:	.long	in_pm32			# offset
 	.word	__BOOT_CS		# segment
-
-	.size	protected_mode_jump, .-protected_mode_jump
+ENDPROC(protected_mode_jump)
 
 	.code32
-	.type	in_pm32, @function
-in_pm32:
+GLOBAL(in_pm32)
 	# Set up data segments for flat 32-bit mode
 	movl	%ecx, %ds
 	movl	%ecx, %es
@@ -78,5 +73,4 @@ in_pm32:
 	lldt	%cx
 
 	jmpl	*%eax			# Jump to the 32-bit entrypoint
-
-	.size	in_pm32, .-in_pm32
+ENDPROC(in_pm32)

