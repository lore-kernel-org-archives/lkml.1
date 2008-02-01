Return-Path: <linux-kernel-owner+w=401wt.eu-S1762451AbYBAHmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762451AbYBAHmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933989AbYBAHi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:38:58 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48069 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933493AbYBAHi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:38:57 -0500
Date: Fri, 1 Feb 2008 17:38:03 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010738.m117c3sA022717@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: create common DMA table for ColdFire CPUs
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the ColdFire DMA address table into its own file, and out
of each of the different CPU config files. No need to have a copy
of it in each of the config setup files.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/arch/m68knommu/platform/coldfire/dma.c linux-2.6.24-uc0/arch/m68knommu/platform/coldfire/dma.c
--- linux-2.6.24/arch/m68knommu/platform/coldfire/dma.c	1970-01-01 10:00:00.000000000 +1000
+++ linux-2.6.24-uc0/arch/m68knommu/platform/coldfire/dma.c	2008-01-11 21:02:34.000000000 +1000
@@ -0,0 +1,39 @@
+/***************************************************************************/
+
+/*
+ *	dma.c -- Freescale ColdFire DMA support
+ *
+ *	Copyright (C) 2007, Greg Ungerer (gerg@snapgear.com)
+ */
+
+/***************************************************************************/
+
+#include <linux/kernel.h>
+#include <asm/dma.h>
+#include <asm/coldfire.h>
+#include <asm/mcfsim.h>
+#include <asm/mcfdma.h>
+
+/***************************************************************************/
+
+/*
+ *      DMA channel base address table.
+ */
+unsigned int dma_base_addr[MAX_M68K_DMA_CHANNELS] = {
+#ifdef MCFDMA_BASE0
+	MCF_MBAR + MCFDMA_BASE0,
+#endif
+#ifdef MCFDMA_BASE1
+	MCF_MBAR + MCFDMA_BASE1,
+#endif
+#ifdef MCFDMA_BASE2
+	MCF_MBAR + MCFDMA_BASE2,
+#endif
+#ifdef MCFDMA_BASE3
+	MCF_MBAR + MCFDMA_BASE3,
+#endif
+};
+
+unsigned int dma_device_address[MAX_M68K_DMA_CHANNELS];
+
+/***************************************************************************/
