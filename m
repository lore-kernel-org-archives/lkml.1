Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZBKQRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZBKQRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbZBKQR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:17:26 -0500
Received: from mx1.emlix.com ([193.175.82.87]:47286 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718AbZBKQRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:17:25 -0500
X-Greylist: delayed 1809 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Feb 2009 11:17:25 EST
Date: Wed, 11 Feb 2009 16:47:19 +0100
From: Johannes Weiner <jw@emlix.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [patch][trivial] dmaengine: update kerneldoc
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Message-Id: <E1LXHIv-00021Q-Vm@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the kerneldoc comments in the dmaengine header describe
already removed structure members.  Remove them.

Also add a short description for dma_device->device_is_tx_complete.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 3e68469..087e79a 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -97,7 +97,6 @@ typedef struct { DECLARE_BITMAP(bits, DMA_TX_TYPE_END); } dma_cap_mask_t;
 
 /**
  * struct dma_chan_percpu - the per-CPU part of struct dma_chan
- * @refcount: local_t used for open-coded "bigref" counting
  * @memcpy_count: transaction counter
  * @bytes_transferred: byte counter
  */
@@ -114,9 +113,6 @@ struct dma_chan_percpu {
  * @cookie: last cookie value returned to client
  * @chan_id: channel ID for sysfs
  * @dev: class device for sysfs
- * @refcount: kref, used in "bigref" slow-mode
- * @slow_ref: indicates that the DMA channel is free
- * @rcu: the DMA channel's RCU head
  * @device_node: used to add this to the device chan list
  * @local: per-cpu pointer to a struct dma_chan_percpu
  * @client-count: how many clients are using this channel
@@ -211,8 +207,6 @@ struct dma_async_tx_descriptor {
  * @global_node: list_head for global dma_device_list
  * @cap_mask: one or more dma_capability flags
  * @max_xor: maximum number of xor sources, 0 if no capability
- * @refcount: reference count
- * @done: IO completion struct
  * @dev_id: unique device ID
  * @dev: struct device reference for dma mapping api
  * @device_alloc_chan_resources: allocate resources and return the
@@ -225,6 +219,7 @@ struct dma_async_tx_descriptor {
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
  * @device_prep_slave_sg: prepares a slave dma operation
  * @device_terminate_all: terminate all pending operations
+ * @device_is_tx_complete: poll for transaction completion
  * @device_issue_pending: push pending transactions to hardware
  */
 struct dma_device {
