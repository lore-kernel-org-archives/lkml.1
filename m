Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYB0VBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYB0VBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758017AbYB0VAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:00:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:11803 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906AbYB0VAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=noidFui2DatQSBhOrDg8n3mQVve6Uou5XwyX2L3IJ9vy/rlzkKB+CcdW+kJdkV4JRj1X1MHfpWMTNQeXOiX2YlhJtfj3FkCgWHYATrqX4+mc7+b3hYTiaN2eNTGMpG1MwNzwrADPtFTodF1wmhETSVAbXwICzXKioxHrKJiPPpI=
Message-Id: <20080227210003.230880164@gmail.com>
References: <20080227205831.150784453@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 Feb 2008 23:58:35 +0300
From: gorcunov@gmail.com
To: rth@twiddle.net, chris@zankel.net, jdike@addtoit.com,
       linuxppc-dev@ozlabs.org, paulus@samba.org, dhowells@redhat.com,
       zippel@linux-m68k.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org,
       linux-kernel@vger.kernel.org
Cc: gorcunov@gmail.com, sam@ravnborg.org
Subject: [RFC 04/10] m68knommu: vmlinux.lds cleanup - use PAGE_SIZE macro
Content-Disposition: inline; filename=m68knommu-vmlinux
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies page.h header to be able to include it
into linker script and then we're able to use PAGE_SIZE in
vmlinux.lds

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

WARNING: COMPLETELY UNTESTED !!!

 arch/m68knommu/kernel/vmlinux.lds.S |    5 +++--
 include/asm-m68knommu/page.h        |    6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6.git/arch/m68knommu/kernel/vmlinux.lds.S
===================================================================
--- linux-2.6.git.orig/arch/m68knommu/kernel/vmlinux.lds.S	2008-02-10 10:46:37.000000000 +0300
+++ linux-2.6.git/arch/m68knommu/kernel/vmlinux.lds.S	2008-02-27 21:24:46.000000000 +0300
@@ -8,6 +8,7 @@
  */
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 
 #if defined(CONFIG_RAMKERNEL)
 #define	RAM_START	CONFIG_KERNELBASE
@@ -140,7 +141,7 @@ SECTIONS {
 	} > DATA
 
 	.init : {
-		. = ALIGN(4096);
+		. = ALIGN(PAGE_SIZE);
 		__init_begin = .;
 		_sinittext = .;
 		INIT_TEXT
@@ -165,7 +166,7 @@ SECTIONS {
 		*(.init.ramfs)
 		__initramfs_end = .;
 #endif
-		. = ALIGN(4096);
+		. = ALIGN(PAGE_SIZE);
 		__init_end = .;
 	} > INIT
 
Index: linux-2.6.git/include/asm-m68knommu/page.h
===================================================================
--- linux-2.6.git.orig/include/asm-m68knommu/page.h	2008-02-10 12:03:48.000000000 +0300
+++ linux-2.6.git/include/asm-m68knommu/page.h	2008-02-27 21:19:37.000000000 +0300
@@ -1,16 +1,18 @@
 #ifndef _M68KNOMMU_PAGE_H
 #define _M68KNOMMU_PAGE_H
 
+#include <linux/const.h>
+
 /* PAGE_SHIFT determines the page size */
 
 #define PAGE_SHIFT	(12)
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #include <asm/setup.h>
 
 #ifndef __ASSEMBLY__
- 
+
 #define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
 #define free_user_page(page, addr)	free_page(addr)
 

-- 
