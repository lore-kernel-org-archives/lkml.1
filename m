Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbXE1Clb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbXE1Clb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 22:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbXE1ClW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 22:41:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:1480 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbXE1ClV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 22:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pG/ikVtq16NDUMwHrCttgMYIFJ3f3fUANwUCo4wt5yqxe9tUCK3tW76u/Ar7OrrYDGkFXjFLs8j4vbCsgpWFgstj5nf6r+CYLccXXHFtu/hkM5NmyysCriJQgSu9uLTmsfhBX+tkHRh1sJiw9zSyiiqJvZcrfJZQUp07aabxJv8=
Message-ID: <91b13c310705271941n48e266b9vc202b862ad4fabba@mail.gmail.com>
Date: Mon, 28 May 2007 10:41:20 +0800
From: "rae l" <crquan@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] merge dst_discard in & out into one, this decrements the vmlinux image by 21 bytes under i386 arch.
Cc: "Networking Team" <netdev@vger.kernel.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <trivial@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng

thus the definition of dst_discard_in and dst_discard_out is the same,
we can define a dst_discard function and map the _in and _out to it,
this can reduce space in vmlinux.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---

diff --git a/net/core/dst.c b/net/core/dst.c
index 764bccb..daa0439 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -111,17 +111,14 @@ out:
        spin_unlock(&dst_lock);
 }

-static int dst_discard_in(struct sk_buff *skb)
+static int dst_discard(struct sk_buff *skb)
 {
        kfree_skb(skb);
        return 0;
 }

-static int dst_discard_out(struct sk_buff *skb)
-{
-       kfree_skb(skb);
-       return 0;
-}
+#define dst_discard_in dst_discard
+#define dst_discard_out        dst_discard

 void * dst_alloc(struct dst_ops * ops)
 {


-- 
Denis Cheng
Linux Application Developer
