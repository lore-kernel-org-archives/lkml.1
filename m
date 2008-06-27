Return-Path: <linux-kernel-owner+w=401wt.eu-S1762800AbYF0SHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762800AbYF0SHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761133AbYF0SCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:02:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:41069 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761057AbYF0SCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:02:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,716,1204531200"; 
   d="scan'208";a="300316101"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [NET-NEXT PATCH 17/18] net: add netif_napi_del function to allow for
	removal of napistructs
To: jeff@garzik.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Date: Fri, 27 Jun 2008 11:02:03 -0700
Message-ID: <20080627180200.22428.70787.stgit@localhost.localdomain>
In-Reply-To: <20080627175921.22428.52767.stgit@localhost.localdomain>
References: <20080627175921.22428.52767.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2008 18:02:03.0717 (UTC) FILETIME=[E78B4750:01C8D87F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>

Adds netif_napi_del function which is used to remove the napi struct from
the netdev napi_list in cases where CONFIG_NETPOLL was enabled.
The motivation for adding this is to handle the case in which the number of
queues on a device changes due to a configuration change.  Previously the
napi structs for each queue would be left in the list until the netdev was
freed.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 include/linux/netdevice.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1304ad2..42fc98e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -826,6 +826,19 @@ static inline void netif_napi_add(struct net_device *dev,
 	set_bit(NAPI_STATE_SCHED, &napi->state);
 }
 
+/**
+ *  netif_napi_del - remove a napi context
+ *  @napi: napi context
+ *
+ *  netif_napi_del() removes a napi context from the network device napi list
+ */
+static inline void netif_napi_del(struct napi_struct *napi)
+{
+#ifdef CONFIG_NETPOLL
+	list_del(&napi->dev_list);
+#endif
+}
+
 struct packet_type {
 	__be16			type;	/* This is really htons(ether_type). */
 	struct net_device	*dev;	/* NULL is wildcarded here	     */

