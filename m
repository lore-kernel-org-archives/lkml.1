Return-Path: <linux-kernel-owner+w=401wt.eu-S1760694AbYFQXBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbYFQXBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759635AbYFQW7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:59:42 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:15125 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439AbYFQW7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:59:36 -0400
Message-Id: <20080617225908.383391287@ldl.fc.hp.com>
References: <20080617225823.045233728@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 17 Jun 2008 16:58:27 -0600
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
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Subject: [patch 04/28] PNP: add pnp_resource_type_name() helper function
Content-Disposition: inline; filename=pnp-add-resource-type-name
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a "pnp_resource_type_name(struct resource *)" that
returns the string resource type.  This will be used by the sysfs
"show resources" function and the debug resource dump function.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-05-15 15:23:27.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-05-15 15:23:29.000000000 -0600
@@ -43,6 +43,7 @@ int pnp_check_mem(struct pnp_dev *dev, s
 int pnp_check_irq(struct pnp_dev *dev, struct resource *res);
 int pnp_check_dma(struct pnp_dev *dev, struct resource *res);
 
+char *pnp_resource_type_name(struct resource *res);
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
 
 void pnp_init_resource(struct resource *res);
Index: work10/drivers/pnp/support.c
===================================================================
--- work10.orig/drivers/pnp/support.c	2008-05-15 15:23:23.000000000 -0600
+++ work10/drivers/pnp/support.c	2008-05-15 15:23:29.000000000 -0600
@@ -52,6 +52,21 @@ void pnp_eisa_id_to_string(u32 id, char 
 	str[7] = '\0';
 }
 
+char *pnp_resource_type_name(struct resource *res)
+{
+	switch (pnp_resource_type(res)) {
+	case IORESOURCE_IO:
+		return "io";
+	case IORESOURCE_MEM:
+		return "mem";
+	case IORESOURCE_IRQ:
+		return "irq";
+	case IORESOURCE_DMA:
+		return "dma";
+	}
+	return NULL;
+}
+
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 {
 #ifdef DEBUG

-- 
