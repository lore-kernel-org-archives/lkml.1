Return-Path: <linux-kernel-owner+w=401wt.eu-S1751115Ab0AaL5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751115Ab0AaL5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 06:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788Ab0AaL5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 06:57:17 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:64089 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab0AaL5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 06:57:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WiNki5uDEWPpu6OB+DWfA2vBSulOOTEf0EMbrjTG8fqwBTPzICUF3cigIOVgS33jDz
         vVippdXlel2q8NlybKez8hM+pWHq0Cn9/GjSK4M2Z5tQn+/OJmgRRKUl2Ldb8Bv4VSCd
         /3mLIWjnRVdYkoWzqs+lownF89U2dDNoDlJM8=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 3/7] phonet: Use for_each_bit
Date: Sun, 31 Jan 2010 20:53:26 +0900
Message-Id: <1264938810-4173-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
References: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 net/phonet/pn_dev.c     |    3 +--
 net/phonet/pn_netlink.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index bc4a33b..52edfc4 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -107,8 +107,7 @@ static void phonet_device_destroy(struct net_device *dev)
 	if (pnd) {
 		u8 addr;
 
-		for (addr = find_first_bit(pnd->addrs, 64); addr < 64;
-			addr = find_next_bit(pnd->addrs, 64, 1+addr))
+		for_each_bit(addr, pnd->addrs, 64)
 			phonet_address_notify(RTM_DELADDR, dev, addr);
 		kfree(pnd);
 	}
diff --git a/net/phonet/pn_netlink.c b/net/phonet/pn_netlink.c
index 2e6c7eb..4edc048 100644
--- a/net/phonet/pn_netlink.c
+++ b/net/phonet/pn_netlink.c
@@ -141,8 +141,7 @@ static int getaddr_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 			continue;
 
 		addr_idx = 0;
-		for (addr = find_first_bit(pnd->addrs, 64); addr < 64;
-			addr = find_next_bit(pnd->addrs, 64, 1+addr)) {
+		for_each_bit(addr, pnd->addrs, 64) {
 			if (addr_idx++ < addr_start_idx)
 				continue;
 
-- 
1.6.0.6

