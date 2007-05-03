Return-Path: <linux-kernel-owner+w=401wt.eu-S1030989AbXECJhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030989AbXECJhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030980AbXECJhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:37:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3883 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030802AbXECJhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:37:13 -0400
From: Mark Brown <broonie@sirena.org.uk>
To: Tim Hockin <thockin@hockin.org>, Jeff Garzik <jeff@garzik.org>
Cc: =?utf-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2007 10:36:50 +0100
Message-ID: <20070503093650.7800.45441.stgit@mercator.sirena.org.uk>
In-Reply-To: <20070503093435.7800.38591.stgit@mercator.sirena.org.uk>
References: <20070503093435.7800.38591.stgit@mercator.sirena.org.uk>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.32.140.119
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/2] natsemi: Improve diagnostics for DspCfg workaround
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The natsemi driver has a workaround for broken hardware which resets itself
from time to time.  There is a diagnostic message for this workaround but
it is not printed by default, making the driver behavior more obscure than
it needs to be.  Make the message be displayed by default.

Signed-Off-By: Mark Brown <broonie@sirena.org.uk>
---

 drivers/net/natsemi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index a8d7ff2..109e802 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -1756,7 +1756,7 @@ static void netdev_timer(unsigned long data)
 		if (dspcfg != np->dspcfg) {
 			if (!netif_queue_stopped(dev)) {
 				spin_unlock_irq(&np->lock);
-				if (netif_msg_hw(np))
+				if (netif_msg_drv(np))
 					printk(KERN_NOTICE "%s: possible phy reset: "
 						"re-initializing\n", dev->name);
 				disable_irq(dev->irq);

