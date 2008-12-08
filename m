Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYLHPUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYLHPUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYLHPUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:20:00 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:49175 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbYLHPT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:19:58 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-serial@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/2] PCI: quirks, don't mark one netmos as class other
Date: Mon,  8 Dec 2008 16:19:14 +0100
Message-Id: <1228749555-21363-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let it as serial, since it doesn't have subdevice in the form of 0x00PS.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/quirks.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 400d868..4d42c16 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1585,9 +1585,13 @@ static void __devinit quirk_netmos(struct pci_dev *dev)
 	 * of parallel ports and <S> is the number of serial ports.
 	 */
 	switch (dev->device) {
+	case PCI_DEVICE_ID_NETMOS_9835:
+		/* Well, this rule doesn't hold for the following 9835 device */
+		if (dev->subsystem_vendor == PCI_VENDOR_ID_IBM &&
+				dev->subsystem_device == 0x0299)
+			return;
 	case PCI_DEVICE_ID_NETMOS_9735:
 	case PCI_DEVICE_ID_NETMOS_9745:
-	case PCI_DEVICE_ID_NETMOS_9835:
 	case PCI_DEVICE_ID_NETMOS_9845:
 	case PCI_DEVICE_ID_NETMOS_9855:
 		if ((dev->class >> 8) == PCI_CLASS_COMMUNICATION_SERIAL &&
-- 
1.6.0.5

