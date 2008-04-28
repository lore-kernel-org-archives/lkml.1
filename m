Return-Path: <linux-kernel-owner+w=401wt.eu-S968039AbYD1XCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968039AbYD1XCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966906AbYD1Wie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:38:34 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:27241 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966691AbYD1Wgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:54 -0400
Message-Id: <20080428223622.219467301@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:15 -0600
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
Subject: [patch 28/55] PNP: remove pnp_mem_flags() as an lvalue
Content-Disposition: inline; filename=pnp-remove-accessor-lvalues
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A future change will change pnp_mem_flags() from a "#define that
simplifies to an lvalue" to "an inline function that returns the
flags value."

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/quirks.c
===================================================================
--- work10.orig/drivers/pnp/quirks.c	2008-04-28 16:01:11.000000000 -0600
+++ work10/drivers/pnp/quirks.c	2008-04-28 16:09:27.000000000 -0600
@@ -117,6 +117,7 @@
 static void quirk_system_pci_resources(struct pnp_dev *dev)
 {
 	struct pci_dev *pdev = NULL;
+	struct resource *res;
 	resource_size_t pnp_start, pnp_end, pci_start, pci_end;
 	int i, j;
 
@@ -176,7 +177,8 @@
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
