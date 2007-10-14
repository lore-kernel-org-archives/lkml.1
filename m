Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbXJNSUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbXJNSUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbXJNSUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:20:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51453 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbXJNSUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:20:39 -0400
Date: Sun, 14 Oct 2007 19:20:30 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: davem@davemloft.net, jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: [PATCH] skb->tail in ibm_newemac should be skb_tail_pointer()
Message-ID: <20071014182030.GW8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

... since that sucker is not 32bit-only and on 64bit skb->tail is an
offset, not a pointer.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/ibm_newemac/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ibm_newemac/core.c b/drivers/net/ibm_newemac/core.c
index 8ea5009..7a5aabd 100644
--- a/drivers/net/ibm_newemac/core.c
+++ b/drivers/net/ibm_newemac/core.c
@@ -1534,7 +1534,7 @@ static inline int emac_rx_sg_append(struct emac_instance *dev, int slot)
 			dev_kfree_skb(dev->rx_sg_skb);
 			dev->rx_sg_skb = NULL;
 		} else {
-			cacheable_memcpy(dev->rx_sg_skb->tail,
+			cacheable_memcpy(skb_tail_pointer(dev->rx_sg_skb),
 					 dev->rx_skb[slot]->data, len);
 			skb_put(dev->rx_sg_skb, len);
 			emac_recycle_rx_skb(dev, slot, len);
-- 
1.5.3.GIT

