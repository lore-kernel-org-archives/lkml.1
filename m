Return-Path: <linux-kernel-owner+w=401wt.eu-S933261AbYCFC1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbYCFC1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761993AbYCFCZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:25:01 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:61432 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583AbYCFCY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:24:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=S9OTiaUlklpRSNVR4nTaJFeGXbe9PyG1o38X4rBRC9CMdfkUYy8v7wyiKsazNtcBzPMkgcwr1QS80LnaLDD7bb+p3STKGCfUrxnQ4ECn6ctjabmbUOg5xBZME32sBqHwhTA02CzfJ/4cHrbj3aacFYT1E1cyQfOI9cTcmU+sWdU=
Subject: [PATCH 05/16] iop-adma.c: replace remaining __FUNCTION__
	occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:24:53 -0800
Message-Id: <1204770293.14154.41.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/dma/iop-adma.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 3986d54..f82b090 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -140,7 +140,7 @@ static void __iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 	int busy = iop_chan_is_busy(iop_chan);
 	int seen_current = 0, slot_cnt = 0, slots_per_op = 0;
 
-	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __func__);
 	/* free completed slots from the chain starting with
 	 * the oldest descriptor
 	 */
@@ -438,7 +438,7 @@ iop_adma_tx_submit(struct dma_async_tx_descriptor *tx)
 	spin_unlock_bh(&iop_chan->lock);
 
 	dev_dbg(iop_chan->device->common.dev, "%s cookie: %d slot: %d\n",
-		__FUNCTION__, sw_desc->async_tx.cookie, sw_desc->idx);
+		__func__, sw_desc->async_tx.cookie, sw_desc->idx);
 
 	return cookie;
 }
@@ -520,7 +520,7 @@ iop_adma_prep_dma_interrupt(struct dma_chan *chan)
 	struct iop_adma_desc_slot *sw_desc, *grp_start;
 	int slot_cnt, slots_per_op;
 
-	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __func__);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_interrupt_slot_count(&slots_per_op, iop_chan);
@@ -548,7 +548,7 @@ iop_adma_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dma_dest,
 	BUG_ON(unlikely(len > IOP_ADMA_MAX_BYTE_COUNT));
 
 	dev_dbg(iop_chan->device->common.dev, "%s len: %u\n",
-		__FUNCTION__, len);
+		__func__, len);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_memcpy_slot_count(len, &slots_per_op);
@@ -580,7 +580,7 @@ iop_adma_prep_dma_memset(struct dma_chan *chan, dma_addr_t dma_dest,
 	BUG_ON(unlikely(len > IOP_ADMA_MAX_BYTE_COUNT));
 
 	dev_dbg(iop_chan->device->common.dev, "%s len: %u\n",
-		__FUNCTION__, len);
+		__func__, len);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_memset_slot_count(len, &slots_per_op);
@@ -614,7 +614,7 @@ iop_adma_prep_dma_xor(struct dma_chan *chan, dma_addr_t dma_dest,
 
 	dev_dbg(iop_chan->device->common.dev,
 		"%s src_cnt: %d len: %u flags: %lx\n",
-		__FUNCTION__, src_cnt, len, flags);
+		__func__, src_cnt, len, flags);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_xor_slot_count(len, src_cnt, &slots_per_op);
@@ -648,7 +648,7 @@ iop_adma_prep_dma_zero_sum(struct dma_chan *chan, dma_addr_t *dma_src,
 		return NULL;
 
 	dev_dbg(iop_chan->device->common.dev, "%s src_cnt: %d len: %u\n",
-		__FUNCTION__, src_cnt, len);
+		__func__, src_cnt, len);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_zero_sum_slot_count(len, src_cnt, &slots_per_op);
@@ -659,7 +659,7 @@ iop_adma_prep_dma_zero_sum(struct dma_chan *chan, dma_addr_t *dma_src,
 		iop_desc_set_zero_sum_byte_count(grp_start, len);
 		grp_start->xor_check_result = result;
 		pr_debug("\t%s: grp_start->xor_check_result: %p\n",
-			__FUNCTION__, grp_start->xor_check_result);
+			__func__, grp_start->xor_check_result);
 		sw_desc->unmap_src_cnt = src_cnt;
 		sw_desc->unmap_len = len;
 		while (src_cnt--)
@@ -700,7 +700,7 @@ static void iop_adma_free_chan_resources(struct dma_chan *chan)
 	iop_chan->last_used = NULL;
 
 	dev_dbg(iop_chan->device->common.dev, "%s slots_allocated %d\n",
-		__FUNCTION__, iop_chan->slots_allocated);
+		__func__, iop_chan->slots_allocated);
 	spin_unlock_bh(&iop_chan->lock);
 
 	/* one is ok since we left it on there on purpose */
@@ -753,7 +753,7 @@ static irqreturn_t iop_adma_eot_handler(int irq, void *data)
 {
 	struct iop_adma_chan *chan = data;
 
-	dev_dbg(chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(chan->device->common.dev, "%s\n", __func__);
 
 	tasklet_schedule(&chan->irq_tasklet);
 
@@ -766,7 +766,7 @@ static irqreturn_t iop_adma_eoc_handler(int irq, void *data)
 {
 	struct iop_adma_chan *chan = data;
 
-	dev_dbg(chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(chan->device->common.dev, "%s\n", __func__);
 
 	tasklet_schedule(&chan->irq_tasklet);
 
@@ -823,7 +823,7 @@ static int __devinit iop_adma_memcpy_self_test(struct iop_adma_device *device)
 	int err = 0;
 	struct iop_adma_chan *iop_chan;
 
-	dev_dbg(device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(device->common.dev, "%s\n", __func__);
 
 	src = kzalloc(sizeof(u8) * IOP_ADMA_TEST_SIZE, GFP_KERNEL);
 	if (!src)
@@ -906,7 +906,7 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 	int err = 0;
 	struct iop_adma_chan *iop_chan;
 
-	dev_dbg(device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(device->common.dev, "%s\n", __func__);
 
 	for (src_idx = 0; src_idx < IOP_ADMA_NUM_SRC_TEST; src_idx++) {
 		xor_srcs[src_idx] = alloc_page(GFP_KERNEL);
@@ -1159,7 +1159,7 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 	}
 
 	dev_dbg(&pdev->dev, "%s: allocted descriptor pool virt %p phys %p\n",
-		__FUNCTION__, adev->dma_desc_pool_virt,
+		__func__, adev->dma_desc_pool_virt,
 		(void *) adev->dma_desc_pool);
 
 	adev->id = plat_data->hw_id;
@@ -1289,7 +1289,7 @@ static void iop_chan_start_null_memcpy(struct iop_adma_chan *iop_chan)
 	dma_cookie_t cookie;
 	int slot_cnt, slots_per_op;
 
-	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __func__);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_memcpy_slot_count(0, &slots_per_op);
@@ -1346,7 +1346,7 @@ static void iop_chan_start_null_xor(struct iop_adma_chan *iop_chan)
 	dma_cookie_t cookie;
 	int slot_cnt, slots_per_op;
 
-	dev_dbg(iop_chan->device->common.dev, "%s\n", __FUNCTION__);
+	dev_dbg(iop_chan->device->common.dev, "%s\n", __func__);
 
 	spin_lock_bh(&iop_chan->lock);
 	slot_cnt = iop_chan_xor_slot_count(0, 2, &slots_per_op);
-- 
1.5.4.GIT


