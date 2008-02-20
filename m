Return-Path: <linux-kernel-owner+w=401wt.eu-S1764205AbYBTNtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764205AbYBTNtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761465AbYBTNrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:47:36 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44100 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbYBTNrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:47:21 -0500
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "=?utf-8?q?Ilpo=20J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [RFC PATCH 6/8] [NET]: uninline skb_trim, de-bloats
Date: Wed, 20 Feb 2008 15:47:16 +0200
Message-Id: <1203515238-22848-7-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 1.5.4.2.156.ge3c5
In-Reply-To: <1203515238-22848-6-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-3-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-4-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-5-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-6-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-10976  209 funcs, 123 +, 11099 -, diff: -10976 --- skb_trim

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 include/linux/skbuff.h |   16 +---------------
 net/core/skbuff.c      |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c11f248..75d8a66 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1156,21 +1156,7 @@ static inline void __skb_trim(struct sk_buff *skb, unsigned int len)
 	skb_set_tail_pointer(skb, len);
 }
 
-/**
- *	skb_trim - remove end from a buffer
- *	@skb: buffer to alter
- *	@len: new length
- *
- *	Cut the length of a buffer down by removing data from the tail. If
- *	the buffer is already under the length specified it is not modified.
- *	The skb must be linear.
- */
-static inline void skb_trim(struct sk_buff *skb, unsigned int len)
-{
-	if (skb->len > len)
-		__skb_trim(skb, len);
-}
-
+extern void skb_trim(struct sk_buff *skb, unsigned int len);
 
 static inline int __pskb_trim(struct sk_buff *skb, unsigned int len)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 05d43fd..b57cadb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -931,6 +931,22 @@ unsigned char *skb_pull(struct sk_buff *skb, unsigned int len)
 }
 EXPORT_SYMBOL(skb_pull);
 
+/**
+ *	skb_trim - remove end from a buffer
+ *	@skb: buffer to alter
+ *	@len: new length
+ *
+ *	Cut the length of a buffer down by removing data from the tail. If
+ *	the buffer is already under the length specified it is not modified.
+ *	The skb must be linear.
+ */
+void skb_trim(struct sk_buff *skb, unsigned int len)
+{
+	if (skb->len > len)
+		__skb_trim(skb, len);
+}
+EXPORT_SYMBOL(skb_trim);
+
 /* Trims skb to length len. It can change skb pointers.
  */
 
-- 
1.5.2.2

