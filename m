Return-Path: <linux-kernel-owner+w=401wt.eu-S1764908AbYF0XAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764908AbYF0XAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761900AbYF0W6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:58:49 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:19405 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761515AbYF0W6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:58:44 -0400
Message-Id: <20080627225758.412956427@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:56:52 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 01/28] PNP: add detail to debug resource dump
Content-Disposition: inline; filename=pnp-better-resource-dump
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the debug resource dump, decode the flags and indicate when
a resource is disabled or has been automatically assigned.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/support.c
===================================================================
--- work10.orig/drivers/pnp/support.c	2008-05-02 11:18:50.000000000 -0600
+++ work10/drivers/pnp/support.c	2008-05-05 09:39:03.000000000 -0600
@@ -63,28 +63,46 @@ void dbg_pnp_show_resources(struct pnp_d
 	for (i = 0; i < PNP_MAX_IRQ; i++) {
 		res = pnp_get_resource(dev, IORESOURCE_IRQ, i);
 		if (res && !(res->flags & IORESOURCE_UNSET))
-			dev_dbg(&dev->dev, "  irq %lld flags %#lx\n",
-				(unsigned long long) res->start, res->flags);
+			dev_dbg(&dev->dev, "  irq %lld flags %#lx%s%s\n",
+				(unsigned long long) res->start, res->flags,
+				res->flags & IORESOURCE_DISABLED ?
+					" DISABLED" : "",
+				res->flags & IORESOURCE_AUTO ?
+					" AUTO" : "");
 	}
 	for (i = 0; i < PNP_MAX_DMA; i++) {
 		res = pnp_get_resource(dev, IORESOURCE_DMA, i);
 		if (res && !(res->flags & IORESOURCE_UNSET))
-			dev_dbg(&dev->dev, "  dma %lld flags %#lx\n",
-				(unsigned long long) res->start, res->flags);
+			dev_dbg(&dev->dev, "  dma %lld flags %#lx%s%s\n",
+				(unsigned long long) res->start, res->flags,
+				res->flags & IORESOURCE_DISABLED ?
+					" DISABLED" : "",
+				res->flags & IORESOURCE_AUTO ?
+					" AUTO" : "");
 	}
 	for (i = 0; i < PNP_MAX_PORT; i++) {
 		res = pnp_get_resource(dev, IORESOURCE_IO, i);
 		if (res && !(res->flags & IORESOURCE_UNSET))
-			dev_dbg(&dev->dev, "  io  %#llx-%#llx flags %#lx\n",
+			dev_dbg(&dev->dev, "  io  %#llx-%#llx flags %#lx"
+				"%s%s\n",
 				(unsigned long long) res->start,
-				(unsigned long long) res->end, res->flags);
+				(unsigned long long) res->end, res->flags,
+				res->flags & IORESOURCE_DISABLED ?
+					" DISABLED" : "",
+				res->flags & IORESOURCE_AUTO ?
+					" AUTO" : "");
 	}
 	for (i = 0; i < PNP_MAX_MEM; i++) {
 		res = pnp_get_resource(dev, IORESOURCE_MEM, i);
 		if (res && !(res->flags & IORESOURCE_UNSET))
-			dev_dbg(&dev->dev, "  mem %#llx-%#llx flags %#lx\n",
+			dev_dbg(&dev->dev, "  mem %#llx-%#llx flags %#lx"
+				"%s%s\n",
 				(unsigned long long) res->start,
-				(unsigned long long) res->end, res->flags);
+				(unsigned long long) res->end, res->flags,
+				res->flags & IORESOURCE_DISABLED ?
+					" DISABLED" : "",
+				res->flags & IORESOURCE_AUTO ?
+					" AUTO" : "");
 	}
 #endif
 }

-- 
