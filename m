Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbZLZMiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbZLZMiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 07:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZLZMix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 07:38:53 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62952 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbZLZMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 07:38:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=OQCBGte7v3JSuFPPrbRBIinwfzExrUD7AgrIul+2p/BpmDaiRzRd7qfSqF9yKoPriB
         rU5eOH1h8jwh4EJRsv0YNNMMZkIMeF+lu/VrM3NBw2WVV38Ab5P7UPRGYPShdCsDSHOa
         hUDuFVVJUeLjLHPYdyJLBZvdEth0QGLamFD8M=
Date: Sat, 26 Dec 2009 14:38:12 +0200
From: Dan Carpenter <error27@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] hamradio: avoid null deref v2
Message-ID: <20091226123812.GB6075@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jarek Poplawski <jarkao2@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20091223132550.GD17923@bicker> <4B3257C2.2050500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3257C2.2050500@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bump the stats on the original dev not on the newly assigned NULL version of
dev.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/net/hamradio/bpqether.c	2009-12-22 23:58:56.000000000 +0200
+++ devel/drivers/net/hamradio/bpqether.c	2009-12-25 19:49:05.000000000 +0200
@@ -282,11 +282,12 @@ static netdev_tx_t bpq_xmit(struct sk_bu
 
 	bpq = netdev_priv(dev);
 
-	if ((dev = bpq_get_ether_dev(dev)) == NULL) {
+	if (!bpq->ethdev) {
 		dev->stats.tx_dropped++;
 		kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
+	dev = bpq_get_ether_dev(dev);
 
 	skb->protocol = ax25_type_trans(skb, dev);
 	skb_reset_network_header(skb);
