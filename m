Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbXH0Vlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbXH0Vlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765558AbXH0V3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:29:36 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58873 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765542AbXH0V3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:29:35 -0400
Date: Mon, 27 Aug 2007 23:29:34 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, linville@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [-mm patch] iwl-base.c bugfixes
Message-ID: <20070827212934.GI26410@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc2-mm2:
>... 
>  git-wireless.patch
>...
>  git trees
>...

This patch fixes two obvious bugs.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/net/wireless/iwl-base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

600ffdc11b25ac0aee15271d1b2ce99a367efa31 
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index b8293fe..f65c30e 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -343,7 +343,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv,
 	 * command is very huge the system will not have two scan at the
 	 * same time */
 	len = sizeof(struct iwl_cmd) * slots_num;
-	if (txq_id == IWL_CMD_QUEUE_NUM);
+	if (txq_id == IWL_CMD_QUEUE_NUM)
 		len +=  IWL_MAX_SCAN_SIZE;
 	txq->cmd = pci_alloc_consistent(dev, len, &txq->dma_addr_cmd);
 	if (!txq->cmd)
@@ -390,7 +390,7 @@ void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 		iwl_hw_txq_free_tfd(priv, txq);
 
 	len = sizeof(struct iwl_cmd) * q->n_window;
-	if (q->id == IWL_CMD_QUEUE_NUM);
+	if (q->id == IWL_CMD_QUEUE_NUM)
 		len += IWL_MAX_SCAN_SIZE;
 
 	pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);

