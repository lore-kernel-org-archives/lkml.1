Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbYCZKM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbYCZKM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYCZKMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:12:48 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:51009 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYCZKMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:12:47 -0400
X-IronPort-AV: E=Sophos;i="4.25,557,1199682000"; 
   d="scan'208";a="65082082"
From: Bryan Wu <cooloney@kernel.org>
To: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] [NETDEV] smc91x driver: Fix bug - Print warning only in interrupt mode.
Date: Wed, 26 Mar 2008 18:12:46 -0700
Message-Id: <1206580366-22966-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3956

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/net/smc91x.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
index 4020e9e..63a54e2 100644
--- a/drivers/net/smc91x.c
+++ b/drivers/net/smc91x.c
@@ -1326,9 +1326,11 @@ static irqreturn_t smc_interrupt(int irq, void *dev_id)
 	SMC_SET_INT_MASK(mask);
 	spin_unlock(&lp->lock);
 
+#ifndef CONFIG_NET_POLL_CONTROLLER
 	if (timeout == MAX_IRQ_LOOPS)
 		PRINTK("%s: spurious interrupt (mask = 0x%02x)\n",
 		       dev->name, mask);
+#endif
 	DBG(3, "%s: Interrupt done (%d loops)\n",
 	       dev->name, MAX_IRQ_LOOPS - timeout);
 
-- 
1.5.4.3
