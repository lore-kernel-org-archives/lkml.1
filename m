Return-Path: <linux-kernel-owner+w=401wt.eu-S1762124AbXKNCGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762124AbXKNCGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761310AbXKNCE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:04:58 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4746 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882AbXKNCEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:04:55 -0500
Subject: [PATCH] - [3/15] - remove defconfig ptr comparisons to 0 -
	drivers/scsi/aic7xxx
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:04:56 -0800
Message-Id: <1195005896.5163.89.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
index 4488946..223bad1 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -310,7 +310,7 @@ ahc_linux_pci_reserve_io_region(struct ahc_softc *ahc, u_long *base)
 	*base = pci_resource_start(ahc->dev_softc, 0);
 	if (*base == 0)
 		return (ENOMEM);
-	if (request_region(*base, 256, "aic7xxx") == 0)
+	if (!request_region(*base, 256, "aic7xxx"))
 		return (ENOMEM);
 	return (0);
 }
@@ -327,7 +327,7 @@ ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
 	start = pci_resource_start(ahc->dev_softc, 1);
 	if (start != 0) {
 		*bus_addr = start;
-		if (request_mem_region(start, 0x1000, "aic7xxx") == 0)
+		if (!request_mem_region(start, 0x1000, "aic7xxx"))
 			error = ENOMEM;
 		if (error == 0) {
 			*maddr = ioremap_nocache(start, 256);


