Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZFKR3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZFKR3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbZFKR2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:28:43 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:57928 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbZFKR2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:28:42 -0400
Message-Id: <cdae28e1a28f26c765c5882a48b9fd4a5b9ce91c.1244739994.git.keil@b1-systems.de>
In-Reply-To: <cover.1244739994.git.keil@b1-systems.de>
References: <cover.1244739994.git.keil@b1-systems.de>
Date: Tue, 2 Jun 2009 18:15:12 +0200
Subject: [PATCH 3/6] mISDN: Free hfcpci IRQ if init was not successful
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Mohr <andi@lisas.de>

If we get no interrupts for after 3 resets we need to unregister
the interrupt function, which is already done outside the loop.

Signed-off-by: Andreas Mohr <andi@lisas.de>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/hardware/mISDN/hfcpci.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 776afc8..228ffbe 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -1806,10 +1806,9 @@ init_card(struct hfc_pci *hc)
 			printk(KERN_WARNING
 			    "HFC PCI: IRQ(%d) getting no interrupts "
 			    "during init %d\n", hc->irq, 4 - cnt);
-			if (cnt == 1) {
-				spin_unlock_irqrestore(&hc->lock, flags);
-				return -EIO;
-			} else {
+			if (cnt == 1)
+				break;
+			else {
 				reset_hfcpci(hc);
 				cnt--;
 			}
-- 
1.6.0.2

