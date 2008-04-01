Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbYDAMXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbYDAMXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYDAMX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:23:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48848 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYDAMX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:23:28 -0400
Date: Tue, 1 Apr 2008 14:24:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: agpgart: scary messages are fortunately obsolete
Message-ID: <20080401122403.GC12129@elf.ucw.cz>
References: <20080328112507.GA10774@elf.ucw.cz> <20080328113508.GP29105@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328113508.GP29105@one.firstfloor.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix obsolete printks in aperture-64. We used not to handle missing
agpgart, but we handle it okay now.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index faf3229..3939c6d 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -615,13 +615,13 @@ static __init int init_k8_gatt(struct ag
 
  nommu:
 	/* Should not happen anymore */
-	printk(KERN_ERR "PCI-DMA: More than 4GB of RAM and no IOMMU\n"
-	       KERN_ERR "PCI-DMA: 32bit PCI IO may malfunction.\n");
+	printk(KERN_WARNING "PCI-DMA: More than 4GB of RAM and no IOMMU\n"
+	       KERN_WARNING "falling back to iommu=soft.\n");
 	return -1;
 }
 
 extern int agp_amd64_init(void);
 
 static const struct dma_mapping_ops gart_dma_ops = {
 	.mapping_error			= NULL,
 	.map_single			= gart_map_single,
@@ -692,9 +690,9 @@ #endif
 	    !gart_iommu_aperture ||
 	    (no_agp && init_k8_gatt(&info) < 0)) {
 		if (end_pfn > MAX_DMA32_PFN) {
-			printk(KERN_ERR "WARNING more than 4GB of memory "
-					"but GART IOMMU not available.\n"
-			       KERN_ERR "WARNING 32bit PCI may malfunction.\n");
+			printk(KERN_WARNING "More than 4GB of memory "
+			       	          "but GART IOMMU not available.\n"
+			       KERN_WARNING "falling back to iommu=soft.\n");
 		}
 		return;
 	}

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
