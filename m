Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZETFfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZETFfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 01:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbZETFfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 01:35:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:42229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbZETFfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 01:35:31 -0400
Subject: [PATCH -tip] Documentation/connector/cn_test.c remove unused
 cn_test_want_notify()
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 May 2009 11:04:53 +0530
Message-Id: <1242797693.3260.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently cn_test_want_notify() is not having any user.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 Documentation/connector/cn_test.c |   77 -------------------------------------
 1 files changed, 0 insertions(+), 77 deletions(-)

diff --git a/Documentation/connector/cn_test.c b/Documentation/connector/cn_test.c
index 6977c17..e12d9d7 100644
--- a/Documentation/connector/cn_test.c
+++ b/Documentation/connector/cn_test.c
@@ -41,83 +41,6 @@ void cn_test_callback(void *data)
 	       msg->seq, msg->ack, msg->len, (char *)msg->data);
 }
 
-static int cn_test_want_notify(void)
-{
-	struct cn_ctl_msg *ctl;
-	struct cn_notify_req *req;
-	struct cn_msg *msg = NULL;
-	int size, size0;
-	struct sk_buff *skb;
-	struct nlmsghdr *nlh;
-	u32 group = 1;
-
-	size0 = sizeof(*msg) + sizeof(*ctl) + 3 * sizeof(*req);
-
-	size = NLMSG_SPACE(size0);
-
-	skb = alloc_skb(size, GFP_ATOMIC);
-	if (!skb) {
-		printk(KERN_ERR "Failed to allocate new skb with size=%u.\n",
-		       size);
-
-		return -ENOMEM;
-	}
-
-	nlh = NLMSG_PUT(skb, 0, 0x123, NLMSG_DONE, size - sizeof(*nlh));
-
-	msg = (struct cn_msg *)NLMSG_DATA(nlh);
-
-	memset(msg, 0, size0);
-
-	msg->id.idx = -1;
-	msg->id.val = -1;
-	msg->seq = 0x123;
-	msg->ack = 0x345;
-	msg->len = size0 - sizeof(*msg);
-
-	ctl = (struct cn_ctl_msg *)(msg + 1);
-
-	ctl->idx_notify_num = 1;
-	ctl->val_notify_num = 2;
-	ctl->group = group;
-	ctl->len = msg->len - sizeof(*ctl);
-
-	req = (struct cn_notify_req *)(ctl + 1);
-
-	/*
-	 * Idx.
-	 */
-	req->first = cn_test_id.idx;
-	req->range = 10;
-
-	/*
-	 * Val 0.
-	 */
-	req++;
-	req->first = cn_test_id.val;
-	req->range = 10;
-
-	/*
-	 * Val 1.
-	 */
-	req++;
-	req->first = cn_test_id.val + 20;
-	req->range = 10;
-
-	NETLINK_CB(skb).dst_group = ctl->group;
-	//netlink_broadcast(nls, skb, 0, ctl->group, GFP_ATOMIC);
-	netlink_unicast(nls, skb, 0, 0);
-
-	printk(KERN_INFO "Request was sent. Group=0x%x.\n", ctl->group);
-
-	return 0;
-
-nlmsg_failure:
-	printk(KERN_ERR "Failed to send %u.%u\n", msg->seq, msg->ack);
-	kfree_skb(skb);
-	return -EINVAL;
-}
-
 static u32 cn_test_timer_counter;
 static void cn_test_timer_func(unsigned long __data)
 {
-- 
1.6.1.1



