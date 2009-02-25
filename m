Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbZBYK24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbZBYK24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760093AbZBYK2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:28:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52211 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756515AbZBYK2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:28:45 -0500
Message-ID: <49A51D3D.6080003@cn.fujitsu.com>
Date: Wed, 25 Feb 2009 18:28:13 +0800
From: Wei Yongjun <yjwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] audit: remove some pointless conditionals before kfree_skb()
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some pointless conditionals before kfree_skb().

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 kernel/audit.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index ce6d8ea..35ed3ff 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -531,8 +531,7 @@ struct sk_buff *audit_make_reply(int pid, int seq, int type, int done,
 	return skb;
 
 nlmsg_failure:			/* Used by NLMSG_PUT */
-	if (skb)
-		kfree_skb(skb);
+	kfree_skb(skb);
 	return NULL;
 }
 
@@ -1032,8 +1031,7 @@ static void audit_buffer_free(struct audit_buffer *ab)
 	if (!ab)
 		return;
 
-	if (ab->skb)
-		kfree_skb(ab->skb);
+	kfree_skb(ab->skb);
 
 	spin_lock_irqsave(&audit_freelist_lock, flags);
 	if (audit_freelist_count > AUDIT_MAXFREE)
-- 
1.5.3.8




