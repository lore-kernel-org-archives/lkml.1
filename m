Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZIKAek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZIKAek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZIKAej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:34:39 -0400
Received: from kroah.org ([198.145.64.141]:33156 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbZIKAdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:33:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:30:39 2009
Message-Id: <20090911003038.870978807@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:29:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 2/4] net: net_assign_generic() fix
References: <20090911002923.745284267@mini.kroah.org>
Content-Disposition: inline; filename=net-net_assign_generic-fix.patch
In-Reply-To: <20090911003124.GA12842@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 144586301f6af5ae5943a002f030d8c626fa4fdd ]

memcpy() should take into account size of pointers,
not only number of pointers to copy.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/net_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -446,7 +446,7 @@ int net_assign_generic(struct net *net, 
 
 	ng->len = id;
 	INIT_RCU_HEAD(&ng->rcu);
-	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len);
+	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len * sizeof(void*));
 
 	rcu_assign_pointer(net->gen, ng);
 	call_rcu(&old_ng->rcu, net_generic_release);


