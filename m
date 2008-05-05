Return-Path: <linux-kernel-owner+w=401wt.eu-S1763667AbYEEWna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763667AbYEEWna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762098AbYEEWkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:40:15 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:16653 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760818AbYEEWkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:40:04 -0400
Message-Id: <20080505223959.587664764@ldl.fc.hp.com>
References: <20080505223630.682082986@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 05 May 2008 16:36:34 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 4/8] PNP: add pnp_resource_type() internal interface
Content-Disposition: inline; filename=pnp-add-pnp_resource_type
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given a struct resource, this returns the type (IO, MEM, IRQ, DMA).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-05-02 14:23:13.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-05-05 09:39:03.000000000 -0600
@@ -45,6 +45,7 @@ int pnp_check_dma(struct pnp_dev *dev, s
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
 
 void pnp_init_resource(struct resource *res);
+int pnp_resource_type(struct resource *res);
 
 struct pnp_resource *pnp_get_pnp_resource(struct pnp_dev *dev,
 					  unsigned int type, unsigned int num);
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-05-02 14:23:13.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-05-05 09:38:57.000000000 -0600
@@ -499,6 +499,12 @@ int pnp_check_dma(struct pnp_dev *dev, s
 #endif
 }
 
+int pnp_resource_type(struct resource *res)
+{
+	return res->flags & (IORESOURCE_IO  | IORESOURCE_MEM |
+			     IORESOURCE_IRQ | IORESOURCE_DMA);
+}
+
 struct pnp_resource *pnp_get_pnp_resource(struct pnp_dev *dev,
 					  unsigned int type, unsigned int num)
 {

-- 
