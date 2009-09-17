Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbZIQHy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbZIQHy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZIQHy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:54:56 -0400
Received: from msa105lp.auone-net.jp ([222.3.140.168]:38299 "EHLO
	msa105lp.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZIQHyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:54:55 -0400
X-Greylist: delayed 1124 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2009 03:54:55 EDT
Date: Thu, 17 Sep 2009 16:36:13 +0900
From: Kusanagi Kouichi <slash@ma.neweb.ne.jp>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: tun: Return -EINVAL if neither IFF_TUN nor IFF_TAP is set.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Message-Id: <20090917073614.15217260031@msa105lp.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 2b980dbd77d229eb60588802162c9659726b11f4
("lsm: Add hooks to the TUN driver") tun_set_iff doesn't
return -EINVAL though neither IFF_TUN nor IFF_TAP is set.

Signed-off-by: Kusanagi Kouichi <slash@ma.neweb.ne.jp>
---
 drivers/net/tun.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3f5d288..e091756 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -946,8 +946,6 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		char *name;
 		unsigned long flags = 0;
 
-		err = -EINVAL;
-
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
 		err = security_tun_dev_create();
@@ -964,7 +962,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 			flags |= TUN_TAP_DEV;
 			name = "tap%d";
 		} else
-			goto failed;
+			return -EINVAL;
 
 		if (*ifr->ifr_name)
 			name = ifr->ifr_name;
-- 
1.6.4.3

