Return-Path: <linux-kernel-owner+w=401wt.eu-S964822AbZJIXmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822AbZJIXmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932741AbZJIXmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:42:14 -0400
Received: from kroah.org ([198.145.64.141]:51444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934530AbZJIXmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:42:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:34:39 2009
Message-Id: <20091009233439.813028112@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:34:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kusanagi Kouichi <slash@ma.neweb.ne.jp>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 29/37] tun: Return -EINVAL if neither IFF_TUN nor IFF_TAP is set.
References: <20091009233411.852013234@mini.kroah.org>
Content-Disposition: inline; filename=tun-return-einval-if-neither-iff_tun-nor-iff_tap-is-set.patch
In-Reply-To: <20091009233812.GA15982@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kusanagi Kouichi <slash@ma.neweb.ne.jp>

[ Upstream commit 36989b90879c785f95b877bdcf65a2527dadd893 ]

After commit 2b980dbd77d229eb60588802162c9659726b11f4
("lsm: Add hooks to the TUN driver") tun_set_iff doesn't
return -EINVAL though neither IFF_TUN nor IFF_TAP is set.

Signed-off-by: Kusanagi Kouichi <slash@ma.neweb.ne.jp>
Reviewed-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/tun.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -943,8 +943,6 @@ static int tun_set_iff(struct net *net, 
 		char *name;
 		unsigned long flags = 0;
 
-		err = -EINVAL;
-
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
 
@@ -958,7 +956,7 @@ static int tun_set_iff(struct net *net, 
 			flags |= TUN_TAP_DEV;
 			name = "tap%d";
 		} else
-			goto failed;
+			return -EINVAL;
 
 		if (*ifr->ifr_name)
 			name = ifr->ifr_name;


