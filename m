Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbXKNIOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbXKNIOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 03:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXKNIOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 03:14:05 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:40458 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbXKNIOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 03:14:04 -0500
Date: Wed, 14 Nov 2007 09:13:59 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: tony.luck@intel.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/4] arch/ia64: Drop unnecessary continue
Message-ID: <Pine.LNX.4.64.0711140913170.26019@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Continue is not needed at the bottom of a loop.

The semantic patch implementing this change is as follows:

@@
statement S;
@@

for (...;...;...) {
   ...
   if (...)
- {
     S
-   continue;
- }
}

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p -b -B a/arch/ia64/sn/kernel/xpnet.c b/arch/ia64/sn/kernel/xpnet.c
--- a/arch/ia64/sn/kernel/xpnet.c 2007-10-22 11:24:57.000000000 +0200
+++ b/arch/ia64/sn/kernel/xpnet.c 2007-11-13 21:56:42.000000000 +0100
@@ -588,10 +588,8 @@ xpnet_dev_hard_start_xmit(struct sk_buff

  		ret = xpc_send_notify(dest_partid, XPC_NET_CHANNEL, msg,
  				      xpnet_send_completed, queued_msg);
-		if (unlikely(ret != xpcSuccess)) {
+		if (unlikely(ret != xpcSuccess))
  			atomic_dec(&queued_msg->use_count);
-			continue;
-		}

  	}

