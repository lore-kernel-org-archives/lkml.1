Return-Path: <linux-kernel-owner+w=401wt.eu-S967081AbYD1Wje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967081AbYD1Wje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965553AbYD1Wg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:36:27 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:36743 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965277AbYD1WgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:24 -0400
Message-Id: <20080428223616.791330438@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:33:49 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 02/55] ISAPNP: move config register addresses out of isapnp.h
Content-Disposition: inline; filename=isapnp-remove-register-addrs-from-header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are used only in drivers/pnp/isapnp/core.c, so no need to
expose them to the world.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-28 15:57:04.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-28 16:09:07.000000000 -0600
@@ -88,6 +88,14 @@
 #define _LTAG_MEM32RANGE	0x85
 #define _LTAG_FIXEDMEM32RANGE	0x86
 
+/* Logical device control and configuration registers */
+
+#define ISAPNP_CFG_ACTIVATE	0x30	/* byte */
+#define ISAPNP_CFG_MEM		0x40	/* 4 * dword */
+#define ISAPNP_CFG_PORT		0x60	/* 8 * word */
+#define ISAPNP_CFG_IRQ		0x70	/* 2 * word */
+#define ISAPNP_CFG_DMA		0x74	/* 2 * byte */
+
 /*
  * Sizes of ISAPNP logical device configuration register sets.
  * See PNP-ISA-v1.0a.pdf, Appendix A.
Index: work10/include/linux/isapnp.h
===================================================================
--- work10.orig/include/linux/isapnp.h	2008-04-28 15:57:04.000000000 -0600
+++ work10/include/linux/isapnp.h	2008-04-28 16:09:07.000000000 -0600
@@ -26,16 +26,6 @@
 #include <linux/pnp.h>
 
 /*
- *  Configuration registers (TODO: change by specification)
- */ 
-
-#define ISAPNP_CFG_ACTIVATE		0x30	/* byte */
-#define ISAPNP_CFG_MEM			0x40	/* 4 * dword */
-#define ISAPNP_CFG_PORT			0x60	/* 8 * word */
-#define ISAPNP_CFG_IRQ			0x70	/* 2 * word */
-#define ISAPNP_CFG_DMA			0x74	/* 2 * byte */
-
-/*
  *
  */
 

-- 
