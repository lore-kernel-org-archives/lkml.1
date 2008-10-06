Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbYJFJFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbYJFJFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 05:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYJFJF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 05:05:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:54463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbYJFJF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 05:05:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,366,1220252400"; 
   d="scan'208";a="623797014"
From: Tomas Winkler <tomas.winkler@intel.com>
To: marcel@holtmann.org
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] btsdio: fix tx error path
Date: Mon,  6 Oct 2008 11:05:14 +0200
Message-Id: <1223283914-18238-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.6.0.2.229.g1293c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes accumulating of the header
in case packet was requeued in the error path.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
---
 drivers/bluetooth/btsdio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
index 58630cc..e4724b8 100644
--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -91,6 +91,7 @@ static int btsdio_tx_packet(struct btsdio_data *data, struct sk_buff *skb)
 
 	err = sdio_writesb(data->func, REG_TDAT, skb->data, skb->len);
 	if (err < 0) {
+		skb_pop(skb, 4);
 		sdio_writeb(data->func, 0x01, REG_PC_WRT, NULL);
 		return err;
 	}
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

