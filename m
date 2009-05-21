Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZEUCd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZEUCd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 22:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZEUCdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 22:33:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:24641 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbZEUCdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 22:33:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=J8hONrcVn6BHISI0oBucQ/xcrjuIWZSEzXsZHRX2QjdBBizU6Q4MRKFG6fW3UT2ExU
         hi+W6HyEh88fiMkccIzz65SWFJUrTL6nt1WTNNDr9fmlVmY9iDh2FZJFbDWgH3Bypced
         HqyMXRUI3a8Xey9fPF9SjlTw4NnyMWOZIJ7Ro=
Date: Thu, 21 May 2009 10:31:11 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com
Subject: [PATCH] remove function audit_receive_filter here in kerenl/audit.c
Message-ID: <20090521023111.GA4863@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


both case AUDIT_LIST: and case AUDIT_LIST_RULES: call this function
audit_receive_filter in the same way, so I think we can put them together
by removing another one.


Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 kernel/audit.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 9442c35..40fc803 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -790,6 +790,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		}
 		/* fallthrough */
 	case AUDIT_LIST:
+	case AUDIT_LIST_RULES:
 		err = audit_receive_filter(msg_type, NETLINK_CB(skb).pid,
 					   uid, seq, data, nlmsg_len(nlh),
 					   loginuid, sessionid, sid);
@@ -807,12 +808,6 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			audit_log_end(ab);
 			return -EPERM;
 		}
-		/* fallthrough */
-	case AUDIT_LIST_RULES:
-		err = audit_receive_filter(msg_type, NETLINK_CB(skb).pid,
-					   uid, seq, data, nlmsg_len(nlh),
-					   loginuid, sessionid, sid);
-		break;
 	case AUDIT_TRIM:
 		audit_trim_trees();
 
-- 
1.5.6.5

-- 
--------------------------------
http://zhwen.org - Open and Free
