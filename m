Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYHVSrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYHVSrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYHVSrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:47:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:44879 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751072AbYHVSrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:47:04 -0400
X-Authenticated: #36809985
X-Provags-ID: V01U2FsdGVkX19se18hiCVsyzMyCHPL4YKSnBhtPjpQ47X7Xegh+E
	1GPSlt2aYSLbGk
Subject: [PATCH] pci: Fix printk warnings in probe.c
From: Johann Felix Soden <johfel@gmx.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 22 Aug 2008 20:46:59 +0200
Message-Id: <1219430819.7010.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>

Fix printk format warnings:
drivers/pci/probe.c: In function 'pci_read_bridge_bases':
drivers/pci/probe.c:386: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
drivers/pci/probe.c:386: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:398: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
drivers/pci/probe.c:398: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:434: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:434: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'resource_size_t'

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
---
 drivers/pci/probe.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cce2f4c..0ad9367 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -383,7 +383,9 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
+		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n",
+			pci_name(dev), (unsigned long long) res->start,
+			(unsigned long long) res->end);
 	}
 
 	res = child->resource[1];
@@ -395,7 +397,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
+		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev),
+			(unsigned long long) res->start, (unsigned long long) res->end);
 	}
 
 	res = child->resource[2];
@@ -431,7 +434,9 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n", pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",res->start, res->end);
+		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
+			pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
+			(unsigned long long) res->start, (unsigned long long) res->end);
 	}
 }
 
-- 
1.5.6.3

