Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYERSj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYERSj4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbYERShz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:37:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:13326 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbYERShy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=C10O2pwrfEpG00pktWLIzyOoYSsAZQgPrZJaK9BL5tMEQ5AU/WkP2GpEOHeAHq+VPK7Jln3SYGh3++VShCxSOoMKiBsUe0khR9wnzIe2NXXxQt82lRgUJwThbsqdV/zYOaGxG6t4wXifavumNMRVJTrrUPTxpI5VHyyxlRqxs1s=
From: Denis Cheng <crquan@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] net/ipv4/arp.c: Use the exported hex_asc from lib/hexdump.c instead
Date: Mon, 19 May 2008 02:37:44 +0800
Message-Id: <1211135864-8235-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here the local hexbuf is a duplicate of global const char hex_asc from
lib/hexdump.c, except the hex letters' cases:

const char hexbuf[] = "0123456789ABCDEF";

const char hex_asc[] = "0123456789abcdef";

and here to print HW addresses, the hex cases are not significant.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/ipv4/arp.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 418862f..f460fa0 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1288,7 +1288,6 @@ static void arp_format_neigh_entry(struct seq_file *seq,
 				   struct neighbour *n)
 {
 	char hbuffer[HBUFFERLEN];
-	const char hexbuf[] = "0123456789ABCDEF";
 	int k, j;
 	char tbuf[16];
 	struct net_device *dev = n->dev;
@@ -1302,8 +1301,8 @@ static void arp_format_neigh_entry(struct seq_file *seq,
 	else {
 #endif
 	for (k = 0, j = 0; k < HBUFFERLEN - 3 && j < dev->addr_len; j++) {
-		hbuffer[k++] = hexbuf[(n->ha[j] >> 4) & 15];
-		hbuffer[k++] = hexbuf[n->ha[j] & 15];
+		hbuffer[k++] = hex_asc[(n->ha[j] >> 4) & 15];
+		hbuffer[k++] = hex_asc[n->ha[j] & 15];
 		hbuffer[k++] = ':';
 	}
 	hbuffer[--k] = 0;
-- 
1.5.5.1

