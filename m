Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZIKA3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZIKA3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZIKA3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:29:09 -0400
Received: from kroah.org ([198.145.64.141]:38052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbZIKA3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:01 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:09 2009
Message-Id: <20090911002409.803547267@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:22:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 06/22] net: net_assign_generic() fix
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=net-net_assign_generic-fix.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

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
@@ -498,7 +498,7 @@ int net_assign_generic(struct net *net, 
 	 */
 
 	ng->len = id;
-	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len);
+	memcpy(&ng->ptr, &old_ng->ptr, old_ng->len * sizeof(void*));
 
 	rcu_assign_pointer(net->gen, ng);
 	call_rcu(&old_ng->rcu, net_generic_release);


