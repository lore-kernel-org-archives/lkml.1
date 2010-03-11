Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782Ab0CKSGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:06:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63703 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933732Ab0CKSF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:05:58 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 23/37] drivers/i2c: use .dev.of_node instead of .node in
	struct of_device
To: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, davem@davemloft.net, sfr@canb.auug.org.au,
       jgarzik@pobox.com, ben-linux@fluff.org, dwmw2@infradead.org,
       jeremy.kerr@canonical.com, James.Bottomley@suse.de,
       broonie@opensource.wolfsonmicro.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-scsi@vger.kernel.org,
       alsa-devel@alsa-project.org
Date: Thu, 11 Mar 2010 11:05:55 -0700
Message-ID: <20100311180554.4824.52872.stgit@angua>
In-Reply-To: <20100311174830.4824.19820.stgit@angua>
References: <20100311174830.4824.19820.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.node is being removed

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/i2c/busses/i2c-mpc.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index 78a15af..0123a6e 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -559,14 +559,14 @@ static int __devinit fsl_i2c_probe(struct of_device *op,
 
 	init_waitqueue_head(&i2c->queue);
 
-	i2c->base = of_iomap(op->node, 0);
+	i2c->base = of_iomap(op->dev.of_node, 0);
 	if (!i2c->base) {
 		dev_err(i2c->dev, "failed to map controller\n");
 		result = -ENOMEM;
 		goto fail_map;
 	}
 
-	i2c->irq = irq_of_parse_and_map(op->node, 0);
+	i2c->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 	if (i2c->irq != NO_IRQ) { /* i2c->irq = NO_IRQ implies polling */
 		result = request_irq(i2c->irq, mpc_i2c_isr,
 				     IRQF_SHARED, "i2c-mpc", i2c);
@@ -576,21 +576,22 @@ static int __devinit fsl_i2c_probe(struct of_device *op,
 		}
 	}
 
-	if (of_get_property(op->node, "fsl,preserve-clocking", NULL)) {
+	if (of_get_property(op->dev.of_node, "fsl,preserve-clocking", NULL)) {
 		clock = MPC_I2C_CLOCK_PRESERVE;
 	} else {
-		prop = of_get_property(op->node, "clock-frequency", &plen);
+		prop = of_get_property(op->dev.of_node, "clock-frequency",
+					&plen);
 		if (prop && plen == sizeof(u32))
 			clock = *prop;
 	}
 
 	if (match->data) {
 		struct mpc_i2c_data *data = match->data;
-		data->setup(op->node, i2c, clock, data->prescaler);
+		data->setup(op->dev.of_node, i2c, clock, data->prescaler);
 	} else {
 		/* Backwards compatibility */
-		if (of_get_property(op->node, "dfsrr", NULL))
-			mpc_i2c_setup_8xxx(op->node, i2c, clock, 0);
+		if (of_get_property(op->dev.of_node, "dfsrr", NULL))
+			mpc_i2c_setup_8xxx(op->dev.of_node, i2c, clock, 0);
 	}
 
 	dev_set_drvdata(&op->dev, i2c);
@@ -604,7 +605,7 @@ static int __devinit fsl_i2c_probe(struct of_device *op,
 		dev_err(i2c->dev, "failed to add adapter\n");
 		goto fail_add;
 	}
-	of_register_i2c_devices(&i2c->adap, op->node);
+	of_register_i2c_devices(&i2c->adap, op->dev.of_node);
 
 	return result;
 

