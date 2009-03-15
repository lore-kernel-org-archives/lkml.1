Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbZCOTOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbZCOTOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZCOTOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:14:43 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:43258 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZCOTOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:14:43 -0400
Date: Sun, 15 Mar 2009 20:14:37 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] pci: Use kzalloc() in pci_create_bus()
Message-ID: <Pine.LNX.4.64.0903152009400.2201@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
1. Untested ;-)
2. Probably none of the static analyzers noticed, because of the amount of
   code in between the kmalloc() and the memset()

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 55ec44a..fa0999f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1114,7 +1114,7 @@ struct pci_bus * pci_create_bus(struct device *parent,
 	if (!b)
 		return NULL;
 
-	dev = kmalloc(sizeof(*dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev){
 		kfree(b);
 		return NULL;
@@ -1133,7 +1133,6 @@ struct pci_bus * pci_create_bus(struct device *parent,
 	list_add_tail(&b->node, &pci_root_buses);
 	up_write(&pci_bus_sem);
 
-	memset(dev, 0, sizeof(*dev));
 	dev->parent = parent;
 	dev->release = pci_release_bus_bridge_dev;
 	dev_set_name(dev, "pci%04x:%02x", pci_domain_nr(b), bus);

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
