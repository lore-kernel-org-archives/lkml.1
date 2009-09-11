Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbZIKA3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbZIKA3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZIKA27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:28:59 -0400
Received: from kroah.org ([198.145.64.141]:38034 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZIKA26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:28:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:09 2009
Message-Id: <20090911002409.373226576@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:22:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tom Goff <thomas.goff@boeing.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 03/22] gre: Fix MTU calculation for bound GRE tunnels
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=gre-fix-mtu-calculation-for-bound-gre-tunnels.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tom Goff <thomas.goff@boeing.com>

[ Upstream commit 8cdb045632e5ee22854538619ac6f150eb0a4894 ]

The GRE header length should be subtracted when the tunnel MTU is
calculated.  This just corrects for the associativity change
introduced by commit 42aa916265d740d66ac1f17290366e9494c884c2
("gre: Move MTU setting out of ipgre_tunnel_bind_dev").

Signed-off-by: Tom Goff <thomas.goff@boeing.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/ip_gre.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -952,7 +952,7 @@ static int ipgre_tunnel_bind_dev(struct 
 			addend += 4;
 	}
 	dev->needed_headroom = addend + hlen;
-	mtu -= dev->hard_header_len - addend;
+	mtu -= dev->hard_header_len + addend;
 
 	if (mtu < 68)
 		mtu = 68;


