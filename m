Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZDOGsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZDOGsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbZDOGsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:48:11 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43808 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZDOGsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:48:09 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/3] Char: cyclades, load firmware even on Ze
Date: Wed, 15 Apr 2009 08:47:12 +0200
Message-Id: <1239778034-18099-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ze needs firmware to be loaded as well as Zo. Move cyz_load_fw one
level upper to achieve that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 1fdb9f6..bde2458 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -5043,6 +5043,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 			nchan = ZE_V1_NPORTS;
 		} else {
 			card_name = "Cyclades-8Zo";
+			nchan = 8;
 
 #ifdef CY_PCI_DEBUG
 			if (mailbox == ZO_V1) {
@@ -5065,15 +5066,11 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 			 */
 			if ((mailbox == ZO_V1) || (mailbox == ZO_V2))
 				cy_writel(addr2 + ID_ADDRESS, 0L);
-
-			retval = cyz_load_fw(pdev, addr2, addr0, irq);
-			if (retval)
-				goto err_unmap;
-			/* This must be a Cyclades-8Zo/PCI.  The extendable
-			   version will have a different device_id and will
-			   be allocated its maximum number of ports. */
-			nchan = 8;
 		}
+
+		retval = cyz_load_fw(pdev, addr2, addr0, irq);
+		if (retval)
+			goto err_unmap;
 	}
 
 	if ((cy_next_channel + nchan) > NR_PORTS) {
-- 
1.6.2

