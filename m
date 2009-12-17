Return-Path: <linux-kernel-owner+w=401wt.eu-S965104AbZLQEci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104AbZLQEci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935126AbZLQEEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:34 -0500
Received: from kroah.org ([198.145.64.141]:55555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935572AbZLQEE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:28 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:51 2009
Message-Id: <20091217035651.312420775@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Javier Cardona <javier@cozybit.com>,
       Andrey Yurovsky <andrey@cozybit.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [065/151] mac80211: Fixed bug in mesh portal paths
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Javier Cardona <javier@cozybit.com>

commit 5d618cb81aeea19879975cd1f9a1e707694dfd7c upstream.

Paths to mesh portals were being timed out immediately after each use in
intermediate forwarding nodes.  mppath->exp_time is set to the expiration time
so assigning it to jiffies was marking the path as expired.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rx.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1514,7 +1514,6 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 			mpp_path_add(mesh_hdr->eaddr2, hdr->addr4, sdata);
 		} else {
 			spin_lock_bh(&mppath->state_lock);
-			mppath->exp_time = jiffies;
 			if (compare_ether_addr(mppath->mpp, hdr->addr4) != 0)
 				memcpy(mppath->mpp, hdr->addr4, ETH_ALEN);
 			spin_unlock_bh(&mppath->state_lock);


