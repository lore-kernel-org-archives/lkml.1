Return-Path: <linux-kernel-owner+w=401wt.eu-S1763985AbXJNSlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763985AbXJNSlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762221AbXJNSkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:40:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60404 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763923AbXJNSku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:40:50 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] hamradio: ->hard_header() takes packet type in host-endian
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com, davem@davemloft.net
Message-Id: <E1Ih8OP-0004BW-7d@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:40:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/hamradio/6pack.c |    2 +-
 drivers/net/hamradio/mkiss.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index ecd156d..ad9e327 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -292,7 +292,7 @@ static int sp_header(struct sk_buff *skb, struct net_device *dev,
 		     const void *saddr, unsigned len)
 {
 #ifdef CONFIG_INET
-	if (type != htons(ETH_P_AX25))
+	if (type != ETH_P_AX25)
 		return ax25_hard_header(skb, dev, type, daddr, saddr, len);
 #endif
 	return 0;
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 9e43c47..803a3bd 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -583,7 +583,7 @@ static int ax_header(struct sk_buff *skb, struct net_device *dev,
 		     const void *saddr, unsigned len)
 {
 #ifdef CONFIG_INET
-	if (type != htons(ETH_P_AX25))
+	if (type != ETH_P_AX25)
 		return ax25_hard_header(skb, dev, type, daddr, saddr, len);
 #endif
 	return 0;
-- 
1.5.3.GIT


