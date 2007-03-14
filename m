Return-Path: <linux-kernel-owner+w=401wt.eu-S1030818AbXCNJUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030818AbXCNJUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030812AbXCNJUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:20:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60515 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030811AbXCNJUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:20:13 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 14/17] atl1 trivial endianness misannotations
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1HRPeU-0003a3-2G@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:20:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


NB: driver is choke-full of code that will break on big-endian; as long
as the hardware is onboard-only we can live with that, but sooner or
later that'll need fixing.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/atl1/atl1_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
index 88d4f70..dee3638 100644
--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -1328,7 +1328,7 @@ static int atl1_tx_csum(struct atl1_adapter *adapter, struct sk_buff *skb,
 
 	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
 		cso = skb->h.raw - skb->data;
-		css = (skb->h.raw + skb->csum) - skb->data;
+		css = (skb->h.raw + skb->csum_offset) - skb->data;
 		if (unlikely(cso & 0x1)) {
 			printk(KERN_DEBUG "%s: payload offset != even number\n",
 				atl1_driver_name);
@@ -1562,7 +1562,7 @@ static int atl1_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 	/* mss will be nonzero if we're doing segment offload (TSO/GSO) */
 	mss = skb_shinfo(skb)->gso_size;
 	if (mss) {
-		if (skb->protocol == ntohs(ETH_P_IP)) {
+		if (skb->protocol == htons(ETH_P_IP)) {
 			proto_hdr_len = ((skb->h.raw - skb->data) +
 					 (skb->h.th->doff << 2));
 			if (unlikely(proto_hdr_len > len)) {
-- 
1.5.0-rc2.GIT


