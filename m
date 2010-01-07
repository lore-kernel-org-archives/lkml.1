Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583Ab0AGBtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab0AGBtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573Ab0AGBtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:49:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:16494 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab0AGBtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:49:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nNW/HYzrRHPZkvwHVLC0i6V8/OS/VGi7YrhJmQnDI7DTFndRN/fI+NllE/4PgRoJa4
         vTw0FsTNekfVbblMbXOAzgnW6l5u/4VnKCFbhDrceHe0/DnC5KZ/EMxZ1sMMfwijFMfQ
         COHc8GaJeZhsHkgn+vaGPK753igBirfytKAcY=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Armin Schindler <mac@melware.de>
Subject: [PATCH 3/4] ISDN: hysdn: avoid NULL pointer dereference
Date: Thu,  7 Jan 2010 04:48:40 +0300
Message-Id: <1262828921-29517-3-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262828921-29517-2-git-send-email-a.beregalov@gmail.com>
References: <1262828921-29517-1-git-send-email-a.beregalov@gmail.com>
 <1262828921-29517-2-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign dev only if lp is not NULL.

Cc: Armin Schindler <mac@melware.de>
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/isdn/hysdn/hysdn_net.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hysdn/hysdn_net.c b/drivers/isdn/hysdn/hysdn_net.c
index 72eb926..feec8d8 100644
--- a/drivers/isdn/hysdn/hysdn_net.c
+++ b/drivers/isdn/hysdn/hysdn_net.c
@@ -187,12 +187,13 @@ void
 hysdn_rx_netpkt(hysdn_card * card, unsigned char *buf, unsigned short len)
 {
 	struct net_local *lp = card->netif;
-	struct net_device *dev = lp->dev;
+	struct net_device *dev;
 	struct sk_buff *skb;
 
 	if (!lp)
 		return;		/* non existing device */
 
+	dev = lp->dev;
 	dev->stats.rx_bytes += len;
 
 	skb = dev_alloc_skb(len);
-- 
1.6.6

