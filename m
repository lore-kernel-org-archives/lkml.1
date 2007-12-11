Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbXLKW2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbXLKW2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbXLKWYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:24:00 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38556 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755713AbXLKWX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:23:59 -0500
Date: Tue, 11 Dec 2007 23:24:00 +0100
From: Adrian Bunk <bunk@kernel.org>
To: James.Bottomley@HansenPartnership.com,
       "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/scsi/aic94xx/ section fixes
Message-ID: <20071211222400.GB14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch with CONFIG_HOTPLUG=n:

<--  snip  -->

...
WARNING: vmlinux.o(.init.text.20+0xb3061): Section mismatch: reference to .exit.text:asd_unmap_ha (between 'asd_pci_probe' and 'ips_insert_device')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/aic94xx/aic94xx_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

c9292b20fa9402084f207e7efa50fcd4150001a4 
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index b70d6e7..fc60f80 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -134,7 +134,7 @@ Err:
 	return err;
 }
 
-static void __devexit asd_unmap_memio(struct asd_ha_struct *asd_ha)
+static void asd_unmap_memio(struct asd_ha_struct *asd_ha)
 {
 	struct asd_ha_addrspace *io_handle;
 
@@ -171,7 +171,7 @@ static int __devinit asd_map_ioport(struct asd_ha_struct *asd_ha)
 	return err;
 }
 
-static void __devexit asd_unmap_ioport(struct asd_ha_struct *asd_ha)
+static void asd_unmap_ioport(struct asd_ha_struct *asd_ha)
 {
 	pci_release_region(asd_ha->pcidev, PCI_IOBAR_OFFSET);
 }
@@ -208,7 +208,7 @@ Err:
 	return err;
 }
 
-static void __devexit asd_unmap_ha(struct asd_ha_struct *asd_ha)
+static void asd_unmap_ha(struct asd_ha_struct *asd_ha)
 {
 	if (asd_ha->iospace)
 		asd_unmap_ioport(asd_ha);

