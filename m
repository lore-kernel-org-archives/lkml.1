Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbYIPSC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbYIPSC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYIPSCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:02:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:25947 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbYIPSCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oPFO7/3GJtxAjeyxLLdRdgzP0G7p4fcVZj57V2/mKz7cTV2TDX0yarBBjXwJous5qv
         C/IBbDi0iX0ps4s341n2wbII8bLs8YdWCndWfAWh8DnmXFs33HIvtFBu1QJuutwsC1cs
         YvVzVhRI8dpJAbL0RhsQczEcfrqTYVKXlnwD8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/5] pci: using pci_printk
Date: Tue, 16 Sep 2008 11:01:23 -0700
Message-Id: <1221588085-30578-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221588085-30578-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221588085-30578-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
+			pci_printk(KERN_LOG_DEBUG, KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
 				 pci_name(dev), pos, res->start, res->end);
 		}
 	} else {
@@ -315,7 +315,7 @@ static int __pci_read_base(struct pci_de
 
 		res->start = l;
 		res->end = l + sz;
-		printk(KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
+		pci_printk(KERN_LOG_DEBUG, KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
 			 pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
 			 res->start, res->end);
 	}
@@ -388,7 +388,7 @@ void __devinit pci_read_bridge_bases(str
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
+		pci_printk(KERN_LOG_DEBUG, KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
 				 pci_name(dev), res->start, res->end);
 	}
 
@@ -401,7 +401,7 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
+		pci_printk(KERN_LOG_DEBUG, KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
 				 pci_name(dev), res->start, res->end);
 	}
 
@@ -438,7 +438,7 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
+		pci_printk(KERN_LOG_DEBUG, KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
 				 pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",
 				 res->start, res->end);
 	}
