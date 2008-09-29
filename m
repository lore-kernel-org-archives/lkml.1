Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbYI2SP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbYI2SP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbYI2SKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:10:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbYI2SK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:10:29 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adam Jackson <ajax@redhat.com>
Subject: [PATCH] PIIX3: Warn softer about enabling passive release.
Date: Mon, 29 Sep 2008 14:10:26 -0400
Message-Id: <1222711826-891-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the other quirks are dev_info() not dev_err(), this one isn't
special.  This makes 'quiet' boot in qemu really quiet.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/pci/quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 9236e7f..a299724 100644
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
1.6.0.1

