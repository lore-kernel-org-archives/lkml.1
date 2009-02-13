Return-Path: <linux-kernel-owner+w=401wt.eu-S1761351AbZBMVyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761351AbZBMVyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZBMVyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:54:13 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:27856 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZBMVyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:54:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=uZT5uPYw17cuRCLDvHODm2fE1ZHAN6OLRRjuGeDp2fUcZeyzlcUPVk2GpFmM67HTj2
         B0FqynQr1Ylbgdc6uinVpMufRz/PWADPmVOuwQSTERLjD1FHoxqhgNKF0452YtKPnLWm
         TaHklM4ZBRVBfODQQhpvbTfsI/2sp7eTCcjK4=
Message-Id: <20090213215404.430561437@gmail.com>
User-Agent: quilt/0.47-1
Date: Sat, 14 Feb 2009 00:50:20 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, heukelum@fastmail.fm
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 3/6] x86: copy.S - use GLOBAL,ENDPROC macros
References: <20090213215017.959278111@gmail.com>
Content-Disposition: inline; filename=x86-boot-copy-add-global
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/boot/copy.S |   40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

Index: linux-2.6.git/arch/x86/boot/copy.S
===================================================================
--- linux-2.6.git.orig/arch/x86/boot/copy.S
+++ linux-2.6.git/arch/x86/boot/copy.S
@@ -8,6 +8,8 @@
  *
  * ----------------------------------------------------------------------- */
 
+#include <linux/linkage.h>
+
 /*
  * Memory copy routines
  */
@@ -15,9 +17,7 @@
 	.code16gcc
 	.text
 
-	.globl	memcpy
-	.type	memcpy, @function
-memcpy:
+GLOBAL(memcpy)
 	pushw	%si
 	pushw	%di
 	movw	%ax, %di
@@ -31,11 +31,9 @@ memcpy:
 	popw	%di
 	popw	%si
 	ret
-	.size	memcpy, .-memcpy
+ENDPROC(memcpy)
 
-	.globl	memset
-	.type	memset, @function
-memset:
+GLOBAL(memset)
 	pushw	%di
 	movw	%ax, %di
 	movzbl	%dl, %eax
@@ -48,52 +46,42 @@ memset:
 	rep; stosb
 	popw	%di
 	ret
-	.size	memset, .-memset
+ENDPROC(memset)
 
-	.globl	copy_from_fs
-	.type	copy_from_fs, @function
-copy_from_fs:
+GLOBAL(copy_from_fs)
 	pushw	%ds
 	pushw	%fs
 	popw	%ds
 	call	memcpy
 	popw	%ds
 	ret
-	.size	copy_from_fs, .-copy_from_fs
+ENDPROC(copy_from_fs)
 
-	.globl	copy_to_fs
-	.type	copy_to_fs, @function
-copy_to_fs:
+GLOBAL(copy_to_fs)
 	pushw	%es
 	pushw	%fs
 	popw	%es
 	call	memcpy
 	popw	%es
 	ret
-	.size	copy_to_fs, .-copy_to_fs
+ENDPROC(copy_to_fs)
 
 #if 0 /* Not currently used, but can be enabled as needed */
-
-	.globl	copy_from_gs
-	.type	copy_from_gs, @function
-copy_from_gs:
+GLOBAL(copy_from_gs)
 	pushw	%ds
 	pushw	%gs
 	popw	%ds
 	call	memcpy
 	popw	%ds
 	ret
-	.size	copy_from_gs, .-copy_from_gs
-	.globl	copy_to_gs
+ENDPROC(copy_from_gs)
 
-	.type	copy_to_gs, @function
-copy_to_gs:
+GLOBAL(copy_to_gs)
 	pushw	%es
 	pushw	%gs
 	popw	%es
 	call	memcpy
 	popw	%es
 	ret
-	.size	copy_to_gs, .-copy_to_gs
-
+ENDPROC(copy_to_gs)
 #endif

