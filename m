Return-Path: <linux-kernel-owner+w=401wt.eu-S932788AbYDYSvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbYDYSvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764803AbYDYSkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:40:25 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:9754 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764567AbYDYSkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:40:08 -0400
Message-Id: <20080425183929.810950397@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:35 -0600
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
Subject: [patch 28/54] PNP: remove pnp_mem_flags() as an lvalue
Content-Disposition: inline; filename=pnp-remove-accessor-lvalues
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A future change will change pnp_mem_flags() from a "#define that
simplifies to an lvalue" to "an inline function that returns the
flags value."

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/quirks.c
===================================================================
--- work10.orig/drivers/pnp/quirks.c	2008-04-25 11:12:16.000000000 -0600
+++ work10/drivers/pnp/quirks.c	2008-04-25 11:15:01.000000000 -0600
@@ -114,6 +114,7 @@
 static void quirk_system_pci_resources(struct pnp_dev *dev)
 {
 	struct pci_dev *pdev = NULL;
+	struct resource *res;
 	resource_size_t pnp_start, pnp_end, pci_start, pci_end;
 	int i, j;
 
@@ -173,7 +174,8 @@
 					pci_name(pdev), i,
 					(unsigned long long) pci_start,
 					(unsigned long long) pci_end);
-				pnp_mem_flags(dev, j) = 0;
+				res = pnp_get_resource(dev, IORESOURCE_MEM, j);
+				res->flags = 0;
 			}
 		}
 	}

-- 
