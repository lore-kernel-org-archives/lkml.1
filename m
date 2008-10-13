Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbYJMUL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbYJMUL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYJMUGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:06:15 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:43091 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYJMUFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:05:41 -0400
Message-Id: <20081013195918.623546548@mail.of.borg>
References: <20081013195846.674654386@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Mon, 13 Oct 2008 21:58:57 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 11/18] m68k: <asm/pci.h> needs <asm-generic/pci-dma-compat.h>
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

