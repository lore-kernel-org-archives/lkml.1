Return-Path: <linux-kernel-owner+w=401wt.eu-S932818AbZLGANo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818AbZLGANo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbZLGANl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:41 -0500
Received: from kroah.org ([198.145.64.141]:34571 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758534AbZLGANd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:33 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:54 2009
Message-Id: <20091207000654.000557851@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jasper Spaans <spaans@fox-it.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, Jay Vosburgh <fubar@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [076/119] bonding: Modify hash transmit policies to use the packets source MAC address
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=bonding-modify-hash-transmit-policies-to-use-the-packet-s-source-mac-address.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jasper Spaans <spaans@fox-it.com>

[ Upstream commit d3da68310a2cf934c2ea8a99a519d8b1ccca4c56 ]

Modify bonding hash transmit policies to use the psource MAC address of
the packet instead of the MAC address configured for the bonding device.

The old sitation conflicts with the documentation.

Signed-off-by: Jasper Spaans <spaans@fox-it.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/bonding/bond_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3707,10 +3707,10 @@ static int bond_xmit_hash_policy_l23(str
 
 	if (skb->protocol == htons(ETH_P_IP)) {
 		return ((ntohl(iph->saddr ^ iph->daddr) & 0xffff) ^
-			(data->h_dest[5] ^ bond_dev->dev_addr[5])) % count;
+			(data->h_dest[5] ^ data->h_source[5])) % count;
 	}
 
-	return (data->h_dest[5] ^ bond_dev->dev_addr[5]) % count;
+	return (data->h_dest[5] ^ data->h_source[5]) % count;
 }
 
 /*
@@ -3737,7 +3737,7 @@ static int bond_xmit_hash_policy_l34(str
 
 	}
 
-	return (data->h_dest[5] ^ bond_dev->dev_addr[5]) % count;
+	return (data->h_dest[5] ^ data->h_source[5]) % count;
 }
 
 /*
@@ -3748,7 +3748,7 @@ static int bond_xmit_hash_policy_l2(stru
 {
 	struct ethhdr *data = (struct ethhdr *)skb->data;
 
-	return (data->h_dest[5] ^ bond_dev->dev_addr[5]) % count;
+	return (data->h_dest[5] ^ data->h_source[5]) % count;
 }
 
 /*-------------------------- Device entry points ----------------------------*/


