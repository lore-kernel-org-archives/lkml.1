Return-Path: <linux-kernel-owner+w=401wt.eu-S965026AbXCGM3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965026AbXCGM3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 07:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965094AbXCGM3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 07:29:46 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:38845 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965026AbXCGM3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 07:29:45 -0500
Message-ID: <45EEB011.5020606@freedesktop.org>
Date: Wed, 07 Mar 2007 04:29:05 -0800
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Icedove 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Allow pktgen to work with loopback devices.
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pktgen currently only works on network devices with type ARPHRD_ETHER.  Add
support for the loopback device, type ARPHRD_LOOPBACK.

I've tested this on my system, using a modified pktgen.conf-1-1 with
s/eth1/lo/g, and it works fine; the network device statistics confirm packet
transmission and receipt.

Thanks to Sarah Bailey for discovering and tracking down the problem.

Signed-off-by: Josh Triplett <josh@freedesktop.org>
---

I intentionally didn't change the error message "not an ethernet device".  For
the purposes of pktgen, loopback devices act like ethernet devices.

 net/core/pktgen.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 74a9a32..6fc6f9d 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1930,7 +1930,7 @@ static struct net_device *pktgen_setup_dev(struct pktgen_dev *pkt_dev)
 		printk("pktgen: no such netdevice: \"%s\"\n", pkt_dev->ifname);
 		goto out;
 	}
-	if (odev->type != ARPHRD_ETHER) {
+	if (odev->type != ARPHRD_LOOPBACK && odev->type != ARPHRD_ETHER) {
 		printk("pktgen: not an ethernet device: \"%s\"\n",
 		       pkt_dev->ifname);
 		goto out_put;
-- 
1.5.0.2

