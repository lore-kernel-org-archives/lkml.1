Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0BWB0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:26:53 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58760 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab0BWB0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:26:52 -0500
Date: Tue, 23 Feb 2010 12:26:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "Wey-Yi Guy" <wey-yi.w.guy@intel.com>
Subject: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-Id: <20100223122649.34f7d0bb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi "John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-core.h between commit
a239a8b47cc0e5e6d7416a89f340beac06d5edaa ("iwlwifi: error checking for
number of tfds in queue") from the wireless-current tree and commit
7bfedc59ee350727b115bbc79780c69b114f162d ("iwlwifi: cleanup return
values") from the wireless tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/iwl-core.h
index 1b0701b,3df7933..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@@ -450,9 -451,7 +451,9 @@@ int iwl_tx_skb(struct iwl_priv *priv, s
  void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
  int iwl_hw_tx_queue_init(struct iwl_priv *priv,
  			 struct iwl_tx_queue *txq);
- int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+ void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 +void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 +			    int sta_id, int tid, int freed);
  int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
  		      int slots_num, u32 txq_id);
  void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id);
