Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0BAPOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:14:50 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:55475 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab0BAPOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:14:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rg7cI97cYoI2epB1JpZrAG8W9l9dM8J45I7G+Wsj2ecVlVP8iBXwiwb18N8+PU/yXr
         YS9ks/2vebCpTpc5joSXpQ2KZlkmk044GENpuNJ7L1lxjI2cGuXQCFg8taOTNivZQxdt
         DsP5jKema5R3XrQAUSLE8FV2qWiUfnj1vL5zA=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 5/9] phonet: Use for_each_set_bit
Date: Tue,  2 Feb 2010 00:10:36 +0900
Message-Id: <1265037040-23413-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
References: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: rename for_each_bit to for_each_set_bit

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 net/phonet/pn_dev.c     |    3 +--
 net/phonet/pn_netlink.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index bc4a33b..6a18edd 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -107,8 +107,7 @@ static void phonet_device_destroy(struct net_device *dev)
 	if (pnd) {
 		u8 addr;
 
-		for (addr = find_first_bit(pnd->addrs, 64); addr < 64;
-			addr = find_next_bit(pnd->addrs, 64, 1+addr))
+		for_each_set_bit(addr, pnd->addrs, 64)
 			phonet_address_notify(RTM_DELADDR, dev, addr);
 		kfree(pnd);
 	}
diff --git a/net/phonet/pn_netlink.c b/net/phonet/pn_netlink.c
index 2e6c7eb..fe2e708 100644
--- a/net/phonet/pn_netlink.c
+++ b/net/phonet/pn_netlink.c
@@ -141,8 +141,7 @@ static int getaddr_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 			continue;
 
 		addr_idx = 0;
-		for (addr = find_first_bit(pnd->addrs, 64); addr < 64;
-			addr = find_next_bit(pnd->addrs, 64, 1+addr)) {
+		for_each_set_bit(addr, pnd->addrs, 64) {
 			if (addr_idx++ < addr_start_idx)
 				continue;
 
-- 
1.6.0.6

