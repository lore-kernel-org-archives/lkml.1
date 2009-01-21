Return-Path: <linux-kernel-owner+w=401wt.eu-S1759670AbZAUKOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbZAUKOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759655AbZAUKKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:10:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:48370 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758017AbZAUKK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:10:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,299,1231142400"; 
   d="scan'208";a="380250401"
From: Patrick Ohly <patrick.ohly@intel.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       linux-api@vger.kernel.org, Patrick Ohly <patrick.ohly@intel.com>
Subject: [PATCH NET-NEXT 06/12] debug: NULL pointer check in ip_output
Date: Wed, 21 Jan 2009 11:10:06 +0100
Message-Id: <1232532612-10382-6-git-send-email-patrick.ohly@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1232532612-10382-5-git-send-email-patrick.ohly@intel.com>
References: <1232532457.7829.19.camel@ecld0pohly>
 <1232532612-10382-1-git-send-email-patrick.ohly@intel.com>
 <1232532612-10382-2-git-send-email-patrick.ohly@intel.com>
 <1232532612-10382-3-git-send-email-patrick.ohly@intel.com>
 <1232532612-10382-4-git-send-email-patrick.ohly@intel.com>
 <1232532612-10382-5-git-send-email-patrick.ohly@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

