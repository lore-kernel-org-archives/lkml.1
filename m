Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbZDSOFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbZDSOFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 10:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759505AbZDSOFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 10:05:34 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:42043 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034AbZDSOFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 10:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=rDxnXZl3pldA5jqBY76k9+zmHehZiFZFFBNiuvU5k6h+kt9Ezt+faxHMrUNmuGNTG7
         1SaGnOKu7AxdZ+JZwWFpV7LxITxiPstSalKZerdbHbcKgP/ASlFCuhEUzvA4JUpisTWo
         KExXrSDcyguMKzsruuFWo1dpA6hUV95+MRQTc=
Date: Sun, 19 Apr 2009 22:03:55 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, linux-audit@redhat.com
Subject: [PATCH] this mutex_lock is miss used
Message-ID: <20090419140355.GA16609@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This mutex_lock and mutex_unlock has no use in such way.
It should be like this way:

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
---
 kernel/audit.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 9442c35..3176ffa 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -485,12 +485,11 @@ int audit_send_list(void *_dest)
 
 	/* wait for parent to finish and send an ACK */
 	mutex_lock(&audit_cmd_mutex);
-	mutex_unlock(&audit_cmd_mutex);
-
 	while ((skb = __skb_dequeue(&dest->q)) != NULL)
 		netlink_unicast(audit_sock, skb, pid, 0);
 
 	kfree(dest);
+	mutex_unlock(&audit_cmd_mutex);
 
 	return 0;
 }
-- 
1.5.6.5

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn
