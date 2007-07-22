Return-Path: <linux-kernel-owner+w=401wt.eu-S1760896AbXGVH0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbXGVH0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 03:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbXGVH0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 03:26:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36521 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbXGVH0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 03:26:12 -0400
Date: Sun, 22 Jul 2007 08:26:11 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, sam@ravnborg.org
Subject: [PATCH] sparc32 missing exports
Message-ID: <20070722072611.GU21668@ftp.linux.org.uk>
References: <20070721.232207.26531557.davem@davemloft.net> <20070722063149.GQ21668@ftp.linux.org.uk> <20070722063511.GR21668@ftp.linux.org.uk> <20070721.233949.35357470.davem@davemloft.net> <20070722072206.GT21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722072206.GT21668@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

... and with that on top of js-rtc patch we are down to floppy_hardirq
as sparc32 allmodconfig-without-SUN4 list of missing symbols.  floppy_hardirq
is a separate story...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
>From d278b08de78546f146c4cebe74b51ff74bbe8695 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Sat, 21 Jul 2007 23:08:39 -0400
Subject: [PATCH] sparc32: missing exports

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/kernel/sparc_ksyms.c |    3 +++
 arch/sparc/prom/printf.c        |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/kernel/sparc_ksyms.c b/arch/sparc/kernel/sparc_ksyms.c
index 55bac51..7b4abde 100644
--- a/arch/sparc/kernel/sparc_ksyms.c
+++ b/arch/sparc/kernel/sparc_ksyms.c
@@ -161,6 +161,8 @@ EXPORT_SYMBOL(BTFIXUP_CALL(mmu_get_scsi_one));
 EXPORT_SYMBOL(BTFIXUP_CALL(mmu_release_scsi_sgl));
 EXPORT_SYMBOL(BTFIXUP_CALL(mmu_release_scsi_one));
 
+EXPORT_SYMBOL(BTFIXUP_CALL(pgprot_noncached));
+
 #ifdef CONFIG_SBUS
 EXPORT_SYMBOL(sbus_root);
 EXPORT_SYMBOL(dma_chain);
@@ -260,6 +262,7 @@ EXPORT_SYMBOL(__memmove);
 /* Moving data to/from userspace. */
 EXPORT_SYMBOL(__copy_user);
 EXPORT_SYMBOL(__strncpy_from_user);
+EXPORT_SYMBOL(__strnlen_user);
 
 /* Networking helper routines. */
 EXPORT_SYMBOL(__csum_partial_copy_sparc_generic);
diff --git a/arch/sparc/prom/printf.c b/arch/sparc/prom/printf.c
index 27fdac9..a36ab9c 100644
--- a/arch/sparc/prom/printf.c
+++ b/arch/sparc/prom/printf.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 
 #include <asm/openprom.h>
 #include <asm/oplib.h>
@@ -44,3 +45,4 @@ prom_printf(char *fmt, ...)
 
 	prom_write(ppbuf, i);
 }
+EXPORT_SYMBOL(prom_printf);
-- 
1.5.3.GIT

