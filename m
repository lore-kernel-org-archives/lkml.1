Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYIPXPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYIPXPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 19:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYIPXOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 19:14:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:39969 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYIPXOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 19:14:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NSMhBZxTdlpfkweVTlDJkqfp7e3IpzG/X823GNXk/Zb+oBLWB/nOH8L5YRsnJO7Pbw
         1PlrRWd/Eyi9B7dXwsJTWfOiZm+ASdvSHDnMlh7tVe3eu8QrTUPVGpO6EStg7u5DqZyO
         7yeS/zkmhhhWc/H99A8w7mREB99mUaZMoAYmw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/5] pci: using pci_printk v2
Date: Tue, 16 Sep 2008 16:13:56 -0700
Message-Id: <1221606838-30246-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221606838-30246-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221606838-30246-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: use printk(KERN_DEBUG KERN_PCI ...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/pci/probe.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -304,7 +304,7 @@ static int __pci_read_base(struct pci_de
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
-			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
+			printk(KERN_DEBUG KERN_PCI "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
 				 pci_name(dev), pos, res->start, res->end);
 		}
 	} else {
@@ -315,7 +315,7 @@ static int __pci_read_base(struct pci_de
 
 		res->start = l;
 		res->end = l + sz;
-		printk(KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
+		printk(KERN_DEBUG KERN_PCI "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
 			 pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
 			 res->start, res->end);
 	}
@@ -388,7 +388,7 @@ void __devinit pci_read_bridge_bases(str
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
+		printk(KERN_DEBUG KERN_PCI "PCI: bridge %s io port: [%llx, %llx]\n",
 				 pci_name(dev), res->start, res->end);
 	}
 
@@ -401,7 +401,7 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
+		printk(KERN_DEBUG KERN_PCI "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
 				 pci_name(dev), res->start, res->end);
 	}
 
@@ -438,7 +438,7 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
+		printk(KERN_DEBUG KERN_PCI "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
 				 pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",
 				 res->start, res->end);
 	}
