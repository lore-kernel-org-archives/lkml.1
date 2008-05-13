Return-Path: <linux-kernel-owner+w=401wt.eu-S1761491AbYEMUdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbYEMUdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758892AbYEMUcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:32:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:5599 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671AbYEMUcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:32:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=KflSHIjjbrqV+t5NZ7JGh6cQPp5oAJre67p6eZw91DN8SkMsjP4cfJN8vlZG+TG6XZlqHZ5EiCfNniNGltL1KNBs1VfJhkjZza50h9YQvIWSVuVmZpWT9VP13Gxxkhy0F4Obrzs8jj6EbOs0ehVkLT29Q+COZ40dQtP1+qfIttU=
Message-ID: <4829FAF0.2040403@gmail.com>
Date: Tue, 13 May 2008 22:32:48 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: sorbica@icplus.com.tw, jesse@icplus.com.tw
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: ipg: fix receivemode IPG_RM_RECEIVEMULTICAST{,HASH}
 in ipg_nic_set_multicast_list()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The branches are dead code. even when dev->flag IFF_MULTICAST (defined 0x1000)
is set, dev->flags & IFF_MULTICAST & [boolean] always evaluates to 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/ipg.c b/drivers/net/ipg.c
index 9b358f6..679a082 100644
--- a/drivers/net/ipg.c
+++ b/drivers/net/ipg.c
@@ -577,12 +577,12 @@ static void ipg_nic_set_multicast_list(struct net_device *dev)
 		/* NIC to be configured in promiscuous mode. */
 		receivemode = IPG_RM_RECEIVEALLFRAMES;
 	} else if ((dev->flags & IFF_ALLMULTI) ||
-		   (dev->flags & IFF_MULTICAST &
+		   ((dev->flags & IFF_MULTICAST) &&
 		    (dev->mc_count > IPG_MULTICAST_HASHTABLE_SIZE))) {
 		/* NIC to be configured to receive all multicast
 		 * frames. */
 		receivemode |= IPG_RM_RECEIVEMULTICAST;
-	} else if (dev->flags & IFF_MULTICAST & (dev->mc_count > 0)) {
+	} else if ((dev->flags & IFF_MULTICAST) && (dev->mc_count > 0)) {
 		/* NIC to be configured to receive selected
 		 * multicast addresses. */
 		receivemode |= IPG_RM_RECEIVEMULTICASTHASH;
