Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbXJ2N3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbXJ2N3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbXJ2N3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:29:11 -0400
Received: from ns120.gr8dns.org ([193.108.181.120]:46502 "EHLO mail.gr8dns.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbXJ2N3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:29:10 -0400
Date: Mon, 29 Oct 2007 06:28:17 -0700
From: Dirk Hohndel <hohndel@linux.intel.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] pciserial_resume_one ignored return value of pci_enable_device
Message-ID: <20071029132817.GA20449@bigserver.hohndel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] pciserial_resume_one ignored return value of pci_enable_device

Signed-off-by: Dirk Hohndel <hohndel@linux.intel.com>

---
 drivers/serial/8250_pci.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 0e35756..ceb03c9 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -1986,6 +1986,7 @@ static int pciserial_suspend_one(struct pci_dev *dev, pm_message_t state)
 
 static int pciserial_resume_one(struct pci_dev *dev)
 {
+	int err;
 	struct serial_private *priv = pci_get_drvdata(dev);
 
 	pci_set_power_state(dev, PCI_D0);
@@ -1995,7 +1996,9 @@ static int pciserial_resume_one(struct pci_dev *dev)
 		/*
 		 * The device may have been disabled.  Re-enable it.
 		 */
-		pci_enable_device(dev);
+		err = pci_enable_device(dev);
+		if (err)
+			return err;
 
 		pciserial_resume_ports(priv);
 	}
-- 
gitgui.0.8.4.g8d863

