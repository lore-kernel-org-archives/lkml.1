Return-Path: <linux-kernel-owner+w=401wt.eu-S1761992AbYEUAcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761992AbYEUAcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763373AbYEUAbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:31:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45299 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759293AbYEUAbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:31:12 -0400
To: mchehab@infradead.org
Subject: [PATCH] dvb_net: endianness annotations
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycEZ-0004mH-QR@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:31:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/dvb-core/dvb_net.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index 56d871c..c2334ae 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -168,7 +168,7 @@ struct dvb_net_priv {
  *  stolen from eth.c out of the linux kernel, hacked for dvb-device
  *  by Michael Holzt <kju@debian.org>
  */
-static unsigned short dvb_net_eth_type_trans(struct sk_buff *skb,
+static __be16 dvb_net_eth_type_trans(struct sk_buff *skb,
 				      struct net_device *dev)
 {
 	struct ethhdr *eth;
@@ -277,10 +277,10 @@ static int handle_one_ule_extension( struct dvb_net_priv *p )
 			if(ext_len >= 0) {
 				p->ule_next_hdr += ext_len;
 				if (!p->ule_bridged) {
-					p->ule_sndu_type = ntohs(*(unsigned short *)p->ule_next_hdr);
+					p->ule_sndu_type = ntohs(*(__be16 *)p->ule_next_hdr);
 					p->ule_next_hdr += 2;
 				} else {
-					p->ule_sndu_type = ntohs(*(unsigned short *)(p->ule_next_hdr + ((p->ule_dbit ? 2 : 3) * ETH_ALEN)));
+					p->ule_sndu_type = ntohs(*(__be16 *)(p->ule_next_hdr + ((p->ule_dbit ? 2 : 3) * ETH_ALEN)));
 					/* This assures the extension handling loop will terminate. */
 				}
 			}
@@ -294,7 +294,7 @@ static int handle_one_ule_extension( struct dvb_net_priv *p )
 		if (ule_optional_ext_handlers[htype])
 			(void)ule_optional_ext_handlers[htype]( p );
 		p->ule_next_hdr += ext_len;
-		p->ule_sndu_type = ntohs( *(unsigned short *)(p->ule_next_hdr-2) );
+		p->ule_sndu_type = ntohs( *(__be16 *)(p->ule_next_hdr-2) );
 		/*
 		 * note: the length of the next header type is included in the
 		 * length of THIS optional extension header
@@ -594,8 +594,8 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 		/* Check for complete payload. */
 		if (priv->ule_sndu_remain <= 0) {
 			/* Check CRC32, we've got it in our skb already. */
-			unsigned short ulen = htons(priv->ule_sndu_len);
-			unsigned short utype = htons(priv->ule_sndu_type);
+			__be16 ulen = htons(priv->ule_sndu_len);
+			__be16 utype = htons(priv->ule_sndu_type);
 			const u8 *tail;
 			struct kvec iov[3] = {
 				{ &ulen, sizeof ulen },
-- 
1.5.3.GIT


