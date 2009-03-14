Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbZCNVlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbZCNVlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZCNVj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:39:56 -0400
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:57987 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757836AbZCNVjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:39:55 -0400
From: =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [PATCH 06/09] Checkpatch.pl: Fixup sta.c
Date: Sat, 14 Mar 2009 22:39:33 +0100
Message-Id: <1237066776-14697-7-git-send-email-erik.andren@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1237066776-14697-6-git-send-email-erik.andren@gmail.com>
References: <1>
 <1237066776-14697-1-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-2-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-3-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-4-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-5-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-6-git-send-email-erik.andren@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erik Andrén <erik.andren@gmail.com>
---
 drivers/staging/agnx/sta.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/agnx/sta.c b/drivers/staging/agnx/sta.c
index d3ac675..a3fd16c 100644
--- a/drivers/staging/agnx/sta.c
+++ b/drivers/staging/agnx/sta.c
@@ -18,7 +18,7 @@ void hash_read(struct agnx_priv *priv, u32 reghi, u32 reglo, u8 sta_id)
 	iowrite32(reglo, ctl + AGNX_RXM_HASH_CMD_LOW);
 
 	reghi = ioread32(ctl + AGNX_RXM_HASH_CMD_HIGH);
-        reglo = ioread32(ctl + AGNX_RXM_HASH_CMD_LOW);
+	reglo = ioread32(ctl + AGNX_RXM_HASH_CMD_LOW);
 	printk(PFX "RX hash cmd are : %.8x%.8x\n", reghi, reglo);
 }
 
@@ -40,7 +40,7 @@ void hash_write(struct agnx_priv *priv, u8 *mac_addr, u8 sta_id)
 	iowrite32(reghi, ctl + AGNX_RXM_HASH_CMD_HIGH);
 	iowrite32(reglo, ctl + AGNX_RXM_HASH_CMD_LOW);
 
-        reglo = ioread32(ctl + AGNX_RXM_HASH_CMD_LOW);
+	reglo = ioread32(ctl + AGNX_RXM_HASH_CMD_LOW);
 	if (!(reglo & 0x80000000))
 		printk(KERN_WARNING PFX "Update hash table failed\n");
 }
@@ -59,7 +59,7 @@ void hash_delete(struct agnx_priv *priv, u32 reghi, u32 reglo, u8 sta_id)
 	iowrite32(reglo, ctl + AGNX_RXM_HASH_CMD_LOW);
 	reghi = ioread32(ctl + AGNX_RXM_HASH_CMD_HIGH);
 
-        reglo = ioread32(ctl + AGNX_RXM_HASH_CMD_LOW);
+	reglo = ioread32(ctl + AGNX_RXM_HASH_CMD_LOW);
 	printk(PFX "RX hash cmd are : %.8x%.8x\n", reghi, reglo);
 
 }
@@ -69,15 +69,14 @@ void hash_dump(struct agnx_priv *priv, u8 sta_id)
 	void __iomem *ctl = priv->ctl;
 	u32 reghi, reglo;
 
-	reglo = 0x0;		/* dump command */
-	reglo|= 0x40000000;  	/* status bit */
+	reglo = 0x40000000;  	/* status bit */
 	iowrite32(reglo, ctl + AGNX_RXM_HASH_CMD_LOW);
 	iowrite32(sta_id << 16, ctl + AGNX_RXM_HASH_DUMP_DATA);
 
 	udelay(80);
 
 	reghi = ioread32(ctl + AGNX_RXM_HASH_CMD_HIGH);
-        reglo = ioread32(ctl + AGNX_RXM_HASH_CMD_LOW);
+	reglo = ioread32(ctl + AGNX_RXM_HASH_CMD_LOW);
 	printk(PFX "hash cmd are : %.8x%.8x\n", reghi, reglo);
 	reghi = ioread32(ctl + AGNX_RXM_HASH_CMD_FLAG);
 	printk(PFX "hash flag is : %.8x\n", reghi);
@@ -91,7 +90,7 @@ void hash_dump(struct agnx_priv *priv, u8 sta_id)
 void get_sta_power(struct agnx_priv *priv, struct agnx_sta_power *power, unsigned int sta_idx)
 {
 	void __iomem *ctl = priv->ctl;
-        memcpy_fromio(power, ctl + AGNX_TXM_STAPOWTEMP + sizeof(*power) * sta_idx,
+	memcpy_fromio(power, ctl + AGNX_TXM_STAPOWTEMP + sizeof(*power) * sta_idx,
 		      sizeof(*power));
 }
 
@@ -100,7 +99,7 @@ set_sta_power(struct agnx_priv *priv, struct agnx_sta_power *power, unsigned int
 {
 	void __iomem *ctl = priv->ctl;
 	/* FIXME   2. Write Template to offset + station number  */
-        memcpy_toio(ctl + AGNX_TXM_STAPOWTEMP + sizeof(*power) * sta_idx,
+	memcpy_toio(ctl + AGNX_TXM_STAPOWTEMP + sizeof(*power) * sta_idx,
 		    power, sizeof(*power));
 }
 
@@ -135,7 +134,7 @@ inline void set_sta(struct agnx_priv *priv, struct agnx_sta *sta, unsigned int s
 {
 	void __iomem *data = priv->data;
 
-        memcpy_toio(data + AGNX_PDUPOOL + sizeof(*sta) * sta_idx,
+	memcpy_toio(data + AGNX_PDUPOOL + sizeof(*sta) * sta_idx,
 		    sta, sizeof(*sta));
 }
 
@@ -165,7 +164,7 @@ static void sta_tx_workqueue_init(struct agnx_priv *priv, unsigned int sta_idx)
 
 	reg = agnx_set_bits(WORK_QUEUE_VALID, WORK_QUEUE_VALID_SHIFT, 1);
 	reg |= agnx_set_bits(WORK_QUEUE_ACK_TYPE, WORK_QUEUE_ACK_TYPE_SHIFT, 1);
-//	reg |= agnx_set_bits(WORK_QUEUE_ACK_TYPE, WORK_QUEUE_ACK_TYPE_SHIFT, 0);
+/*	reg |= agnx_set_bits(WORK_QUEUE_ACK_TYPE, WORK_QUEUE_ACK_TYPE_SHIFT, 0); */
 	tx_wq.reg2 |= cpu_to_le32(reg);
 
 	/* Suppose all 8 traffic class are used */
@@ -181,7 +180,7 @@ static void sta_traffic_init(struct agnx_sta_traffic *traffic)
 
 	reg = agnx_set_bits(NEW_PACKET, NEW_PACKET_SHIFT, 1);
 	reg |= agnx_set_bits(TRAFFIC_VALID, TRAFFIC_VALID_SHIFT, 1);
-//	reg |= agnx_set_bits(TRAFFIC_ACK_TYPE, TRAFFIC_ACK_TYPE_SHIFT, 1);
+/*	reg |= agnx_set_bits(TRAFFIC_ACK_TYPE, TRAFFIC_ACK_TYPE_SHIFT, 1); */
 	traffic->reg0 = cpu_to_le32(reg);
 
 	/* 	3. setting RX Sequence Number to 4095 */
-- 
1.6.0.4

