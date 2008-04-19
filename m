Return-Path: <linux-kernel-owner+w=401wt.eu-S1762897AbYDSPJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762897AbYDSPJc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762581AbYDSPHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:07:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:11069 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762572AbYDSPHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:07:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=I6HNbGpfHeEczWaiBPM4ymBRIr3E23rHYK8EDLjLr2xMoCpcFY9hGlAc/qyTV3hKPJWYUI5cDAeic5K9flmes8NH5EdHMCrARy7n6wt9dyQKynbDla8rQLGeI2eBFXBPwE1Z1yOCODsZejFCOxwtFyjyjH2DJA92w0jrfG0FQPQ=
References: <20080419145510.150338641@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 19 Apr 2008 23:55:19 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 09/10] x86: remove duplicate get_bios_ebda() from rio.h
Content-Disposition: inline; filename=x86-use-get-bios-ebda-2.patch
Message-ID: <480a0aa4.1abd600a.2e2c.0df1@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_bios_ebda() exists in asm/rio.h and asm/bios_ebda.h.
This patch removes the one in asm/rio.h.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/pci-calgary_64.c |    1 +
 include/asm-x86/rio.h            |   11 -----------
 2 files changed, 1 insertion(+), 11 deletions(-)

Index: 2.6-git/arch/x86/kernel/pci-calgary_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/pci-calgary_64.c
+++ 2.6-git/arch/x86/kernel/pci-calgary_64.c
@@ -43,6 +43,7 @@
 #include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/rio.h>
+#include <asm/bios_ebda.h>
 
 #ifdef CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT
 int use_calgary __read_mostly = 1;
Index: 2.6-git/include/asm-x86/rio.h
===================================================================
--- 2.6-git.orig/include/asm-x86/rio.h
+++ 2.6-git/include/asm-x86/rio.h
@@ -60,15 +60,4 @@ enum {
 	ALT_CALGARY	= 5,	/* Second Planar Calgary      */
 };
 
-/*
- * there is a real-mode segmented pointer pointing to the
- * 4K EBDA area at 0x40E.
- */
-static inline unsigned long get_bios_ebda(void)
-{
-	unsigned long address = *(unsigned short *)phys_to_virt(0x40EUL);
-	address <<= 4;
-	return address;
-}
-
 #endif /* __ASM_RIO_H */

-- 
