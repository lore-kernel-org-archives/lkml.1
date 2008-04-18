Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbYDRVK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbYDRVK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761530AbYDRUxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:53:25 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:26398 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761292AbYDRUwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:31 -0400
Message-Id: <20080418205056.178783428@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:39 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 44/53] PNP: add pnp_resource_type() internal interface
Content-Disposition: inline; filename=pnp-add-pnp_resource_type
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given a struct resource, this returns the type (IO, MEM, IRQ, DMA).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work8/drivers/pnp/base.h
===================================================================
--- work8.orig/drivers/pnp/base.h	2008-04-17 14:07:25.000000000 -0600
+++ work8/drivers/pnp/base.h	2008-04-17 14:07:37.000000000 -0600
@@ -18,6 +18,7 @@
 int pnp_check_dma(struct pnp_dev * dev, int idx);
 
 void pnp_init_resource(struct resource *res);
+int pnp_resource_type(struct resource *res);
 
 #define PNP_MAX_PORT		40
 #define PNP_MAX_MEM		24
Index: work8/drivers/pnp/resource.c
===================================================================
--- work8.orig/drivers/pnp/resource.c	2008-04-17 14:07:48.000000000 -0600
+++ work8/drivers/pnp/resource.c	2008-04-17 14:09:25.000000000 -0600
@@ -489,6 +489,12 @@
 #endif
 }
 
+int pnp_resource_type(struct resource *res)
+{
+	return res->flags & (IORESOURCE_IO  | IORESOURCE_MEM |
+			     IORESOURCE_IRQ | IORESOURCE_DMA);
+}
+
 struct resource *pnp_get_resource(struct pnp_dev *dev,
 				  unsigned int type, unsigned int num)
 {

-- 
