Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbYCVDUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbYCVDUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYCVDUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:20:33 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:45395 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626AbYCVDUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:20:31 -0400
Date: Fri, 21 Mar 2008 21:20:29 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] [POWERPC] mpc5200-fec: Fix possible NULL dereference in mdio
 driver
In-reply-to: <>
To: linux-kernel@vger.kernel.org, paulus@samba.org, linuxppc-dev@ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Message-id: <1206156029-2761-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.5.4.3
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the reg property is missing from the phy node (unlikely, but possible),
then the kernel will oops with a NULL pointer dereference.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
This one is a bugfix that should go in for 2.6.25.  Paul, can you please
pick it up?

Thanks,
g.

 drivers/net/fec_mpc52xx_phy.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/fec_mpc52xx_phy.c b/drivers/net/fec_mpc52xx_phy.c
index 1837584..6a3ac4e 100644
--- a/drivers/net/fec_mpc52xx_phy.c
+++ b/drivers/net/fec_mpc52xx_phy.c
@@ -109,7 +109,8 @@ static int mpc52xx_fec_mdio_probe(struct of_device *of, const struct of_device_i
 		int irq = irq_of_parse_and_map(child, 0);
 		if (irq != NO_IRQ) {
 			const u32 *id = of_get_property(child, "reg", NULL);
-			bus->irq[*id] = irq;
+			if (id)
+				bus->irq[*id] = irq;
 		}
 	}
 
-- 
1.5.4.3

