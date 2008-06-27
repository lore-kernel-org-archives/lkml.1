Return-Path: <linux-kernel-owner+w=401wt.eu-S1760455AbYF0Owt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbYF0Owt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbYF0Owf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:52:35 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11727 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbYF0Owd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:52:33 -0400
Message-Id: <20080627144753.399881942@ldl.fc.hp.com>
References: <20080627144538.743154341@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 08:45:41 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 3/6] PCI: print "bar", not "bar + 1" in pci_request_region()
Content-Disposition: inline; filename=pci-request-region-bar-fix
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the BAR number printed by pci_request_region() from "bar + 1" to "bar".

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work11/drivers/pci/pci.c
===================================================================
--- work11.orig/drivers/pci/pci.c	2008-06-27 08:27:29.000000000 -0600
+++ work11/drivers/pci/pci.c	2008-06-27 08:27:47.000000000 -0600
@@ -1116,7 +1116,7 @@ int pci_request_region(struct pci_dev *p
 
 err_out:
 	dev_warn(&pdev->dev, "BAR %d: can't reserve %s region [%#llx-%#llx]\n",
-		bar + 1, /* PCI BAR # */
+		bar, /* PCI BAR # */
 		pci_resource_flags(pdev, bar) & IORESOURCE_IO ? "I/O" : "mem",
 		(unsigned long long)pci_resource_start(pdev, bar),
 		(unsigned long long)pci_resource_end(pdev, bar));

-- 
