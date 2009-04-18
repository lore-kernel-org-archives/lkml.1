Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbZDRIqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbZDRIqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 04:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZDRIql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 04:46:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:39367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbZDRIqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 04:46:40 -0400
Message-ID: <49E99355.6090609@kernel.org>
Date: Sat, 18 Apr 2009 01:46:13 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] pci: don't printout if the bus res size is 0
References: <49E992C2.4010707@kernel.org>
In-Reply-To: <49E992C2.4010707@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


also print out if it is prefetechable mmio

[Impact: cleanup]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -558,11 +558,13 @@ static void pci_bus_dump_res(struct pci_
 
         for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
                 struct resource *res = bus->resource[i];
-                if (!res)
+                if (!res || !res->end)
                         continue;
 
 		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %s %pR\n", i,
-			   (res->flags & IORESOURCE_IO) ? "io: " : "mem:", res);
+			   (res->flags & IORESOURCE_IO) ? "io: " :
+			    ((res->flags & IORESOURCE_PREFETCH)? "pref mem":"mem:"),
+			   res);
         }
 }
 
