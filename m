Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbXKWJ4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbXKWJ4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 04:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbXKWJ4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 04:56:03 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:48341 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbXKWJz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 04:55:59 -0500
X-IronPort-AV: i="4.21,455,1188792000"; 
   d="scan'208"; a="56897905:sNHT25724699"
From: Bryan Wu <bryan.wu@analog.com>
To: jeff@garzik.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Vitja Makarov <vitja.makarov@gmail.com>,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 2/2] Blackfin EMAC driver: fix bug - NAT doesn't work with bfin_mac driver
Date: Fri, 23 Nov 2007 17:55:51 +0800
Message-Id: <1195811751-25319-3-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1195811751-25319-1-git-send-email-bryan.wu@analog.com>
References: <1195811751-25319-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitja Makarov <vitja.makarov@gmail.com>

https://blackfin.uclinux.org/gf/project/uclinux-dist/forum/?action=ForumBrowse&forum_id=39&thread_id=23114&_forum_action=ForumMessageBrowse
Today I was dealing with the same problem, on my custom bf537 board, and bfin_mac driver.
I found that the problem is in setting ip_summed flag of skbuff structure,

Signed-off-by: Vitja Makarov <vitja.makarov@gmail.com>
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/net/bfin_mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 0b99b55..eb97175 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -676,7 +676,7 @@ static void bf537mac_rx(struct net_device *dev)
 	skb->protocol = eth_type_trans(skb, dev);
 #if defined(BFIN_MAC_CSUM_OFFLOAD)
 	skb->csum = current_rx_ptr->status.ip_payload_csum;
-	skb->ip_summed = CHECKSUM_PARTIAL;
+	skb->ip_summed = CHECKSUM_COMPLETE;
 #endif
 
 	netif_rx(skb);
-- 
1.5.3.4
