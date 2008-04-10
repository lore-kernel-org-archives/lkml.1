Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbYDJWDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbYDJWDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbYDJWDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:03:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:52276 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884AbYDJWDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:03:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Wy0p0Vtez6NpWnOQJdJVsGy98lN361bGskZEfH17cVIC7biwaJ3tgcRLOXSv3FYgnJLS2VL6gLY9lLmlgGlktkX0HcsA5iTuzBuqj/LEJqcw2ONkWTR11SXDjaIowjrzz3FVk4Yvy9W+Z1Ii9tBJ/Yt4WaTo/lGY6mR7zV19+mE=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86_64: change _end to end_before_pgt
Date: Thu, 10 Apr 2008 15:06:38 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804101506.38139.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


change the _end in compressed vmlinux_64.lds.

also change _heap to _ebss that is not needed.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 7a212a6..d8819ef 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -244,9 +244,9 @@ ENTRY(startup_64)
 /* Copy the compressed kernel to the end of our buffer
  * where decompression in place becomes safe.
  */
-	leaq	_end(%rip), %r8
-	leaq	_end(%rbx), %r9
-	movq	$_end /* - $startup_32 */, %rcx
+	leaq	_end_before_pgt(%rip), %r8
+	leaq	_end_before_pgt(%rbx), %r9
+	movq	$_end_before_pgt /* - $startup_32 */, %rcx
 1:	subq	$8, %r8
 	subq	$8, %r9
 	movq	0(%r8), %rax
@@ -268,7 +268,7 @@ relocated:
  */
 	xorq	%rax, %rax
 	leaq    _edata(%rbx), %rdi
-	leaq    _end(%rbx), %rcx
+	leaq    _end_before_pgt(%rbx), %rcx
 	subq	%rdi, %rcx
 	cld
 	rep
diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux_64.lds
index 7e5c720..bef1ac8 100644
--- a/arch/x86/boot/compressed/vmlinux_64.lds
+++ b/arch/x86/boot/compressed/vmlinux_64.lds
@@ -39,10 +39,10 @@ SECTIONS
 		*(.bss.*)
 		*(COMMON)
 		. = ALIGN(8);
-		_end = . ;
+		_end_before_pgt = . ;
 		. = ALIGN(4096);
 		pgtable = . ;
 		. = . + 4096 * 6;
-		_heap = .;
+		_ebss = .;
 	}
 }
