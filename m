Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbYEDS7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbYEDS7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757935AbYEDS71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:59:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:9090 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707AbYEDS70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=IY9TOtbadqQOwUrrRh00Ti4M6eIQGKkG+p2Vw9MMiaZwZ/i8qEiX/XVPFM5DJGg4bs9EqpiC6IP18objroI+x2HiFlOWGDgiWjvXqYwRDzMwnPav1udWpd+KOYrYpgvxCzDS5CKmP/jOwvic8nxDmLVt21n8P2wZAx7ClfrBicA=
Date: Mon, 5 May 2008 00:29:13 +0530
From: Pradeep Singh Rautela <rautelap@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rautelap@gmail.com, akpm@linux-foundation.org,
       linux-netdev@vger.kernel.org
Subject: [PATCH] fc: Fix fc.c to adhere to kernel Coding style
Message-ID: <20080504185913.GA13605@kernelpanic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net: fc.c does not strictly adheres to kernel coding style.
Fix it by changing some occurences of

 	if
 	{
 		...;
 	}
 	else
 	{
 		...;
 	}

   to

	if {
		...;
	} else {
		...;
	}

Signed-off-by: Pradeep Singh <rautelap@gmail.com>
---
 net/802/fc.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/802/fc.c b/net/802/fc.c
index cb3475e..7062605 100644
--- a/net/802/fc.c
+++ b/net/802/fc.c
@@ -44,8 +44,7 @@ static int fc_header(struct sk_buff *skb, struct net_device *dev,
 	 * Add the 802.2 SNAP header if IP as the IPv4 code calls
 	 * dev->hard_header directly.
 	 */
-	if (type == ETH_P_IP || type == ETH_P_ARP)
-	{
+	if (type == ETH_P_IP || type == ETH_P_ARP) {
 		struct fcllc *fcllc;
 
 		hdr_len = sizeof(struct fch_hdr) + sizeof(struct fcllc);
@@ -55,9 +54,7 @@ static int fc_header(struct sk_buff *skb, struct net_device *dev,
 		fcllc->llc = UI_CMD;
 		fcllc->protid[0] = fcllc->protid[1] = fcllc->protid[2] = 0x00;
 		fcllc->ethertype = htons(type);
-	}
-	else
-	{
+	} else {
 		hdr_len = sizeof(struct fch_hdr);
 		fch = (struct fch_hdr *)skb_push(skb, hdr_len);
 	}
@@ -67,8 +64,7 @@ static int fc_header(struct sk_buff *skb, struct net_device *dev,
 	else
 		memcpy(fch->saddr,dev->dev_addr,dev->addr_len);
 
-	if(daddr)
-	{
+	if (daddr) {
 		memcpy(fch->daddr,daddr,dev->addr_len);
 		return(hdr_len);
 	}
-- 
1.5.5.1

