Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbYD2VuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbYD2VuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYD2Vt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:49:58 -0400
Received: from havoc.gtf.org ([69.61.125.42]:44118 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbYD2Vt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:49:57 -0400
Date: Tue, 29 Apr 2008 17:49:55 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] pata_atiixp fix PIO timing misprogramming
Message-ID: <20080429214955.GA25164@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit d7b5a23fc6e85456ed00a997ff2d925fb3f0dc52
Author: Jeff Garzik <jeff@garzik.org>
Date:   Tue Apr 29 17:39:45 2008 -0400

    [libata] pata_atiixp: fix PIO timing data misprogramming
    
    Use correct variable, achieve desired result...
    
    Spotted by LKML/linux-ide poster whose name I lost (apologies!)
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/ata/pata_atiixp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

d7b5a23fc6e85456ed00a997ff2d925fb3f0dc52
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 78738fb..d7de7ba 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -88,8 +88,8 @@ static void atiixp_set_pio_timing(struct ata_port *ap, struct ata_device *adev,
 	pci_write_config_word(pdev, ATIIXP_IDE_PIO_MODE, pio_mode_data);
 
 	pci_read_config_word(pdev, ATIIXP_IDE_PIO_TIMING, &pio_timing_data);
-	pio_mode_data &= ~(0xFF << timing_shift);
-	pio_mode_data |= (pio_timings[pio] << timing_shift);
+	pio_timing_data &= ~(0xFF << timing_shift);
+	pio_timing_data |= (pio_timings[pio] << timing_shift);
 	pci_write_config_word(pdev, ATIIXP_IDE_PIO_TIMING, pio_timing_data);
 }
 
