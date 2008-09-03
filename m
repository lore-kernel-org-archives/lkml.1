Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYICHUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYICHUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 03:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYICHSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 03:18:20 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:53213 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbYICHSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 03:18:13 -0400
Message-Id: <20080903071743.256779818@mail.of.borg>
References: <20080903071542.615137611@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 09:15:50 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 8/8] m68k: <asm/pci.h> needs <asm-generic/pci-dma-compat.h>
Content-Disposition: inline; filename=m68k-asm-pci-h-needs-asm-generic-pci-dma-compat.h.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

Several multi-bus subsystems:

| include/linux/ssb/ssb.h: In function 'ssb_dma_mapping_error':
| include/linux/ssb/ssb.h:430: error: implicit declaration of function 'pci_dma_mapping_error'
| include/linux/ssb/ssb.h: In function 'ssb_dma_map_single':
| include/linux/ssb/ssb.h:444: error: implicit declaration of function 'pci_map_single'
| include/linux/ssb/ssb.h: In function 'ssb_dma_unmap_single':
| include/linux/ssb/ssb.h:458: error: implicit declaration of function 'pci_unmap_single'
| include/linux/ssb/ssb.h: In function 'ssb_dma_sync_single_for_cpu':
| include/linux/ssb/ssb.h:475: error: implicit declaration of function 'pci_dma_sync_single_for_cpu'
| include/linux/ssb/ssb.h: In function 'ssb_dma_sync_single_for_device':
| include/linux/ssb/ssb.h:493: error: implicit declaration of function 'pci_dma_sync_single_for_device'

or legacy drivers:

| drivers/net/hp100.c: In function 'pdl_map_data':
| drivers/net/hp100.c:291: error: implicit declaration of function 'pci_map_single'
| drivers/net/hp100.c: In function 'hp100_probe1':
| drivers/net/hp100.c:707: error: implicit declaration of function 'pci_alloc_consistent'
| drivers/net/hp100.c:782: error: implicit declaration of function 'pci_free_consistent'
| drivers/net/hp100.c: In function 'hp100_clean_txring':
| drivers/net/hp100.c:1614: error: implicit declaration of function 'pci_unmap_single'

and

| drivers/scsi/aic7xxx_old.c: In function 'aic7xxx_allocate_scb':
| drivers/scsi/aic7xxx_old.c:2573: error: implicit declaration of function 'pci_alloc_consistent'
| drivers/scsi/aic7xxx_old.c: In function 'aic7xxx_done':
| drivers/scsi/aic7xxx_old.c:2697: error: implicit declaration of function 'pci_unmap_single'
| drivers/scsi/aic7xxx_old.c: In function 'aic7xxx_handle_seqint':
| drivers/scsi/aic7xxx_old.c:4275: error: implicit declaration of function 'pci_map_single'
| drivers/scsi/aic7xxx_old.c: In function 'aic7xxx_free':
| drivers/scsi/aic7xxx_old.c:8460: error: implicit declaration of function 'pci_free_consistent'

rely on PCI DMA operations to be always available.

Add #include <asm-generic/pci-dma-compat.h> to <asm/pci.h> to make them happy.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-m68k/pci.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-m68k/pci.h
+++ b/include/asm-m68k/pci.h
@@ -8,6 +8,7 @@
  */
 
 #include <asm/scatterlist.h>
+#include <asm-generic/pci-dma-compat.h>
 
 struct pci_ops;
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

