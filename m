Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbXGISwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbXGISwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760104AbXGISwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:52:21 -0400
Received: from havoc.gtf.org ([69.61.125.42]:52708 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760100AbXGISwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:52:19 -0400
Date: Mon, 9 Jul 2007 14:52:18 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] libata: sata_mv: print out additional chip info during probe
Message-ID: <20070709185218.GA22190@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit c1e4fe711a410a139095e6b3e3ce3f07f466063c
Author: Jeff Garzik <jeff@garzik.org>
Date:   Mon Jul 9 12:29:31 2007 -0400

    [libata] sata_mv: print out additional chip info during probe
    
    Indicate whether this is a Generation-I (50xx), Generation-II (60xx),
    or Generation-II-E (6042/7042) chip.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

c1e4fe711a410a139095e6b3e3ce3f07f466063c
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index d65ec23..3873b29 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2338,7 +2338,7 @@ static void mv_print_info(struct ata_host *host)
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	struct mv_host_priv *hpriv = host->private_data;
 	u8 rev_id, scc;
-	const char *scc_s;
+	const char *scc_s, *gen;
 
 	/* Use this to determine the HW stepping of the chip so we know
 	 * what errata to workaround
@@ -2351,11 +2351,20 @@ static void mv_print_info(struct ata_host *host)
 	else if (scc == 0x01)
 		scc_s = "RAID";
 	else
-		scc_s = "unknown";
+		scc_s = "?";
+
+	if (IS_GEN_I(hpriv))
+		gen = "I";
+	else if (IS_GEN_II(hpriv))
+		gen = "II";
+	else if (IS_GEN_IIE(hpriv))
+		gen = "IIE";
+	else
+		gen = "?";
 
 	dev_printk(KERN_INFO, &pdev->dev,
-	       "%u slots %u ports %s mode IRQ via %s\n",
-	       (unsigned)MV_MAX_Q_DEPTH, host->n_ports,
+	       "Gen-%s %u slots %u ports %s mode IRQ via %s\n",
+	       gen, (unsigned)MV_MAX_Q_DEPTH, host->n_ports,
 	       scc_s, (MV_HP_FLAG_MSI & hpriv->hp_flags) ? "MSI" : "INTx");
 }
 
