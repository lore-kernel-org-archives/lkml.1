Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbYGQCCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbYGQCCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 22:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbYGQCCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 22:02:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60037 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbYGQCCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 22:02:37 -0400
Message-ID: <487EA7D2.6080706@cn.fujitsu.com>
Date: Thu, 17 Jul 2008 10:00:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] async_tx: list_for_each_entry_rcu() cleanup
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the rcu update side, don't use list_for_each_entry_rcu().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 crypto/async_tx/async_tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 095c798..17834e5 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -295,7 +295,7 @@ dma_channel_add_remove(struct dma_client *client,
 	case DMA_RESOURCE_REMOVED:
 		found = 0;
 		spin_lock_irqsave(&async_tx_lock, flags);
-		list_for_each_entry_rcu(ref, &async_tx_master_list, node)
+		list_for_each_entry(ref, &async_tx_master_list, node)
 			if (ref->chan == chan) {
 				/* permit backing devices to go away */
 				dma_chan_put(ref->chan);
-- 
1.5.4.rc3

