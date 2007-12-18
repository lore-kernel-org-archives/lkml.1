Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbXLRWsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbXLRWsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbXLRWrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:47:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55075 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbXLRWru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:47:50 -0500
Date: Tue, 18 Dec 2007 14:46:36 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.12
Message-ID: <20071218224635.GB12696@kroah.com>
References: <20071218224559.GA12696@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218224559.GA12696@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index ada10d5..96c3f02 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 23
-EXTRAVERSION = .11
+EXTRAVERSION = .12
 NAME = Arr Matey! A Hairy Bilge Rat!
 
 # *DOCUMENTATION*
diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 5abf5ea..0e3b8d0 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -82,11 +82,9 @@ static void pnpacpi_parse_allocated_irqresource(struct pnp_resource_table *res,
 	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) &&
 	       i < PNP_MAX_IRQ)
 		i++;
-	if (i >= PNP_MAX_IRQ) {
-		printk(KERN_ERR "pnpacpi: exceeded the max number of IRQ "
-				"resources: %d \n", PNP_MAX_IRQ);
+	if (i >= PNP_MAX_IRQ)
 		return;
-	}
+
 	res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
 	res->irq_resource[i].flags |= irq_flags(triggering, polarity);
 	irq = acpi_register_gsi(gsi, triggering, polarity);
@@ -165,9 +163,6 @@ static void pnpacpi_parse_allocated_dmaresource(struct pnp_resource_table *res,
 		}
 		res->dma_resource[i].start = dma;
 		res->dma_resource[i].end = dma;
-	} else {
-		printk(KERN_ERR "pnpacpi: exceeded the max number of DMA "
-				"resources: %d \n", PNP_MAX_DMA);
 	}
 }
 
@@ -189,9 +184,6 @@ static void pnpacpi_parse_allocated_ioresource(struct pnp_resource_table *res,
 		}
 		res->port_resource[i].start = io;
 		res->port_resource[i].end = io + len - 1;
-	} else {
-		printk(KERN_ERR "pnpacpi: exceeded the max number of IO "
-				"resources: %d \n", PNP_MAX_PORT);
 	}
 }
 
@@ -215,9 +207,6 @@ static void pnpacpi_parse_allocated_memresource(struct pnp_resource_table *res,
 
 		res->mem_resource[i].start = mem;
 		res->mem_resource[i].end = mem + len - 1;
-	} else {
-		printk(KERN_ERR "pnpacpi: exceeded the max number of mem "
-				"resources: %d\n", PNP_MAX_MEM);
 	}
 }
 
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 62decab..16b46aa 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -13,8 +13,8 @@
 #include <linux/errno.h>
 #include <linux/mod_devicetable.h>
 
-#define PNP_MAX_PORT		24
-#define PNP_MAX_MEM		12
+#define PNP_MAX_PORT		8
+#define PNP_MAX_MEM		4
 #define PNP_MAX_IRQ		2
 #define PNP_MAX_DMA		2
 #define PNP_NAME_LEN		50
