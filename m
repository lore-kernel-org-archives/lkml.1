Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZLWN0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZLWN0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 08:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbZLWN0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 08:26:17 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:46043 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbZLWN0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 08:26:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=ABZl35++284PVgDlVq1h21ioUMJPeCD70/g79jNnMlnMQpWEjByimng83oOW6be/la
         TC53s9yPiSTyAiXtz9B0vQICu7b7NvtVKdNtpJZYNRjwhVbwsrcG/ef4JkLRHX7AWog5
         /eevsdFyokTtAwbSwjzyBjbH77agnTfyXaxEM=
Date: Wed, 23 Dec 2009 15:25:50 +0200
From: Dan Carpenter <error27@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch] hamradio: avoid null deref
Message-ID: <20091223132550.GD17923@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If dev == NULL we shouldn't dereference it.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/net/hamradio/bpqether.c	2009-12-22 23:58:56.000000000 +0200
+++ devel/drivers/net/hamradio/bpqether.c	2009-12-22 23:59:46.000000000 +0200
@@ -283,7 +283,6 @@ static netdev_tx_t bpq_xmit(struct sk_bu
 	bpq = netdev_priv(dev);
 
 	if ((dev = bpq_get_ether_dev(dev)) == NULL) {
-		dev->stats.tx_dropped++;
 		kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
