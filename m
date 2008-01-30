Return-Path: <linux-kernel-owner+w=401wt.eu-S1764540AbYA3UNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764540AbYA3UNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYA3UC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:02:59 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40753 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761820AbYA3UCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:02:46 -0500
Date: Wed, 30 Jan 2008 22:03:20 +0200
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ide/ppc/pmac.c section fixes
Message-ID: <20080130200320.GI29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x3b641c): Section mismatch in reference from the function .pmac_ide_setup_device() to the function .init.text:.pmac_ide_setup_dma()
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ide/ppc/pmac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

400d1da2f5d6ea50d75a075ed230c244d1631f4a 
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 736d12c..7aa160e 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1011,7 +1011,7 @@ pmac_ide_do_resume(ide_hwif_t *hwif)
  * (it is kept in 2.4). This introduce an interface numbering change on some
  * rare machines unfortunately, but it's better this way.
  */
-static int
+static int __devinit
 pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif, hw_regs_t *hw)
 {
 	struct device_node *np = pmif->node;
@@ -1726,7 +1726,7 @@ pmac_ide_dma_lost_irq (ide_drive_t *drive)
  * Allocate the data structures needed for using DMA with an interface
  * and fill the proper list of functions pointers
  */
-static void __init 
+static void __devinit 
 pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 {
 	/* We won't need pci_dev if we switch to generic consistent

