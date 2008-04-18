Return-Path: <linux-kernel-owner+w=401wt.eu-S1762652AbYDRU7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762652AbYDRU7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 16:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761174AbYDRUwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:52:21 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:29693 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760377AbYDRUvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:51:55 -0400
Message-Id: <20080418205052.110653996@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:19 -0600
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
Subject: [patch 24/53] PNP: remove pnp_mem_flags() as an lvalue
Content-Disposition: inline; filename=pnp-remove-accessor-lvalues
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A future change will change pnp_mem_flags() from a "#define that
simplifies to an lvalue" to "an inline function that returns the
flags value."

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/quirks.c
===================================================================
--- work7.orig/drivers/pnp/quirks.c	2008-04-02 13:08:09.000000000 -0600
+++ work7/drivers/pnp/quirks.c	2008-04-02 13:10:34.000000000 -0600
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
