Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbYIQBP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbYIQBP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 21:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYIQBOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 21:14:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:52946 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbYIQBOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 21:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uFR68oPjnukncSjBrH2QNS3t+V+jIRadcuvQK01cmnxbuqNbgDnOCKS/2QbKsZCctj
         dp0dNCGZE1zlJNnWSxgu8nFwJwrg+pA5V2qD/4ZO7An+HFh2kOgv5UY+SDnJvML5A1vZ
         igq+ra+AStTNy4Ej87Ea6rUCwI6cIyMnk9A2U=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/5] pci: using pci_printk v3
Date: Tue, 16 Sep 2008 18:14:11 -0700
Message-Id: <1221614053-28804-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221614053-28804-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221614053-28804-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: use printk(KERN_DEBUG KERN_PCI ...
v3: fix checkpatch error and warning

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/pci/probe.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -304,7 +304,8 @@ static int __pci_read_base(struct pci_de
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
-			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
+			printk(KERN_DEBUG KERN_PCI
+				 "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
 				 pci_name(dev), pos, res->start, res->end);
 		}
 	} else {
@@ -315,9 +316,10 @@ static int __pci_read_base(struct pci_de
 
 		res->start = l;
 		res->end = l + sz;
-		printk(KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
-			 pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
-			 res->start, res->end);
+		printk(KERN_DEBUG KERN_PCI "PCI: %s reg %x %s: [%llx, %llx]\n",
+			pci_name(dev), pos,
+			(res->flags & IORESOURCE_IO) ? "io port" : "32bit mmio",
+			res->start, res->end);
 	}
 
  out:
@@ -388,8 +390,9 @@ void __devinit pci_read_bridge_bases(str
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
-				 pci_name(dev), res->start, res->end);
+		printk(KERN_DEBUG KERN_PCI
+			 "PCI: bridge %s io port: [%llx, %llx]\n",
+			 pci_name(dev), res->start, res->end);
 	}
 
 	res = child->resource[1];
@@ -401,8 +404,9 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
-				 pci_name(dev), res->start, res->end);
+		printk(KERN_DEBUG KERN_PCI
+			 "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
+			 pci_name(dev), res->start, res->end);
 	}
 
 	res = child->resource[2];
@@ -438,9 +442,11 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
-				 pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",
-				 res->start, res->end);
+		printk(KERN_DEBUG KERN_PCI
+			 "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
+			 pci_name(dev),
+			 (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
+			 res->start, res->end);
 	}
 }
 
