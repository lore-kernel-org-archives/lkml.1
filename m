Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbZHMUEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbZHMUEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932263AbZHMT77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:59 -0400
Received: from kroah.org ([198.145.64.141]:41875 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240AbZHMT7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:32 2009
Message-Id: <20090813195132.153955097@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>, Jie Yang <jie.yang@atheros.com>,
       Jay Cliburn <jcliburn@gmail.com>, Chris Snook <csnook@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 51/74] atl1c: WAKE_MCAST tested twice, not WAKE_UCAST
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=atl1c-wake_mcast-tested-twice-not-wake_ucast.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit 0ed586d075ef65c0268982e5b7f36d0ffaa95547 upstream.

The WAKE_MCAST bit is tested twice, the first should be WAKE_UCAST.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jie Yang <jie.yang@atheros.com>
Cc: Jay Cliburn <jcliburn@gmail.com>
Cc: Chris Snook <csnook@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atl1c/atl1c_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/atl1c/atl1c_ethtool.c
+++ b/drivers/net/atl1c/atl1c_ethtool.c
@@ -271,7 +271,7 @@ static int atl1c_set_wol(struct net_devi
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 
 	if (wol->wolopts & (WAKE_ARP | WAKE_MAGICSECURE |
-			    WAKE_MCAST | WAKE_BCAST | WAKE_MCAST))
+			    WAKE_UCAST | WAKE_BCAST | WAKE_MCAST))
 		return -EOPNOTSUPP;
 	/* these settings will always override what we currently have */
 	adapter->wol = 0;


