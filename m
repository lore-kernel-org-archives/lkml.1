Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbXIATqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbXIATqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 15:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757515AbXIATqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 15:46:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:61169 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbXIATqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 15:46:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eVZve75cV9sL0CPTmC65Ib0k9+233RKaCI2/FSOTKyq/9eqznID8GHjoSUgBjv+d5LyRgUJ/K2JrkQyksVTj0zRzX80WTbv9nsKWduWCX8muaNXvLkxZWmr655sJd33Ng55FGvyEf4RDgsmqbFpfw01ysK68OMWBWbnDlTzAzIg=
From: Denis Cheng <crquan@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: [PATCH 2/3] netlink: the temp variable name max is ambiguous
Date: Sun,  2 Sep 2007 03:45:58 +0800
Message-Id: <11886759682348-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.rc7
In-Reply-To: <1188675959178-git-send-email-crquan@gmail.com>
References: <1188675959178-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

with the macro max provided by <linux/kernel.h>, so changed its name to a more proper one: limit

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/netlink/af_netlink.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 8bb14e3..ac3b100 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1885,7 +1885,7 @@ static int __init netlink_proto_init(void)
 {
 	struct sk_buff *dummy_skb;
 	int i;
-	unsigned long max;
+	unsigned long limit;
 	unsigned int order;
 	int err = proto_register(&netlink_proto, 0);
 
@@ -1899,13 +1899,13 @@ static int __init netlink_proto_init(void)
 		goto panic;
 
 	if (num_physpages >= (128 * 1024))
-		max = num_physpages >> (21 - PAGE_SHIFT);
+		limit = num_physpages >> (21 - PAGE_SHIFT);
 	else
-		max = num_physpages >> (23 - PAGE_SHIFT);
+		limit = num_physpages >> (23 - PAGE_SHIFT);
 
-	order = get_bitmask_order(max) - 1 + PAGE_SHIFT;
-	max = (1UL << order) / sizeof(struct hlist_head);
-	order = get_bitmask_order(min(max, (unsigned long)UINT_MAX)) - 1;
+	order = get_bitmask_order(limit) - 1 + PAGE_SHIFT;
+	limit = (1UL << order) / sizeof(struct hlist_head);
+	order = get_bitmask_order(min(limit, (unsigned long)UINT_MAX)) - 1;
 
 	for (i = 0; i < MAX_LINKS; i++) {
 		struct nl_pid_hash *hash = &nl_table[i].hash;
-- 
1.5.3.rc7

