Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbXJ2V7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbXJ2V7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbXJ2V72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:59:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:43690 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbXJ2V71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:59:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,344,1188802800"; 
   d="scan'208";a="362901159"
From: Auke Kok <auke-jan.h.kok@intel.com>
Subject: [PATCH] quirk_vialatency: Omit reading pci revision ID
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Date: Mon, 29 Oct 2007 14:55:02 -0700
Message-ID: <20071029215502.4951.90574.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2007 21:55:04.0909 (UTC) FILETIME=[5D045FD0:01C81A76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't read the revision ID unnecessary since the PCI subsystem
fills this field in already.

Updated to fix a thinko bug in a previously sent patch.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Cc: alan@lxorguk.ukuu.org.uk
---

 drivers/pci/quirks.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index d0bb5b9..92dc513 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -139,25 +139,22 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 	PCI_DEVICE_ID_INTEL_82439TX, 	quir
 static void quirk_vialatency(struct pci_dev *dev)
 {
 	struct pci_dev *p;
-	u8 rev;
 	u8 busarb;
 	/* Ok we have a potential problem chipset here. Now see if we have
 	   a buggy southbridge */
 	   
 	p = pci_get_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C686, NULL);
 	if (p!=NULL) {
-		pci_read_config_byte(p, PCI_CLASS_REVISION, &rev);
 		/* 0x40 - 0x4f == 686B, 0x10 - 0x2f == 686A; thanks Dan Hollis */
 		/* Check for buggy part revisions */
-		if (rev < 0x40 || rev > 0x42)
+		if (p->revision < 0x40 || p->revision > 0x42)
 			goto exit;
 	} else {
 		p = pci_get_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8231, NULL);
 		if (p==NULL)	/* No problem parts */
 			goto exit;
-		pci_read_config_byte(p, PCI_CLASS_REVISION, &rev);
 		/* Check for buggy part revisions */
-		if (rev < 0x10 || rev > 0x12) 
+		if (p->revision < 0x10 || p->revision > 0x12) 
 			goto exit;
 	}
 	
