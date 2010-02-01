Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab0BAPOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:14:21 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:55475 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab0BAPOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:14:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pOwYeC7rmX3s4VzwECH9Tx8sZ/fgU6OB0yTgFmVMv4rGZA7sTEvzWBVAjrVM5aH7+x
         t5shInbFKu2zz+XXHvqgHeoM/l6HXxm7UgZHJP86Ms5YbHyy/G+o1NPURvQH8402XbgV
         MGpxkviMkC/mp8xbRtAbyogOIDhE5SFCXzSFA=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/9] bitops: rename for_each_bit to for_each_set_bit
Date: Tue,  2 Feb 2010 00:10:32 +0900
Message-Id: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename for_each_bit to for_each_set_bit in the kernel source tree.

Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
Suggested-by: <akpm@linux-foundation.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c            |    4 ++--
 drivers/dma/ioat/dma.c                      |    2 +-
 drivers/gpio/pl061.c                        |    2 +-
 drivers/gpio/timbgpio.c                     |    2 +-
 drivers/i2c/busses/i2c-designware.c         |    4 ++--
 drivers/mfd/htc-egpio.c                     |    2 +-
 drivers/misc/sgi-xp/xpnet.c                 |    2 +-
 drivers/net/gianfar.c                       |   12 ++++++------
 drivers/net/ixgbe/ixgbe_main.c              |    2 +-
 drivers/net/wireless/ath/ar9170/main.c      |    2 +-
 drivers/net/wireless/iwmc3200wifi/debugfs.c |    2 +-
 drivers/net/wireless/iwmc3200wifi/rx.c      |    2 +-
 fs/ocfs2/quota_local.c                      |    2 +-
 include/linux/bitops.h                      |    2 +-
 sound/soc/codecs/uda1380.c                  |    2 +-
 15 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8c1c070..5971d0a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1456,7 +1456,7 @@ intel_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 
 	for_each_event_constraint(event_constraint, event_constraints) {
 		if (code == event_constraint->code) {
-			for_each_bit(i, event_constraint->idxmsk, X86_PMC_IDX_MAX) {
+			for_each_set_bit(i, event_constraint->idxmsk, X86_PMC_IDX_MAX) {
 				if (!test_and_set_bit(i, cpuc->used_mask))
 					return i;
 			}
@@ -1827,7 +1827,7 @@ again:
 
 	inc_irq_stat(apic_perf_irqs);
 	ack = status;
-	for_each_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
+	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
 		clear_bit(bit, (unsigned long *) &status);
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index dcc4ab7..aea7bf1 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -71,7 +71,7 @@ static irqreturn_t ioat_dma_do_interrupt(int irq, void *data)
 	}
 
 	attnstatus = readl(instance->reg_base + IOAT_ATTNSTATUS_OFFSET);
-	for_each_bit(bit, &attnstatus, BITS_PER_LONG) {
+	for_each_set_bit(bit, &attnstatus, BITS_PER_LONG) {
 		chan = ioat_chan_by_index(instance, bit);
 		tasklet_schedule(&chan->cleanup_task);
 	}
diff --git a/drivers/gpio/pl061.c b/drivers/gpio/pl061.c
index 4ee4c83..3ad1eeb 100644
--- a/drivers/gpio/pl061.c
+++ b/drivers/gpio/pl061.c
@@ -219,7 +219,7 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 		if (pending == 0)
 			continue;
 
-		for_each_bit(offset, &pending, PL061_GPIO_NR)
+		for_each_set_bit(offset, &pending, PL061_GPIO_NR)
 			generic_handle_irq(pl061_to_irq(&chip->gc, offset));
 	}
 	desc->chip->unmask(irq);
diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/timbgpio.c
index a4d344b..ebedcad 100644
--- a/drivers/gpio/timbgpio.c
+++ b/drivers/gpio/timbgpio.c
@@ -174,7 +174,7 @@ static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
 	ipr = ioread32(tgpio->membase + TGPIO_IPR);
 	iowrite32(ipr, tgpio->membase + TGPIO_ICR);
 
-	for_each_bit(offset, &ipr, tgpio->gpio.ngpio)
+	for_each_set_bit(offset, &ipr, tgpio->gpio.ngpio)
 		generic_handle_irq(timbgpio_to_irq(&tgpio->gpio, offset));
 }
 
diff --git a/drivers/i2c/busses/i2c-designware.c b/drivers/i2c/busses/i2c-designware.c
index 9e18ef9..3e72b69 100644
--- a/drivers/i2c/busses/i2c-designware.c
+++ b/drivers/i2c/busses/i2c-designware.c
@@ -497,13 +497,13 @@ static int i2c_dw_handle_tx_abort(struct dw_i2c_dev *dev)
 	int i;
 
 	if (abort_source & DW_IC_TX_ABRT_NOACK) {
-		for_each_bit(i, &abort_source, ARRAY_SIZE(abort_sources))
+		for_each_set_bit(i, &abort_source, ARRAY_SIZE(abort_sources))
 			dev_dbg(dev->dev,
 				"%s: %s\n", __func__, abort_sources[i]);
 		return -EREMOTEIO;
 	}
 
-	for_each_bit(i, &abort_source, ARRAY_SIZE(abort_sources))
+	for_each_set_bit(i, &abort_source, ARRAY_SIZE(abort_sources))
 		dev_err(dev->dev, "%s: %s\n", __func__, abort_sources[i]);
 
 	if (abort_source & DW_IC_TX_ARB_LOST)
diff --git a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
index aa266e1..addb846 100644
--- a/drivers/mfd/htc-egpio.c
+++ b/drivers/mfd/htc-egpio.c
@@ -108,7 +108,7 @@ static void egpio_handler(unsigned int irq, struct irq_desc *desc)
 	ack_irqs(ei);
 	/* Process all set pins. */
 	readval &= ei->irqs_enabled;
-	for_each_bit(irqpin, &readval, ei->nirqs) {
+	for_each_set_bit(irqpin, &readval, ei->nirqs) {
 		/* Run irq handler */
 		pr_debug("got IRQ %d\n", irqpin);
 		irq = ei->irq_start + irqpin;
diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
index 16f0abd..57b152f 100644
--- a/drivers/misc/sgi-xp/xpnet.c
+++ b/drivers/misc/sgi-xp/xpnet.c
@@ -475,7 +475,7 @@ xpnet_dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (skb->data[0] == 0xff) {
 		/* we are being asked to broadcast to all partitions */
-		for_each_bit(dest_partid, xpnet_broadcast_partitions,
+		for_each_set_bit(dest_partid, xpnet_broadcast_partitions,
 			     xp_max_npartitions) {
 
 			xpnet_send(skb, queued_msg, start_addr, end_addr,
diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 8bd3c9f..583727c 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -998,7 +998,7 @@ static int gfar_probe(struct of_device *ofdev,
 	}
 
 	/* Need to reverse the bit maps as  bit_map's MSB is q0
-	 * but, for_each_bit parses from right to left, which
+	 * but, for_each_set_bit parses from right to left, which
 	 * basically reverses the queue numbers */
 	for (i = 0; i< priv->num_grps; i++) {
 		priv->gfargrp[i].tx_bit_map = reverse_bitmap(
@@ -1011,7 +1011,7 @@ static int gfar_probe(struct of_device *ofdev,
 	 * also assign queues to groups */
 	for (grp_idx = 0; grp_idx < priv->num_grps; grp_idx++) {
 		priv->gfargrp[grp_idx].num_rx_queues = 0x0;
-		for_each_bit(i, &priv->gfargrp[grp_idx].rx_bit_map,
+		for_each_set_bit(i, &priv->gfargrp[grp_idx].rx_bit_map,
 				priv->num_rx_queues) {
 			priv->gfargrp[grp_idx].num_rx_queues++;
 			priv->rx_queue[i]->grp = &priv->gfargrp[grp_idx];
@@ -1019,7 +1019,7 @@ static int gfar_probe(struct of_device *ofdev,
 			rqueue = rqueue | ((RQUEUE_EN0 | RQUEUE_EX0) >> i);
 		}
 		priv->gfargrp[grp_idx].num_tx_queues = 0x0;
-		for_each_bit (i, &priv->gfargrp[grp_idx].tx_bit_map,
+		for_each_set_bit(i, &priv->gfargrp[grp_idx].tx_bit_map,
 				priv->num_tx_queues) {
 			priv->gfargrp[grp_idx].num_tx_queues++;
 			priv->tx_queue[i]->grp = &priv->gfargrp[grp_idx];
@@ -1709,7 +1709,7 @@ void gfar_configure_coalescing(struct gfar_private *priv,
 
 	if (priv->mode == MQ_MG_MODE) {
 		baddr = &regs->txic0;
-		for_each_bit (i, &tx_mask, priv->num_tx_queues) {
+		for_each_set_bit(i, &tx_mask, priv->num_tx_queues) {
 			if (likely(priv->tx_queue[i]->txcoalescing)) {
 				gfar_write(baddr + i, 0);
 				gfar_write(baddr + i, priv->tx_queue[i]->txic);
@@ -1717,7 +1717,7 @@ void gfar_configure_coalescing(struct gfar_private *priv,
 		}
 
 		baddr = &regs->rxic0;
-		for_each_bit (i, &rx_mask, priv->num_rx_queues) {
+		for_each_set_bit(i, &rx_mask, priv->num_rx_queues) {
 			if (likely(priv->rx_queue[i]->rxcoalescing)) {
 				gfar_write(baddr + i, 0);
 				gfar_write(baddr + i, priv->rx_queue[i]->rxic);
@@ -2607,7 +2607,7 @@ static int gfar_poll(struct napi_struct *napi, int budget)
 		budget_per_queue = left_over_budget/num_queues;
 		left_over_budget = 0;
 
-		for_each_bit(i, &gfargrp->rx_bit_map, priv->num_rx_queues) {
+		for_each_set_bit(i, &gfargrp->rx_bit_map, priv->num_rx_queues) {
 			if (test_bit(i, &serviced_queues))
 				continue;
 			rx_queue = priv->rx_queue[i];
diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index b5f64ad..5c57878 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -984,7 +984,7 @@ static void ixgbe_configure_msix(struct ixgbe_adapter *adapter)
 	 */
 	for (v_idx = 0; v_idx < q_vectors; v_idx++) {
 		q_vector = adapter->q_vector[v_idx];
-		/* XXX for_each_bit(...) */
+		/* XXX for_each_set_bit(...) */
 		r_idx = find_first_bit(q_vector->rxr_idx,
 		                       adapter->num_rx_queues);
 
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index f9d6db8..fbf7d87 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -391,7 +391,7 @@ static void ar9170_tx_fake_ampdu_status(struct ar9170 *ar)
 		ieee80211_tx_status_irqsafe(ar->hw, skb);
 	}
 
-	for_each_bit(i, &queue_bitmap, BITS_PER_BYTE) {
+	for_each_set_bit(i, &queue_bitmap, BITS_PER_BYTE) {
 #ifdef AR9170_QUEUE_STOP_DEBUG
 		printk(KERN_DEBUG "%s: wake queue %d\n",
 		       wiphy_name(ar->hw->wiphy), i);
diff --git a/drivers/net/wireless/iwmc3200wifi/debugfs.c b/drivers/net/wireless/iwmc3200wifi/debugfs.c
index be992ca..c29c994 100644
--- a/drivers/net/wireless/iwmc3200wifi/debugfs.c
+++ b/drivers/net/wireless/iwmc3200wifi/debugfs.c
@@ -89,7 +89,7 @@ static int iwm_debugfs_dbg_modules_write(void *data, u64 val)
 	for (i = 0; i < __IWM_DM_NR; i++)
 		iwm->dbg.dbg_module[i] = 0;
 
-	for_each_bit(bit, &iwm->dbg.dbg_modules, __IWM_DM_NR)
+	for_each_set_bit(bit, &iwm->dbg.dbg_modules, __IWM_DM_NR)
 		iwm->dbg.dbg_module[bit] = iwm->dbg.dbg_level;
 
 	return 0;
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 6d6ed74..652eaf1 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1117,7 +1117,7 @@ static int iwm_ntf_stop_resume_tx(struct iwm_priv *iwm, u8 *buf,
 		return -EINVAL;
 	}
 
-	for_each_bit(bit, (unsigned long *)&tid_msk, IWM_UMAC_TID_NR) {
+	for_each_set_bit(bit, (unsigned long *)&tid_msk, IWM_UMAC_TID_NR) {
 		tid_info = &sta_info->tid_info[bit];
 
 		mutex_lock(&tid_info->mutex);
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 21f9e71..a6467f3 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -457,7 +457,7 @@ static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 			break;
 		}
 		dchunk = (struct ocfs2_local_disk_chunk *)hbh->b_data;
-		for_each_bit(bit, rchunk->rc_bitmap, ol_chunk_entries(sb)) {
+		for_each_set_bit(bit, rchunk->rc_bitmap, ol_chunk_entries(sb)) {
 			qbh = NULL;
 			status = ocfs2_read_quota_block(lqinode,
 						ol_dqblk_block(sb, chunk, bit),
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index c05a29c..de68c58 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -16,7 +16,7 @@
  */
 #include <asm/bitops.h>
 
-#define for_each_bit(bit, addr, size) \
+#define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size)); \
 	     (bit) < (size); \
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
diff --git a/sound/soc/codecs/uda1380.c b/sound/soc/codecs/uda1380.c
index a2763c2..9cd0a66 100644
--- a/sound/soc/codecs/uda1380.c
+++ b/sound/soc/codecs/uda1380.c
@@ -137,7 +137,7 @@ static void uda1380_flush_work(struct work_struct *work)
 {
 	int bit, reg;
 
-	for_each_bit(bit, &uda1380_cache_dirty, UDA1380_CACHEREGNUM - 0x10) {
+	for_each_set_bit(bit, &uda1380_cache_dirty, UDA1380_CACHEREGNUM - 0x10) {
 		reg = 0x10 + bit;
 		pr_debug("uda1380: flush reg %x val %x:\n", reg,
 				uda1380_read_reg_cache(uda1380_codec, reg));
-- 
1.6.0.6

