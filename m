Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbYIGWYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbYIGWYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYIGWYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:24:15 -0400
Received: from gw.goop.org ([64.81.55.164]:39656 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbYIGWYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:24:14 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 7] x86: remove duplicate early_ioremap declarations
X-Mercurial-Node: 087708da30bba247f2a90eaf91ba3857e9d28a71
Message-Id: <087708da30bba247f2a9.1220826074@localhost>
In-Reply-To: <patchbomb.1220826072@localhost>
Date: Sun, 07 Sep 2008 15:21:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_ioremap() is redeclared in several places; remove them.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/io.h    |   14 --------------
 include/asm-x86/io_64.h |    3 ---
 2 files changed, 17 deletions(-)

diff --git a/include/asm-x86/io.h b/include/asm-x86/io.h
--- a/include/asm-x86/io.h
+++ b/include/asm-x86/io.h
@@ -4,20 +4,6 @@
 #define ARCH_HAS_IOREMAP_WC
 
 #include <linux/compiler.h>
-
-/*
- * early_ioremap() and early_iounmap() are for temporary early boot-time
- * mappings, before the real ioremap() is functional.
- * A boot-time mapping is currently limited to at most 16 pages.
- */
-#ifndef __ASSEMBLY__
-extern void early_ioremap_init(void);
-extern void early_ioremap_clear(void);
-extern void early_ioremap_reset(void);
-extern void *early_ioremap(unsigned long offset, unsigned long size);
-extern void early_iounmap(void *addr, unsigned long size);
-extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
-#endif
 
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -165,9 +165,6 @@
 
 #include <asm-generic/iomap.h>
 
-extern void *early_ioremap(unsigned long addr, unsigned long size);
-extern void early_iounmap(void *addr, unsigned long size);
-
 /*
  * This one maps high address device memory and turns off caching for that area.
  * it's useful if some control registers are in such an area and write combining


