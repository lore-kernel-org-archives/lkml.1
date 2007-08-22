Return-Path: <linux-kernel-owner+w=401wt.eu-S1762571AbXHVJDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762571AbXHVJDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758725AbXHVIxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:35 -0400
Received: from 1wt.eu ([62.212.114.60]:2099 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758651AbXHVIxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:32 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084036.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:31 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
       Marcus Meissner <meissner@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 47/58] IPV6: /proc/net/anycast6 unbalanced inet6_dev refcnt
Content-Disposition: inline; filename=0047-IPV6-proc-net-anycast6-unbalanced-inet6_dev-refcnt.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reading /proc/net/anycast6 when there is no anycast address
on an interface results in an ever-increasing inet6_dev reference
count, as well as a reference to the netdevice you can't get rid of.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Marcus Meissner <meissner@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv6/anycast.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
index fe0c895..7cf5248 100644
--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -67,6 +67,7 @@ ip6_onlink(struct in6_addr *addr, struct net_device *dev)
 				break;
 		}
 		read_unlock_bh(&idev->lock);
+		in6_dev_put(idev);
 	}
 	rcu_read_unlock();
 	return onlink;
-- 
1.5.2.5

-- 
