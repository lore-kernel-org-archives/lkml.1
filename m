Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbXFLXDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbXFLXDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbXFLXDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:03:13 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33081 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754042AbXFLXDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:03:08 -0400
Date: Wed, 13 Jun 2007 01:03:20 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Peer Chen <pchen@nvidia.com>,
       Kuan Luo <kluo@nvidia.com>, jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [-mm patch] drivers/ata/sata_nv.c: make 3 functions static
Message-ID: <20070612230320.GC3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes 3 needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/ata/sata_nv.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.22-rc4-mm2/drivers/ata/sata_nv.c.old	2007-06-13 00:02:18.000000000 +0200
+++ linux-2.6.22-rc4-mm2/drivers/ata/sata_nv.c	2007-06-13 00:03:12.000000000 +0200
@@ -314,7 +314,7 @@
 static int nv_ncqintr_dmasetupfis(struct ata_port *ap);
 static void ncq_clear_singlefis(struct ata_port *ap, u32 val);
 static u32 ncq_ownfisintr_value (struct ata_port *ap);
-void ncq_hotplug(struct ata_port *ap, u32 fis);
+static void ncq_hotplug(struct ata_port *ap, u32 fis);
 static irqreturn_t nv_mcp55_interrupt(int irq, void *dev_instance);
 static int ncq_interrupt(struct ata_port *ap, u32 fis);
 static int nv_scsi_queuecmd(struct scsi_cmnd *cmd,
@@ -1931,7 +1931,7 @@
 	ncq_clear(ap);
 }
 
-int nv_std_prereset(struct ata_port *ap, unsigned long deadline)
+static int nv_std_prereset(struct ata_port *ap, unsigned long deadline)
 {
 	struct ata_eh_context *ehc = &ap->eh_context;
 
@@ -2265,7 +2265,7 @@
 	return 0;
 }
 
-u32 ncq_valid_dhfisflag(struct nv_port_priv *pp)
+static u32 ncq_valid_dhfisflag(struct nv_port_priv *pp)
 {
 	u32 valid = (pp->dhfis_flags == pp->qc_active);
 
@@ -2332,7 +2332,7 @@
 #endif
 
 
-void ncq_hotplug(struct ata_port *ap, u32 fis)
+static void ncq_hotplug(struct ata_port *ap, u32 fis)
 {
 	u32 serror;
 	struct ata_eh_info *ehi = &ap->eh_info;

