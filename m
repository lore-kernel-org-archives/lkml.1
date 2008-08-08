Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYHHPRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYHHPRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYHHPRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:17:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbYHHPRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:17:30 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adam Jackson <ajax@redhat.com>
Subject: [PATCH] PIIX3: Reduce passive release quirk message log level.
Date: Fri,  8 Aug 2008 11:07:10 -0400
Message-Id: <1218208030-10048-1-git-send-email-ajax@redhat.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes quiet boot in qemu really quiet.  All the other PCI quirk messages
are dev_info() already.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/pci/quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 0fb3650..4f45f02 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -47,7 +47,7 @@ static void quirk_passive_release(struct pci_dev *dev)
 	while ((d = pci_get_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371SB_0, d))) {
 		pci_read_config_byte(d, 0x82, &dlc);
 		if (!(dlc & 1<<1)) {
-			dev_err(&d->dev, "PIIX3: Enabling Passive Release\n");
+			dev_info(&d->dev, "PIIX3: Enabling Passive Release\n");
 			dlc |= 1<<1;
 			pci_write_config_byte(d, 0x82, dlc);
 		}
-- 
1.5.6

