Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651Ab0AEUOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0AEUOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621Ab0AEUOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:14:32 -0500
Received: from kroah.org ([198.145.64.141]:49947 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab0AEUGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:08 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:02:59 2010
Message-Id: <20100105200259.864447568@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Zhu Yi <yi.zhu@intel.com>, "John W. Linville" <linville@tuxdriver.com>
Subject: [07/39] iwmc3200wifi: fix array out-of-boundary access
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhu Yi <yi.zhu@intel.com>

commit 6c853da3f30c93eae847ecbcd9fdf10ba0da04c2 upstream.

Allocate priv->rx_packets[IWM_RX_ID_HASH + 1] because the max array
index is IWM_RX_ID_HASH according to IWM_RX_ID_GET_HASH().

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwmc3200wifi/iwm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -268,7 +268,7 @@ struct iwm_priv {
 
 	struct sk_buff_head rx_list;
 	struct list_head rx_tickets;
-	struct list_head rx_packets[IWM_RX_ID_HASH];
+	struct list_head rx_packets[IWM_RX_ID_HASH + 1];
 	struct workqueue_struct *rx_wq;
 	struct work_struct rx_worker;
 


