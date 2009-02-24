Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZBXNAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZBXNAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZBXNAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:00:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:54571 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754256AbZBXNAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:00:34 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/5a+wQ8Hv5g+pTSIn3/IbkLIBY/cG9greqhdlcsW
	1mwVyx+Y+bk5uP
Subject: !CONFIG_NET_NS build error, net/core/net_namespace.c
From: Mike Galbraith <efault@gmx.de>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Feb 2009 14:00:27 +0100
Message-Id: <1235480427.5965.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  CC      net/core/net_namespace.o
net/core/net_namespace.c: In function ‘net_ns_init’:
net/core/net_namespace.c:223: error: implicit declaration of function ‘net_alloc_generic’
net/core/net_namespace.c:223: warning: assignment makes pointer from integer without a cast
make[2]: *** [net/core/net_namespace.o] Error 1
make[1]: *** [net/core] Error 2
make: *** [net] Error 2


Impact: fix !CONFIG_NET_NS net/core/net_namespace.c build error

Signed-off-by: Mike Galbraith <efault@gmx.de>

 net/core/net_namespace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index b0767ab..2adb1a7 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -63,10 +63,6 @@ out_undo:
 	goto out;
 }
 
-#ifdef CONFIG_NET_NS
-static struct kmem_cache *net_cachep;
-static struct workqueue_struct *netns_wq;
-
 static struct net_generic *net_alloc_generic(void)
 {
 	struct net_generic *ng;
@@ -80,6 +76,10 @@ static struct net_generic *net_alloc_generic(void)
 	return ng;
 }
 
+#ifdef CONFIG_NET_NS
+static struct kmem_cache *net_cachep;
+static struct workqueue_struct *netns_wq;
+
 static struct net *net_alloc(void)
 {
 	struct net *net = NULL;


