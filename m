Return-Path: <linux-kernel-owner+w=401wt.eu-S933098AbXGQIY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbXGQIY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933224AbXGQIXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:23:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:63079 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802AbXGQIXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=A5QxXfMpNCf5To9hSWwC4eU6NoLNG+QAlY+Jr5Hz7IZEKerD7JS83XzY58/b5FboMCfx1s9ks2N7ycqlKnRUaYKeVGcvT12+a6Ko49E17Fxjqk8HhF2AyNhWwth9yRhMs2G6emIDFNAF8pravQNCLTrWe6LxP3deNA032bXjvg4=
From: Denis Cheng <crquan@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Denis Cheng <crquan@gmail.com>
Subject: [PATCH 2/4] [NET] make non-global function __dev_addr_discard static
Date: Tue, 17 Jul 2007 16:23:23 +0800
Message-Id: <1184660618735-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11846606051099-git-send-email-crquan@gmail.com>
References: <11846606051099-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

and remove its declaration in header file include/linux/netdevice.h

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 include/linux/netdevice.h |    1 -
 net/core/dev.c            |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 895cec2..b34975b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1110,7 +1110,6 @@ extern int		dev_mc_sync(struct net_device *to, struct net_device *from);
 extern void		dev_mc_unsync(struct net_device *to, struct net_device *from);
 extern int 		__dev_addr_delete(struct dev_addr_list **list, int *count, void *addr, int alen, int all);
 extern int		__dev_addr_add(struct dev_addr_list **list, int *count, void *addr, int alen, int newonly);
-extern void		__dev_addr_discard(struct dev_addr_list **list);
 extern void		dev_set_promiscuity(struct net_device *dev, int inc);
 extern void		dev_set_allmulti(struct net_device *dev, int inc);
 extern void		netdev_state_change(struct net_device *dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index b17f1bf..3ba63aa 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2715,7 +2715,7 @@ int __dev_addr_add(struct dev_addr_list **list, int *count,
 	return 0;
 }
 
-void __dev_addr_discard(struct dev_addr_list **list)
+static void __dev_addr_discard(struct dev_addr_list **list)
 {
 	struct dev_addr_list *tmp;
 
-- 
1.5.2.2

