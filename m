Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbZCXOD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbZCXOD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbZCXOCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:02:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48931 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757400AbZCXOCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:02:06 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/30] PCI: quirks, don't mark one netmos as class other
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:02:32 +0000
Message-ID: <20090324140228.12735.2766.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Let it as serial, since it doesn't have subdevice in the form of 0x00PS.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@etchedpixels.co.uk>
---

 drivers/pci/quirks.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 92b9efe..5aa2afb 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1664,9 +1664,13 @@ static void __devinit quirk_netmos(struct pci_dev *dev)
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

