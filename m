Return-Path: <linux-kernel-owner+w=401wt.eu-S965217AbXBYXQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965217AbXBYXQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 18:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965218AbXBYXQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 18:16:54 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44212 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965217AbXBYXQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 18:16:53 -0500
Date: Mon, 26 Feb 2007 00:16:50 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Chris Leech <christopher.leech@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/dma/: no "static inline" in C files
Message-ID: <20070225231650.GB29575@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes "static inline"s in C files to "static":
gcc should know best whether or not to inline a static function.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/dma/async_tx.c |   12 ++++++------
 drivers/dma/iop-adma.c |   14 +++++++-------
 2 files changed, 13 insertions(+), 13 deletions(-)

--- linux-2.6.20-mm2/drivers/dma/iop-adma.c.old	2007-02-25 19:16:37.000000000 +0100
+++ linux-2.6.20-mm2/drivers/dma/iop-adma.c	2007-02-25 19:16:58.000000000 +0100
@@ -48,7 +48,7 @@
  * @slot: Slot to free
  * Caller must hold &iop_chan->lock while calling this function
  */
-static inline void iop_adma_free_slots(struct iop_adma_desc_slot *slot)
+static void iop_adma_free_slots(struct iop_adma_desc_slot *slot)
 {
 	int stride = slot->stride;
 
@@ -60,7 +60,7 @@
 	}
 }
 
-static inline dma_cookie_t
+static dma_cookie_t
 iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
 	struct iop_adma_chan *iop_chan, dma_cookie_t cookie)
 {
@@ -108,7 +108,7 @@
 	return cookie;
 }
 
-static inline int
+static int
 iop_adma_clean_slot(struct iop_adma_desc_slot *desc,
 	struct iop_adma_chan *iop_chan)
 {
@@ -260,7 +260,7 @@
 	}
 }
 
-static inline void
+static void
 iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 {
 	spin_lock_bh(&iop_chan->lock);
@@ -453,7 +453,7 @@
 	return (i > 0) ? i : -ENOMEM;
 }
 
-static inline dma_cookie_t
+static dma_cookie_t
 iop_desc_assign_cookie(struct iop_adma_chan *iop_chan,
 	struct iop_adma_desc_slot *desc)
 {
@@ -465,7 +465,7 @@
 	return cookie;
 }
 
-static inline void iop_adma_check_threshold(struct iop_adma_chan *iop_chan)
+static void iop_adma_check_threshold(struct iop_adma_chan *iop_chan)
 {
 	PRINTK("iop adma%d: pending: %d\n", iop_chan->device->id,
 		iop_chan->pending);
@@ -719,7 +719,7 @@
 	}
 }
 
-static inline void iop_adma_schedule_cleanup(unsigned long id)
+static void iop_adma_schedule_cleanup(unsigned long id)
 {
 	tasklet_schedule(iop_adma_tasklet[id]);
 }
--- linux-2.6.20-mm2/drivers/dma/async_tx.c.old	2007-02-25 19:17:06.000000000 +0100
+++ linux-2.6.20-mm2/drivers/dma/async_tx.c	2007-02-25 19:17:48.000000000 +0100
@@ -66,7 +66,7 @@
 	kfree(ref);
 }
 
-static inline void
+static void
 init_dma_chan_ref(struct dma_chan_ref *ref, struct dma_chan *chan)
 {
 	INIT_LIST_HEAD(&ref->async_node);
@@ -316,7 +316,7 @@
 	do { } while (0);
 }
 
-static inline struct dma_chan *
+static struct dma_chan *
 async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
 	enum dma_transaction_type tx_type)
 {
@@ -324,7 +324,7 @@
 }
 #endif
 
-static inline void
+static void
 async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
 	enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback callback, void *callback_param)
@@ -370,7 +370,7 @@
  * @callback: function to call when the transaction completes
  * @callback_param: parameter to pass to the callback routine
  */
-static inline void
+static void
 sync_epilog(unsigned long flags, struct dma_async_tx_descriptor *depend_tx,
 	dma_async_tx_callback callback, void *callback_param)
 {
@@ -381,7 +381,7 @@
 		async_tx_ack(depend_tx);
 }
 
-static inline void
+static void
 do_async_xor(struct dma_async_tx_descriptor *tx, struct dma_device *device,
 	struct dma_chan *chan, struct page *dest, struct page **src_list,
 	unsigned int offset, unsigned int src_cnt, size_t len,
@@ -413,7 +413,7 @@
 		callback_param);
 }
 
-static inline void
+static void
 do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	unsigned int src_cnt, size_t len, enum async_tx_flags flags,
 	struct dma_async_tx_descriptor *depend_tx,

