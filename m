Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbYBQM3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbYBQM3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbYBQMXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:20 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55084 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbYBQMW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:58 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Gilbert Wu <gilbert_wu@adaptec.com>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH 16/27] scsi: fix section mismatch in aic94xx
Date: Sun, 17 Feb 2008 13:22:53 +0100
Message-Id: <1203250984-11285-16-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: vmlinux.o(.data+0x17aa88): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9410_setup()
WARNING: vmlinux.o(.data+0x17aa98): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9410_setup()
WARNING: vmlinux.o(.data+0x17aaa8): Section mismatch in reference from the variable asd_pcidev_data to the function .devinit.text:asd_aic9405_setup()

asd_pcidev_data is only used by __devinit asd_pci_probe.
So mark is const and annotate it __devinitconst to fix
the warnings.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gilbert Wu <gilbert_wu@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 5d761eb..720812f 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -531,10 +531,10 @@ static void asd_remove_dev_attrs(struct asd_ha_struct *asd_ha)
 /* The first entry, 0, is used for dynamic ids, the rest for devices
  * we know about.
  */
-static struct asd_pcidev_struct {
+static const struct asd_pcidev_struct {
 	const char * name;
 	int (*setup)(struct asd_ha_struct *asd_ha);
-} asd_pcidev_data[] = {
+} asd_pcidev_data[] __devinitconst = {
 	/* Id 0 is used for dynamic ids. */
 	{ .name  = "Adaptec AIC-94xx SAS/SATA Host Adapter",
 	  .setup = asd_aic9410_setup
-- 
1.5.4.rc3.14.g44397

