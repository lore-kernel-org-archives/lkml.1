Return-Path: <linux-kernel-owner+w=401wt.eu-S933221AbXBWVni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbXBWVni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 16:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbXBWVni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 16:43:38 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53410 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933221AbXBWVnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 16:43:37 -0500
To: linux-kernel@vger.kernel.org
CC: jgarzik@pobox.com
Subject: [PATCH] libata: handle ata_pci_device_do_resume() failure while resuming
From: Dmitriy Monakhov <dmonakhov@openvz.org>
Date: Sat, 24 Feb 2007 00:43:18 +0300
Message-ID: <87abz4ble1.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [194.85.82.65]); Sat, 24 Feb 2007 00:43:35 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit:553c4aa630af7bc885e056d0436e4eb7f238579b
ata_pci_device_do_resume() can return error code, all callers was updated
except this one.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 drivers/ata/sata_inic162x.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 31b636f..7933043 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -639,7 +639,10 @@ static int inic_pci_device_resume(struct pci_dev *pdev)
 	void __iomem *mmio_base = host->iomap[MMIO_BAR];
 	int rc;
 
-	ata_pci_device_do_resume(pdev);
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc) {
+		return rc;
+	}
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
 		printk("XXX\n");
-- 
1.4.4.4


