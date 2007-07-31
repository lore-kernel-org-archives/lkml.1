Return-Path: <linux-kernel-owner+w=401wt.eu-S1762787AbXGaNMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762787AbXGaNMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761359AbXGaNKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:10:02 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761766AbXGaNKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:10:00 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125447.639642000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:31 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, James Bottomley <james.bottomley@steeleye.com>
Subject: [Patch 15/16] Remove unnecesary kmalloc casts in the scsi drivers.
Content-Disposition: inline; filename=drivers_scsi_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: James Bottomley <james.bottomley@steeleye.com>

---
 drivers/scsi/advansys.c |    2 +-
 drivers/scsi/osst.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/advansys.c
===================================================================
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -18513,7 +18513,7 @@ advansys_board_found(int iop, struct dev
 		 * Allocate buffer carrier structures. The total size
 		 * is about 4 KB, so allocate all at once.
 		 */
-		carrp = (ADV_CARR_T *) kmalloc(ADV_CARRIER_BUFSIZE, GFP_ATOMIC);
+		carrp = kmalloc(ADV_CARRIER_BUFSIZE, GFP_ATOMIC);
 		ASC_DBG1(1, "advansys_board_found: carrp 0x%lx\n", (ulong)carrp);
 
 		if (carrp == NULL) {
Index: b/drivers/scsi/osst.c
===================================================================
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5756,7 +5756,7 @@ static int osst_probe(struct device *dev
 	write_lock(&os_scsi_tapes_lock);
 	if (os_scsi_tapes == NULL) {
 		os_scsi_tapes =
-			(struct osst_tape **)kmalloc(osst_max_dev * sizeof(struct osst_tape *),
+			kmalloc(osst_max_dev * sizeof(struct osst_tape *),
 				   GFP_ATOMIC);
 		if (os_scsi_tapes == NULL) {
 			write_unlock(&os_scsi_tapes_lock);

-- 
