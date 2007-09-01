Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbXIATqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbXIATqd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 15:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbXIATqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 15:46:23 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:61169 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbXIATqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 15:46:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=HMJLFlG7nCAjVQl7FHVtRL/nmdggwx+EITmIdfB88/UG1lyKOA2XtQS06+Vu3OY6TUPZpq51J46d8rhflZ8KmAdqMIXh+vFpq1GRS7RTn6KWbUQ/bUQ6kb84vq1uX6pKuf53tOfl/RFLw65KaYKwsPx5EuddOwC2xx1c4YNH6bs=
From: Denis Cheng <crquan@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: [PATCH 1/3] netlink: use the macro min(x,y) provided by <linux/kernel.h> instead
Date: Sun,  2 Sep 2007 03:45:57 +0800
Message-Id: <1188675959178-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.rc7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/netlink/af_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5681ce3..8bb14e3 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1905,7 +1905,7 @@ static int __init netlink_proto_init(void)
 
 	order = get_bitmask_order(max) - 1 + PAGE_SHIFT;
 	max = (1UL << order) / sizeof(struct hlist_head);
-	order = get_bitmask_order(max > UINT_MAX ? UINT_MAX : max) - 1;
+	order = get_bitmask_order(min(max, (unsigned long)UINT_MAX)) - 1;
 
 	for (i = 0; i < MAX_LINKS; i++) {
 		struct nl_pid_hash *hash = &nl_table[i].hash;
-- 
1.5.3.rc7

