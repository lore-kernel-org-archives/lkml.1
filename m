Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbZEEMuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbZEEMuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 08:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbZEEMtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 08:49:53 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15934 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZEEMtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 08:49:53 -0400
Message-Id: <4A00525C.76EA.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 05 May 2009 13:51:08 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <ilw@linux.intel.com>
Cc: <reinette.chatre@intel.com>, <linville@tuxdriver.com>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] iwl3945: fix ia64/ppc build
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exporting static and non-static symbols in the same compilation unit
results, on some architectures, in section mismatch errors from the
compiler. Since exporting static symbols is bogus altogether, simply
remove the offending export. Once at it, also remove the other export
commit df833b1d73680f9f9dc72cbc3215edbbc6ab740d pointlessly added.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>

---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.30-rc4/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-30 09:42:55.000000000 +0200
+++ 2.6.30-rc4-iwl3945-build/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-05-05 14:25:43.000000000 +0200
@@ -1694,7 +1694,6 @@ void iwl3945_rx_queue_reset(struct iwl_p
 	rxq->free_count = 0;
 	spin_unlock_irqrestore(&rxq->lock, flags);
 }
-EXPORT_SYMBOL(iwl3945_rx_queue_reset);
 
 /*
  * this should be called while priv->lock is locked
@@ -1745,7 +1744,6 @@ static void iwl3945_rx_queue_free(struct
 	rxq->bd = NULL;
 	rxq->rb_stts  = NULL;
 }
-EXPORT_SYMBOL(iwl3945_rx_queue_free);
 
 
 /* Convert linear signal-to-noise ratio into dB */



