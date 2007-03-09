Return-Path: <linux-kernel-owner+w=401wt.eu-S2993050AbXCIHWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993050AbXCIHWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993053AbXCIHWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:22:38 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:36612 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993050AbXCIHW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:22:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=igvyJ+C4HDbjMZ6rLhz5nqq2adXeqoKcZZE66zdTHdwtQRrJYZuo8mAiWEMugEQLHy0PIeqRh8jgibBOPHVi/ZFO2pIQtry66AacY0U6DcJbr4Y0LYjUGr/7rk1IAVSaUEuDNZnBgFPyccGywepV7gvAr/VCDh8l0OqpqESt0y0=
Date: Thu, 8 Mar 2007 23:22:15 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, akpm@osdl.org
Cc: netdev@vger.kernel.org
Subject: [PATCH] [REVISED] net/ipv4/multipath_wrandom.c: check kmalloc()
 return value.
Message-Id: <20070308232215.aa512aaa.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Check the return value of kmalloc() in function wrandom_set_nhinfo(), in file net/ipv4/multipath_wrandom.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/net/ipv4/multipath_wrandom.c b/net/ipv4/multipath_wrandom.c
index 92b0482..bcdb1f1 100644
--- a/net/ipv4/multipath_wrandom.c
+++ b/net/ipv4/multipath_wrandom.c
@@ -242,6 +242,9 @@ static void wrandom_set_nhinfo(__be32 ne
 		target_route = (struct multipath_route *)
 			kmalloc(size_rt, GFP_ATOMIC);
 
+		if (!target_route)
+			goto error;
+
 		target_route->gw = nh->nh_gw;
 		target_route->oif = nh->nh_oif;
 		memset(&target_route->rcu, 0, sizeof(struct rcu_head));
@@ -263,6 +266,9 @@ static void wrandom_set_nhinfo(__be32 ne
 		target_dest = (struct multipath_dest*)
 			kmalloc(size_dst, GFP_ATOMIC);
 
+		if (!target_dest)
+			goto error;
+
 		target_dest->nh_info = nh;
 		target_dest->network = network;
 		target_dest->netmask = netmask;
@@ -275,6 +281,7 @@ static void wrandom_set_nhinfo(__be32 ne
 	 * we are finished
 	 */
 
+ error:
 	spin_unlock_bh(&state[state_idx].lock);
 }
 
