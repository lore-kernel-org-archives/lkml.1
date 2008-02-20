Return-Path: <linux-kernel-owner+w=401wt.eu-S1764033AbYBTNtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764033AbYBTNtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbYBTNr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:47:29 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47679 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbYBTNrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:47:21 -0500
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "=?utf-8?q?Ilpo=20J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [RFC PATCH 2/8] [NET]: uninline skb_pull, de-bloats a lot
Date: Wed, 20 Feb 2008 15:47:12 +0200
Message-Id: <1203515238-22848-3-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 1.5.4.2.156.ge3c5
In-Reply-To: <1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-28162  354 funcs, 3005 +, 31167 -, diff: -28162 --- skb_pull

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 include/linux/skbuff.h |   15 +--------------
 net/core/skbuff.c      |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5925435..a9f8f15 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -930,20 +930,7 @@ static inline unsigned char *__skb_pull(struct sk_buff *skb, unsigned int len)
 	return skb->data += len;
 }
 
-/**
- *	skb_pull - remove data from the start of a buffer
- *	@skb: buffer to use
- *	@len: amount of data to remove
- *
- *	This function removes data from the start of a buffer, returning
- *	the memory to the headroom. A pointer to the next data in the buffer
- *	is returned. Once the data has been pulled future pushes will overwrite
- *	the old data.
- */
-static inline unsigned char *skb_pull(struct sk_buff *skb, unsigned int len)
-{
-	return unlikely(len > skb->len) ? NULL : __skb_pull(skb, len);
-}
+extern unsigned char *skb_pull(struct sk_buff *skb, unsigned int len);
 
 extern unsigned char *__pskb_pull_tail(struct sk_buff *skb, int delta);
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 661d439..14f462b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -878,6 +878,22 @@ unsigned char *skb_put(struct sk_buff *skb, unsigned int len)
 }
 EXPORT_SYMBOL(skb_put);
 
+/**
+ *	skb_pull - remove data from the start of a buffer
+ *	@skb: buffer to use
+ *	@len: amount of data to remove
+ *
+ *	This function removes data from the start of a buffer, returning
+ *	the memory to the headroom. A pointer to the next data in the buffer
+ *	is returned. Once the data has been pulled future pushes will overwrite
+ *	the old data.
+ */
+unsigned char *skb_pull(struct sk_buff *skb, unsigned int len)
+{
+	return unlikely(len > skb->len) ? NULL : __skb_pull(skb, len);
+}
+EXPORT_SYMBOL(skb_pull);
+
 /* Trims skb to length len. It can change skb pointers.
  */
 
-- 
1.5.2.2

