Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbZHGKyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbZHGKyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZHGKy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:54:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:49425 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbZHGKy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:54:28 -0400
Message-ID: <4A7C07AE.4040200@kernel.org>
Date: Fri, 07 Aug 2009 03:53:34 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH] pci: print out pref if mmio is prefetchable
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


already print it out for pci bridge, also print it out for pci device

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/probe.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -235,7 +235,10 @@ int __pci_read_base(struct pci_dev *dev,
 			res->start = l64;
 			res->end = l64 + sz64;
 			dev_printk(KERN_DEBUG, &dev->dev,
-				"reg %x 64bit mmio: %pR\n", pos, res);
+				"reg %x %s: %pR\n", pos,
+				 (res->flags & IORESOURCE_PREFETCH) ?
+					"64bit mmio pref" : "64bit mmio",
+				 res);
 		}
 
 		res->flags |= IORESOURCE_MEM_64;
@@ -249,7 +252,9 @@ int __pci_read_base(struct pci_dev *dev,
 		res->end = l + sz;
 
 		dev_printk(KERN_DEBUG, &dev->dev, "reg %x %s: %pR\n", pos,
-			(res->flags & IORESOURCE_IO) ? "io port" : "32bit mmio",
+			(res->flags & IORESOURCE_IO) ? "io port" :
+			 ((res->flags & IORESOURCE_PREFETCH) ?
+				 "32bit mmio pref" : "32bit mmio"),
 			res);
 	}
 
