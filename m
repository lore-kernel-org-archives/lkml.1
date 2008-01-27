Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYA0N6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYA0N6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 08:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYA0N6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 08:58:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3128 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbYA0N6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 08:58:38 -0500
From: Mark Brown <broonie@sirena.org.uk>
To: Jeff Garzik <jeff@garzik.org>, Tim Hockin <thockin@hockin.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@sirena.org.uk>
Date: Sun, 27 Jan 2008 13:58:11 +0000
Message-Id: <1201442291-13668-1-git-send-email-broonie@sirena.org.uk>
X-Mailer: git-send-email 1.5.3.8
X-SA-Exim-Connect-IP: 82.32.140.119
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] natsemi: Update locking documentation
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation regarding synchronisation at the head of the natsemi
driver was badly bitrotted so replace it with a general statement about
the techniques used which is less likely to bitrot.

Also remove the note saying these chips are uncommon - it makes little
difference but they were used in a number of laptops and at least one mass
market PCI ethernet card.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
---
 drivers/net/natsemi.c |   18 ++----------------
 1 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index c329a4f..0a3e604 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -203,22 +203,8 @@ skbuff at an offset of "+2", 16-byte aligning the IP header.
 IIId. Synchronization
 
 Most operations are synchronized on the np->lock irq spinlock, except the
-performance critical codepaths:
-
-The rx process only runs in the interrupt handler. Access from outside
-the interrupt handler is only permitted after disable_irq().
-
-The rx process usually runs under the netif_tx_lock. If np->intr_tx_reap
-is set, then access is permitted under spin_lock_irq(&np->lock).
-
-Thus configuration functions that want to access everything must call
-	disable_irq(dev->irq);
-	netif_tx_lock_bh(dev);
-	spin_lock_irq(&np->lock);
-
-IV. Notes
-
-NatSemi PCI network controllers are very uncommon.
+recieve and transmit paths which are synchronised using a combination of
+hardware descriptor ownership, disabling interrupts and NAPI poll scheduling.
 
 IVb. References
 
-- 
1.5.3.8

