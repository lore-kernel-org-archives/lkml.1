Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZHFPZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZHFPZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbZHFPZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:25:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44930 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbZHFPZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:25:00 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: socketcan-users@lists.berlios.de
Cc: linux-kernel@vger.kernel.org, Michael Olbrich <m.olbrich@pengutronix.de>,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH] CAN: make checking in can_rcv less restrictive
Date: Thu,  6 Aug 2009 17:24:55 +0200
Message-Id: <1249572295-7801-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Olbrich <m.olbrich@pengutronix.de>

Checking for can frame format in can_rcv() is too restrictive. BUG_ON is way too
heavy for the case that the can interface probably received a can frame with
malicious format. Further it can be used for DDOS attack since BUG_ON can lead
to kernel panic. Hence we turn this to WARN_ON instead.

Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 net/can/af_can.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index e733725..e6dcf4b 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -656,7 +656,7 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 		return 0;
 	}
 
-	BUG_ON(skb->len != sizeof(struct can_frame) || cf->can_dlc > 8);
+	WARN_ON(skb->len != sizeof(struct can_frame) || cf->can_dlc > 8);
 
 	/* update statistics */
 	can_stats.rx_frames++;
-- 
1.6.3.3

