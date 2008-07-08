Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYGHWNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYGHWNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 18:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbYGHWNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 18:13:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:9724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbYGHWNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 18:13:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,326,1212390000"; 
   d="scan'208";a="304322566"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [RESEND NET-NEXT PATCH 17/20] net: add netif_napi_del function to
	allow for removal of napistructs
To: jeff@garzik.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Alexander Duyck <alexander.h.duyck@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 08 Jul 2008 15:13:05 -0700
Message-ID: <20080708221219.1518.92921.stgit@localhost.localdomain>
In-Reply-To: <20080708220046.1518.88457.stgit@localhost.localdomain>
References: <20080708220046.1518.88457.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2008 22:13:05.0948 (UTC) FILETIME=[CBE095C0:01C8E147]
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
index e009c6f..60cf72e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -832,6 +832,19 @@ static inline void netif_napi_add(struct net_device *dev,
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

