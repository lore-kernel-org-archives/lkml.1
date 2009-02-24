Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbZBXCkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbZBXCkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 21:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZBXCjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 21:39:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45888
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbZBXCjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 21:39:51 -0500
Date: Mon, 23 Feb 2009 18:39:35 -0800 (PST)
Message-Id: <20090223.183935.201291589.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] net: Fix build without CONFIG_NET_NS
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090224022734.1766BDDE1D@ozlabs.org>
References: <20090224022734.1766BDDE1D@ozlabs.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 24 Feb 2009 13:26:45 +1100

> Commit 486a87f1e5624096bd1c09e9e716239597d48dca broke build without
> CONFIG_NET_NS due to calling net_alloc_generic() always while defining
> it inside an #ifdef CONFIG_NET_NS block. This moves the function
> definition out of that block.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Yep, sorry about that.

commit ebe47d47b7b7fed72dabcce4717da727b4e2367d
Author: Clemens Noss <cnoss@gmx.de>
Date:   Mon Feb 23 15:37:35 2009 -0800

    netns: build fix for net_alloc_generic
    
    net_alloc_generic was defined in #ifdef CONFIG_NET_NS, but used
    unconditionally. Move net_alloc_generic out of #ifdef.
    
    Signed-off-by: Clemens Noss <cnoss@gmx.de>
    Signed-off-by: David S. Miller <davem@davemloft.net>

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
