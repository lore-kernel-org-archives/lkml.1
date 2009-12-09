Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZLIT0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZLIT0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbZLITZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:25:57 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:54119 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757371AbZLITZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:25:55 -0500
Date: Wed, 9 Dec 2009 20:25:59 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "David S. Miller" <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 11/12] net/mac80211: Correct size given to memset
Message-ID: <Pine.LNX.4.64.0912092025240.1870@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Memset should be given the size of the structure, not the size of the pointer.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
expression E;
@@

memset(x, E, sizeof(
+ *
 x))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/mac80211/mesh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/net/mac80211/mesh.c b/Net/mac80211/mesh.c
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -427,7 +427,7 @@ int ieee80211_new_mesh_header(struct iee
 		char *addr5, char *addr6)
 {
 	int aelen = 0;
-	memset(meshhdr, 0, sizeof(meshhdr));
+	memset(meshhdr, 0, sizeof(*meshhdr));
 	meshhdr->ttl = sdata->u.mesh.mshcfg.dot11MeshTTL;
 	put_unaligned(cpu_to_le32(sdata->u.mesh.mesh_seqnum), &meshhdr->seqnum);
 	sdata->u.mesh.mesh_seqnum++;
