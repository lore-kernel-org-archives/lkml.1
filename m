Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYEPCOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYEPCOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 22:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYEPCOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 22:14:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57885 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbYEPCOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 22:14:42 -0400
Message-ID: <482CEE28.7040005@cn.fujitsu.com>
Date: Fri, 16 May 2008 10:15:04 +0800
From: Peng Haitao <penght@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH] kernel/audit.c: nlh->nlmsg_type is gotten more than once
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first argument "nlh->nlmsg_type" of audit_receive_filter() should be modified to "msg_type" in audit_receive_msg().

Signed-off-by: Peng Haitao <penght@cn.fujitsu.com>

---
 kernel/audit.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index b782b04..48fa3d0 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -686,7 +686,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		}
 		/* fallthrough */
 	case AUDIT_LIST:
-		err = audit_receive_filter(nlh->nlmsg_type, NETLINK_CB(skb).pid,
+		err = audit_receive_filter(msg_type, NETLINK_CB(skb).pid,
 					   uid, seq, data, nlmsg_len(nlh),
 					   loginuid, sid);
 		break;
@@ -705,7 +705,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		}
 		/* fallthrough */
 	case AUDIT_LIST_RULES:
-		err = audit_receive_filter(nlh->nlmsg_type, NETLINK_CB(skb).pid,
+		err = audit_receive_filter(msg_type, NETLINK_CB(skb).pid,
 					   uid, seq, data, nlmsg_len(nlh),
 					   loginuid, sid);
 		break;
-- 
1.5.3

-- 
Regards
Peng Haitao

