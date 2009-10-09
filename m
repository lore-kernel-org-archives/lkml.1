Return-Path: <linux-kernel-owner+w=401wt.eu-S1761911AbZJIXnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761911AbZJIXnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761868AbZJIXnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:43:12 -0400
Received: from kroah.org ([198.145.64.141]:51493 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761712AbZJIXmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:42:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:34:40 2009
Message-Id: <20091009233440.786680001@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:34:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sascha Hlusiak <contact@saschahlusiak.de>,
       "Fred L. Templin" <Fred.L.Templin@boeing.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 37/37] sit: fix off-by-one in ipip6_tunnel_get_prl
References: <20091009233411.852013234@mini.kroah.org>
Content-Disposition: inline; filename=sit-fix-off-by-one-in-ipip6_tunnel_get_prl.patch
In-Reply-To: <20091009233812.GA15982@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sascha Hlusiak <contact@saschahlusiak.de>

[ Upstream commit 298bf12ddb25841804f26234a43b89da1b1c0e21 ]

When requesting all prl entries (kprl.addr == INADDR_ANY) and there are
more prl entries than there is space passed from userspace, the existing
code would always copy cmax+1 entries, which is more than can be handled.

This patch makes the kernel copy only exactly cmax entries.

Signed-off-by: Sascha Hlusiak <contact@saschahlusiak.de>
Acked-By: Fred L. Templin <Fred.L.Templin@boeing.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/sit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -313,7 +313,7 @@ static int ipip6_tunnel_get_prl(struct i
 
 	c = 0;
 	for (prl = t->prl; prl; prl = prl->next) {
-		if (c > cmax)
+		if (c >= cmax)
 			break;
 		if (kprl.addr != htonl(INADDR_ANY) && prl->addr != kprl.addr)
 			continue;


