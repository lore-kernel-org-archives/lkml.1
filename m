Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZGKHv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZGKHv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 03:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZGKHvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 03:51:48 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59178 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbZGKHvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 03:51:47 -0400
Date: Sat, 11 Jul 2009 09:50:29 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: isdn@linux-pingi.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/5] drivers/isdn: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0907110950100.29592@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/isdn/hysdn/hysdn_net.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -u -p a/drivers/isdn/hysdn/hysdn_net.c b/drivers/isdn/hysdn/hysdn_net.c
--- a/drivers/isdn/hysdn/hysdn_net.c
+++ b/drivers/isdn/hysdn/hysdn_net.c
@@ -187,11 +187,12 @@ void
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
 
