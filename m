Return-Path: <linux-kernel-owner+w=401wt.eu-S965232AbYBAHqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965232AbYBAHqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757976AbYBAHjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:39:21 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48079 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756658AbYBAHjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:39:13 -0500
Date: Fri, 1 Feb 2008 17:38:24 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010738.m117cOqk022730@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: fix 528x ColdFire cache settings
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix problems with the 528x ColdFire CPU cache setup.
Do not cache the flash region (if present), and make the runtime
settings consistent with the init setting.

Problems pointed out by Bernd Buttner <b.buettner@mkc-gmbh.de>

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/include/asm-m68knommu/cacheflush.h linux-2.6.24-uc0/include/asm-m68knommu/cacheflush.h
--- linux-2.6.24/include/asm-m68knommu/cacheflush.h	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/include/asm-m68knommu/cacheflush.h	2007-10-29 16:43:08.000000000 +1000
@@ -53,7 +53,7 @@ static inline void __flush_cache_all(voi
 #endif /* CONFIG_M5407 */
 #if defined(CONFIG_M527x) || defined(CONFIG_M528x)
 	__asm__ __volatile__ (
-        	"movel	#0x81400100, %%d0\n\t"
+		"movel	#0x81000200, %%d0\n\t"
         	"movec	%%d0, %%CACR\n\t"
 		"nop\n\t"
 		: : : "d0" );
diff -Naurp linux-2.6.24/include/asm-m68knommu/mcfcache.h linux-2.6.24-uc0/include/asm-m68knommu/mcfcache.h
--- linux-2.6.24/include/asm-m68knommu/mcfcache.h	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/include/asm-m68knommu/mcfcache.h	2007-10-29 16:43:08.000000000 +1000
@@ -60,7 +60,7 @@
 	nop
 	movel	#0x0000c020, %d0	/* Set SDRAM cached only */
 	movec	%d0, %ACR0
-	movel	#0xff00c000, %d0	/* Cache Flash also */
+	movel	#0x00000000, %d0	/* No other regions cached */
 	movec	%d0, %ACR1
 	movel	#0x80000200, %d0	/* Setup cache mask */
 	movec	%d0, %CACR		/* Enable cache */
