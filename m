Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbYBNRgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbYBNRgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbYBNRgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:36:38 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:34837 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbYBNRgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:36:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xLuKx/otS3ZPUd7cXJ81mn5ga2IM1KvJUz0dsqiszBvyL6FHQm8vPYLoYIrN1BDITaNp3r+DnaOwV5qdZzcHnPzAK1i99gyQaxNn3ys3v5b/VyBWg5kPfywZ9Lu+n19E3yL23hYFDn2wUEUObf0X7duUn9m+kD87G9qrCEkJVCQ=
Subject: [PATCH 11/11v2] ata: fix sparse warnings in pata_legacy.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <20080214120206.1a52f77d@core>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
	 <1202966072.2748.27.camel@brick>  <20080214120206.1a52f77d@core>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 09:36:32 -0800
Message-Id: <1203010593.2748.43.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ld_qdi and ld_winbond to avoid shadowing static int
variables qdi and winbond.  The ld_ prefix refers to
legacy_data.

drivers/ata/pata_legacy.c:777:21: warning: symbol 'qdi' shadows an earlier one
drivers/ata/pata_legacy.c:128:12: originally declared here
drivers/ata/pata_legacy.c:811:21: warning: symbol 'qdi' shadows an earlier one
drivers/ata/pata_legacy.c:128:12: originally declared here
drivers/ata/pata_legacy.c:848:21: warning: symbol 'qdi' shadows an earlier one
drivers/ata/pata_legacy.c:128:12: originally declared here
drivers/ata/pata_legacy.c:882:21: warning: symbol 'qdi' shadows an earlier one
drivers/ata/pata_legacy.c:128:12: originally declared here
drivers/ata/pata_legacy.c:1040:21: warning: symbol 'winbond' shadows an earlier one
drivers/ata/pata_legacy.c:129:12: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Alan Cox's suggestion of using a ld_ prefix incorporated.

 drivers/ata/pata_legacy.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 6c59969..68077f2 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -774,14 +774,14 @@ static struct ata_port_operations opti82c46x_port_ops = {
 static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct ata_timing t;
-	struct legacy_data *qdi = ap->host->private_data;
+	struct legacy_data *ld_qdi = ap->host->private_data;
 	int active, recovery;
 	u8 timing;
 
 	/* Get the timing data in cycles */
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	if (qdi->fast) {
+	if (ld_qdi->fast) {
 		active = 8 - FIT(t.active, 1, 8);
 		recovery = 18 - FIT(t.recover, 3, 18);
 	} else {
@@ -790,9 +790,9 @@ static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	}
 	timing = (recovery << 4) | active | 0x08;
 
-	qdi->clock[adev->devno] = timing;
+	ld_qdi->clock[adev->devno] = timing;
 
-	outb(timing, qdi->timing);
+	outb(timing, ld_qdi->timing);
 }
 
 /**
@@ -808,14 +808,14 @@ static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
 static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct ata_timing t;
-	struct legacy_data *qdi = ap->host->private_data;
+	struct legacy_data *ld_qdi = ap->host->private_data;
 	int active, recovery;
 	u8 timing;
 
 	/* Get the timing data in cycles */
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	if (qdi->fast) {
+	if (ld_qdi->fast) {
 		active = 8 - FIT(t.active, 1, 8);
 		recovery = 18 - FIT(t.recover, 3, 18);
 	} else {
@@ -824,12 +824,12 @@ static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	}
 	timing = (recovery << 4) | active | 0x08;
 
-	qdi->clock[adev->devno] = timing;
+	ld_qdi->clock[adev->devno] = timing;
 
-	outb(timing, qdi->timing + 2 * ap->port_no);
+	outb(timing, ld_qdi->timing + 2 * ap->port_no);
 	/* Clear the FIFO */
 	if (adev->class != ATA_DEV_ATA)
-		outb(0x5F, qdi->timing + 3);
+		outb(0x5F, ld_qdi->timing + 3);
 }
 
 /**
@@ -845,14 +845,14 @@ static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct ata_timing t;
-	struct legacy_data *qdi = ap->host->private_data;
+	struct legacy_data *ld_qdi = ap->host->private_data;
 	int active, recovery;
 	u8 timing;
 
 	/* Get the timing data in cycles */
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	if (qdi->fast) {
+	if (ld_qdi->fast) {
 		active = 8 - FIT(t.active, 1, 8);
 		recovery = 18 - FIT(t.recover, 3, 18);
 	} else {
@@ -860,11 +860,11 @@ static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		recovery = 15 - FIT(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
-	qdi->clock[adev->devno] = timing;
-	outb(timing, qdi->timing + 2 * adev->devno);
+	ld_qdi->clock[adev->devno] = timing;
+	outb(timing, ld_qdi->timing + 2 * adev->devno);
 	/* Clear the FIFO */
 	if (adev->class != ATA_DEV_ATA)
-		outb(0x5F, qdi->timing + 3);
+		outb(0x5F, ld_qdi->timing + 3);
 }
 
 /**
@@ -879,12 +879,12 @@ static unsigned int qdi_qc_issue_prot(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct ata_device *adev = qc->dev;
-	struct legacy_data *qdi = ap->host->private_data;
+	struct legacy_data *ld_qdi = ap->host->private_data;
 
-	if (qdi->clock[adev->devno] != qdi->last) {
+	if (ld_qdi->clock[adev->devno] != ld_qdi->last) {
 		if (adev->pio_mode) {
-			qdi->last = qdi->clock[adev->devno];
-			outb(qdi->clock[adev->devno], qdi->timing +
+			ld_qdi->last = ld_qdi->clock[adev->devno];
+			outb(ld_qdi->clock[adev->devno], ld_qdi->timing +
 							2 * ap->port_no);
 		}
 	}
@@ -1037,12 +1037,12 @@ static u8 winbond_readcfg(unsigned long port, u8 reg)
 static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct ata_timing t;
-	struct legacy_data *winbond = ap->host->private_data;
+	struct legacy_data *ld_winbond = ap->host->private_data;
 	int active, recovery;
 	u8 reg;
 	int timing = 0x88 + (ap->port_no * 4) + (adev->devno * 2);
 
-	reg = winbond_readcfg(winbond->timing, 0x81);
+	reg = winbond_readcfg(ld_winbond->timing, 0x81);
 
 	/* Get the timing data in cycles */
 	if (reg & 0x40)		/* Fast VLB bus, assume 50MHz */
@@ -1053,7 +1053,7 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	active = (FIT(t.active, 3, 17) - 1) & 0x0F;
 	recovery = (FIT(t.recover, 1, 15) + 1) & 0x0F;
 	timing = (active << 4) | recovery;
-	winbond_writecfg(winbond->timing, timing, reg);
+	winbond_writecfg(ld_winbond->timing, timing, reg);
 
 	/* Load the setup timing */
 
@@ -1063,7 +1063,7 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	if (!ata_pio_need_iordy(adev))
 		reg |= 0x02;	/* IORDY off */
 	reg |= (FIT(t.setup, 0, 3) << 6);
-	winbond_writecfg(winbond->timing, timing + 1, reg);
+	winbond_writecfg(ld_winbond->timing, timing + 1, reg);
 }
 
 static int winbond_port(struct platform_device *dev,
-- 
1.5.4.1.1278.gc75be



