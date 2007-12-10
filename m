Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbXLJGck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbXLJGck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 01:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXLJGcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 01:32:18 -0500
Received: from ozlabs.org ([203.10.76.45]:50092 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbXLJGcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 01:32:18 -0500
To: Greg Kroah-Hartman <greg@kroah.com>
CC: linux-pci@atrey.karlin.mff.cuni.cz, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 10 Dec 2007 17:32:16 +1100
Subject: [PATCH 2/2] pci: Fix warning in setup-res.c on 32-bit platforms with 64-bit resources
Message-Id: <20071210063217.292B5DDE27@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds appropriate casts to avoid a warning and print the correct
values in pr_debug.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 drivers/pci/setup-res.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-work/drivers/pci/setup-res.c
===================================================================
--- linux-work.orig/drivers/pci/setup-res.c	2007-12-10 17:17:32.000000000 +1100
+++ linux-work/drivers/pci/setup-res.c	2007-12-10 17:17:54.000000000 +1100
@@ -51,10 +51,12 @@ pci_update_resource(struct pci_dev *dev,
 
 	pcibios_resource_to_bus(dev, &region, res);
 
-	pr_debug("  got res [%llx:%llx] bus [%lx:%lx] flags %lx for "
+	pr_debug("  got res [%llx:%llx] bus [%llx:%llx] flags %lx for "
 		 "BAR %d of %s\n", (unsigned long long)res->start,
 		 (unsigned long long)res->end,
-		 region.start, region.end, res->flags, resno, pci_name(dev));
+		 (unsigned long long)region.start,
+		 (unsigned long long)region.end,
+		 (unsigned long)res->flags, resno, pci_name(dev));
 
 	new = region.start | (res->flags & PCI_REGION_FLAG_MASK);
 	if (res->flags & IORESOURCE_IO)
