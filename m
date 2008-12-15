Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbYLOO5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbYLOO5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYLOOz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:55:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:26559 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbYLOOzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:55:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,224,1228118400"; 
   d="scan'208";a="370995498"
From: Patrick Ohly <patrick.ohly@intel.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       John Stultz <johnstul@us.ibm.com>, linux-api@vger.kernel.org,
       Patrick Ohly <patrick.ohly@intel.com>
Subject: [RFC PATCH 06/12] debug: NULL pointer check in ip_output
Date: Mon, 15 Dec 2008 15:54:53 +0100
Message-Id: <1229352899-31330-7-git-send-email-patrick.ohly@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229352899-31330-6-git-send-email-patrick.ohly@intel.com>
References: <1229352899-31330-1-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-2-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-3-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-4-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-5-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-6-git-send-email-patrick.ohly@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Patrick Ohly <patrick.ohly@intel.com>
---
 net/ipv4/ip_output.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index ed92f0b..03a6706 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -950,8 +950,14 @@ alloc_new_skb:
 			skb->ip_summed = csummode;
 			skb->csum = 0;
 			skb_reserve(skb, hh_len);
-			if (ipc->shtx.flags)
-				*skb_tx(skb) = ipc->shtx;
+			if (ipc->shtx.flags) {
+				if (skb_tx(skb)) 
+					*skb_tx(skb) = ipc->shtx;
+				else
+					printk(KERN_DEBUG
+						"ERROR: skb with flags %x and no tx ptr\n",
+						ipc->shtx.flags);
+			}
 
 			/*
 			 *	Find where to start putting bytes.
-- 
1.5.5.3

